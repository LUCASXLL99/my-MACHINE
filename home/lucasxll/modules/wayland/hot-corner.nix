# Canto superior direito -> mango toggleoverview
# PORTADO niri -> mango. mango 25.08 nao tem cursor-position -- usa delta REL_X/REL_Y.
# Resync: watch de "all-monitors" via mmsg (proxy p/ suspend/resume) e idle timeout.
#
# NOTA: adaptei niri_env/niri_cmd para o IPC do mango (mmsg + var de ambiente
# MANGO_INSTANCE_SIGNATURE), seguindo a doc oficial (mangowm.github.io/docs/ipc).
# O glob do socket ("mango.*.sock") é um chute educado baseado no padrão do
# niri -- se não bater, ajusta em /run/user/$UID/ depois de logar no mango
# (`ls /run/user/$(id -u)/`) e corrige o glob abaixo.

{ config, pkgs, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.evdev ]);

  script = pkgs.writeShellScriptBin "mango-hot-corner-right" ''
    exec ${python}/bin/python3 << 'PYEOF'
import asyncio, subprocess, os, glob, json, time, struct, ctypes
from evdev import InputDevice, ecodes

CORNER_SIZE   = int(os.environ.get("HOT_CORNER_SIZE",    "8"))
COOLDOWN      = float(os.environ.get("HOT_CORNER_COOLDOWN", "1.2"))
IDLE_RESYNC   = float(os.environ.get("HOT_CORNER_IDLE",    "10.0"))

# estado
W = H = 0
cx = cy = 0.0
last_move    = 0.0
last_trigger = 0.0
monitored    = set()
lock         = None   # asyncio.Lock, criado em main()

def log(msg):
    print(f"[hot-corner] {msg}", flush=True)

# mango ipc (mmsg)
def mango_env():
    env  = {**os.environ}
    hits = glob.glob(f"/run/user/{os.getuid()}/mango.*.sock") or glob.glob(f"/run/user/{os.getuid()}/mango*")
    sock = os.environ.get("MANGO_INSTANCE_SIGNATURE")
    if not sock or not os.path.exists(sock):
        # escolhe o socket mais recente (por mtime) — evita pegar um antigo
        # depois do mango ter reiniciado e ficado com socket novo
        candidates = [h for h in hits if os.path.exists(h)]
        if candidates:
            sock = max(candidates, key=os.path.getmtime)
    if sock and os.path.exists(sock):
        env["MANGO_INSTANCE_SIGNATURE"] = sock
    return env

def mango_cmd(*args, timeout=3):
    return subprocess.run(["mmsg", *args],
                          capture_output=True, text=True,
                          timeout=timeout, env=mango_env())

def get_screen_dims():
    for attempt in range(20):
        try:
            r = mango_cmd("get", "all-monitors")
            if r.returncode == 0:
                data = json.loads(r.stdout)
                # mmsg retorna {"monitors": [ ... ]}, não um array solto
                mons = data.get("monitors") or []
                for out in mons:
                    width  = out.get("width")
                    height = out.get("height")
                    scale  = out.get("scale") or 1.0
                    if width and height:
                        return int(width / scale), int(height / scale)
        except Exception:
            pass
        log(f"aguardando mango... ({attempt+1}/20)")
        time.sleep(1)
    log("fallback 1920x1080")
    return 1920, 1080

def trigger():
    mango_cmd("dispatch", "toggleoverview")

# deteccao de mouses
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

async def do_resync(reason=""):
    global cx, cy
    async with lock:
        cx = W / 2.0
        cy = H / 2.0
    suffix = (" [" + reason + "]") if reason else ""
    log("resync -> centro (" + str(int(cx)) + "," + str(int(cy)) + ")" + suffix)

# resync ao acordar do suspend (proxy: qualquer atualizacao de all-monitors)
async def mango_event_watcher():
    env = mango_env()
    while True:
        try:
            proc = await asyncio.create_subprocess_exec(
                "mmsg", "watch", "all-monitors",
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.DEVNULL,
                env=env,
            )
            async for raw in proc.stdout:
                line = raw.decode(errors="ignore").strip()
                if not line:
                    continue
                log("mango: all-monitors mudou (suspend/resume?) -> resync")
                await do_resync("all-monitors")
            await proc.wait()
        except Exception as e:
            log(f"watch all-monitors erro: {e}")
        await asyncio.sleep(3)

# resync apos mouse parado
async def idle_watcher():
    global last_move
    while True:
        await asyncio.sleep(2)
        idle = time.monotonic() - last_move
        if idle >= IDLE_RESYNC and (time.monotonic() - last_trigger) > 5.0:
            await do_resync("idle " + str(int(idle)) + "s")
            last_move = time.monotonic()

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

# hot-plug de dispositivos
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

async def main():
    global W, H, cx, cy, last_move, lock
    lock     = asyncio.Lock()
    W, H     = get_screen_dims()
    cx, cy   = W / 2.0, H / 2.0
    last_move = time.monotonic()
    log(f"{W}x{H} corner={CORNER_SIZE}px cooldown={COOLDOWN}s idle-resync={IDLE_RESYNC}s")
    for path in sorted(glob.glob("/dev/input/event*")):
        spawn(path)
    asyncio.ensure_future(mango_event_watcher())
    asyncio.ensure_future(idle_watcher())
    await device_watcher()

asyncio.run(main())
PYEOF
  '';
in
{
  home.packages = [ script ];

  systemd.user.services.mango-hot-corner = {
    Unit = {
      Description = "Hot corner superior direito -> mango overview";
      After   = [ "mango-session.target" ];
      BindsTo = [ "mango-session.target" ];
    };
    Service = {
      ExecStart = "${script}/bin/mango-hot-corner-right";
      # mmsg não herda o PATH do shell em systemd user — sem isso o hot-corner
      # não acha o binário (`No such file or directory: 'mmsg'`).
      Environment = "PATH=${config.wayland.windowManager.mango.package}/bin:/run/current-system/sw/bin";
      Restart    = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "mango-session.target" ];
  };
}
