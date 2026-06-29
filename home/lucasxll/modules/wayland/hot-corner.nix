# Canto superior direito -> niri toggle-overview
# niri 25.08 nao tem cursor-position -- usa delta REL_X/REL_Y.
# Resync via niri event-stream: ConfigLoaded (suspend/resume) e idle timeout.

{ pkgs, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.evdev ]);

  script = pkgs.writeShellScriptBin "niri-hot-corner-right" ''
    exec ${python}/bin/python3 << 'PYEOF'
import asyncio, subprocess, os, glob, json, time, struct, ctypes
from evdev import InputDevice, ecodes

CORNER_SIZE   = int(os.environ.get("HOT_CORNER_SIZE",    "8"))
COOLDOWN      = float(os.environ.get("HOT_CORNER_COOLDOWN", "1.2"))
IDLE_RESYNC   = float(os.environ.get("HOT_CORNER_IDLE",    "10.0"))

# --- estado global ---
W = H = 0
cx = cy = 0.0
last_move    = 0.0
last_trigger = 0.0
monitored    = set()
lock         = None   # asyncio.Lock, criado em main()

def log(msg):
    print(f"[hot-corner] {msg}", flush=True)

# --- niri helpers ---
def niri_env():
    env  = {**os.environ}
    hits = glob.glob(f"/run/user/{os.getuid()}/niri.*.sock")
    sock = os.environ.get("NIRI_SOCKET", hits[0] if hits else "")
    if sock and os.path.exists(sock):
        env["NIRI_SOCKET"] = sock
    return env

def niri_cmd(*args, timeout=3):
    return subprocess.run(["niri", "msg", *args],
                          capture_output=True, text=True,
                          timeout=timeout, env=niri_env())

def get_screen_dims():
    for attempt in range(20):
        try:
            r = niri_cmd("-j", "outputs")
            if r.returncode == 0:
                for out in json.loads(r.stdout).values():
                    idx   = out.get("current_mode")
                    modes = out.get("modes", [])
                    if not modes:
                        continue
                    m     = modes[idx] if isinstance(idx, int) else modes[0]
                    scale = out.get("scale") or 1.0
                    return int(m["width"] / scale), int(m["height"] / scale)
        except Exception:
            pass
        log(f"aguardando niri... ({attempt+1}/20)")
        time.sleep(1)
    log("fallback 1920x1080")
    return 1920, 1080

def trigger():
    niri_cmd("action", "toggle-overview")

# --- deteccao de dispositivos ---
def _caps(path):
    try:
        return InputDevice(path).capabilities()
    except Exception:
        return {}

def is_mouse(path):
    caps = _caps(path)
    rel  = caps.get(ecodes.EV_REL, [])
    return ecodes.REL_X in rel and ecodes.REL_Y in rel

def _name(path):
    try:
        return InputDevice(path).name
    except Exception:
        return ""

def has_inv_devices():
    return any("[inv]" in _name(p) for p in glob.glob("/dev/input/event*"))

def should_monitor(path):
    if not is_mouse(path):
        return False
    name = _name(path)
    if not name:
        return False
    return ("[inv]" in name) if has_inv_devices() else True

# --- resync ---
async def do_resync(reason=""):
    global cx, cy
    async with lock:
        cx = W / 2.0
        cy = H / 2.0
    suffix = (" [" + reason + "]") if reason else ""
    log("resync -> centro (" + str(int(cx)) + "," + str(int(cy)) + ")" + suffix)

# --- event-stream watcher (resync em ConfigLoaded = suspend/resume) ---
async def niri_event_watcher():
    env = niri_env()
    while True:
        try:
            proc = await asyncio.create_subprocess_exec(
                "niri", "msg", "event-stream",
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.DEVNULL,
                env=env,
            )
            async for raw in proc.stdout:
                line = raw.decode(errors="ignore").strip()
                if not line:
                    continue
                try:
                    ev = json.loads(line)
                except Exception:
                    continue
                if "ConfigLoaded" in ev:
                    log("niri recarregou (suspend/resume?) -> resync")
                    await do_resync("ConfigLoaded")
            await proc.wait()
        except Exception as e:
            log(f"event-stream erro: {e}")
        await asyncio.sleep(3)

# --- idle watcher (resync se mouse parado > IDLE_RESYNC segundos) ---
async def idle_watcher():
    global last_move
    while True:
        await asyncio.sleep(2)
        idle = time.monotonic() - last_move
        if idle >= IDLE_RESYNC and (time.monotonic() - last_trigger) > 5.0:
            await do_resync("idle " + str(int(idle)) + "s")
            last_move = time.monotonic()

# --- handler de dispositivo ---
async def handle(dev):
    global cx, cy, last_move, last_trigger
    log(f"+{dev.name} ({dev.path})")
    try:
        async for ev in dev.async_read_loop():
            if ev.type != ecodes.EV_REL:
                continue
            last_move = time.monotonic()
            async with lock:
                if ev.code == ecodes.REL_X:
                    cx = max(0.0, min(float(W), cx + ev.value))
                elif ev.code == ecodes.REL_Y:
                    cy = max(0.0, min(float(H), cy + ev.value))
                in_corner = cx >= W - CORNER_SIZE and cy <= CORNER_SIZE
            if in_corner:
                now = time.monotonic()
                if now - last_trigger >= COOLDOWN:
                    log(f"trigger! ({cx:.0f},{cy:.0f})")
                    trigger()
                    last_trigger = now
    except Exception as e:
        log(f"-{dev.name} ({e})")
    finally:
        monitored.discard(dev.path)

def spawn(path):
    if path in monitored or not should_monitor(path):
        return
    monitored.add(path)
    try:
        asyncio.ensure_future(handle(InputDevice(path)))
    except Exception as e:
        log(f"erro ao abrir {path}: {e}")
        monitored.discard(path)

# --- inotify watcher para hot-plug ---
async def device_watcher():
    libc      = ctypes.cdll.LoadLibrary("libc.so.6")
    IN_CREATE = 0x00000100
    IN_DELETE = 0x00000200
    HDR       = struct.Struct("iIII")
    ifd       = libc.inotify_init()
    libc.inotify_add_watch(ifd, b"/dev/input", IN_CREATE | IN_DELETE)
    loop = asyncio.get_event_loop()
    f    = os.fdopen(ifd, "rb", 0)
    while True:
        data = await loop.run_in_executor(None, f.read, HDR.size + 256)
        if not data:
            break
        _, mask, _, length = HDR.unpack_from(data)
        name = data[HDR.size:HDR.size + length].rstrip(b"\x00").decode(errors="ignore")
        if not name.startswith("event"):
            continue
        path = f"/dev/input/{name}"
        if mask & IN_CREATE:
            await asyncio.sleep(0.15)
            spawn(path)
        elif mask & IN_DELETE:
            monitored.discard(path)

# --- main ---
async def main():
    global W, H, cx, cy, last_move, lock
    lock     = asyncio.Lock()
    W, H     = get_screen_dims()
    cx, cy   = W / 2.0, H / 2.0
    last_move = time.monotonic()
    log(f"{W}x{H} corner={CORNER_SIZE}px cooldown={COOLDOWN}s idle-resync={IDLE_RESYNC}s")
    for path in sorted(glob.glob("/dev/input/event*")):
        spawn(path)
    asyncio.ensure_future(niri_event_watcher())
    asyncio.ensure_future(idle_watcher())
    await device_watcher()

asyncio.run(main())
PYEOF
  '';
in
{
  home.packages = [ script ];

  systemd.user.services.niri-hot-corner = {
    Unit = {
      Description = "Hot corner superior direito -> niri overview";
      After   = [ "niri.service" ];
      BindsTo = [ "niri.service" ];
    };
    Service = {
      ExecStart = "${script}/bin/niri-hot-corner-right";
      Restart    = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "niri.service" ];
  };
}
