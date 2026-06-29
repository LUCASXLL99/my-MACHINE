# Canto superior direito → niri toggle-overview
# Usa evdev direto (/dev/input) — resiliente a plug/unplug e reinício.

{ pkgs, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.evdev ]);

  script = pkgs.writeShellScriptBin "niri-hot-corner-right" ''
    exec ${python}/bin/python3 - << 'PYEOF'
import asyncio, subprocess, os, glob, json, time, struct, ctypes
from evdev import InputDevice, ecodes

THRESHOLD = int(os.environ.get("HOT_CORNER_THRESHOLD", "8"))
COOLDOWN  = float(os.environ.get("HOT_CORNER_COOLDOWN", "1.5"))

# ── niri ──────────────────────────────────────────────────────────────────────

def niri_env():
    env  = {**os.environ}
    hits = glob.glob(f"/run/user/{os.getuid()}/niri.*.sock")
    sock = os.environ.get("NIRI_SOCKET", hits[0] if hits else "")
    if sock and os.path.exists(sock):
        env["NIRI_SOCKET"] = sock
    return env

def niri_cmd(*args):
    return subprocess.run(["niri", "msg", *args],
                          capture_output=True, text=True, timeout=3, env=niri_env())

def get_screen_dims():
    for attempt in range(20):
        try:
            r = niri_cmd("-j", "outputs")
            if r.returncode == 0:
                for out in json.loads(r.stdout).values():
                    idx, modes = out.get("current_mode"), out.get("modes", [])
                    if not modes:
                        continue
                    m     = modes[idx] if isinstance(idx, int) else modes[0]
                    scale = out.get("scale") or 1.0
                    return int(m["width"] / scale), int(m["height"] / scale)
        except Exception:
            pass
        print(f"[hot-corner] aguardando niri... ({attempt+1}/20)", flush=True)
        time.sleep(1)
    print("[hot-corner] fallback 1920×1080", flush=True)
    return 1920, 1080

def trigger():
    niri_cmd("action", "toggle-overview")

# ── devices ───────────────────────────────────────────────────────────────────

def is_mouse(path):
    try:
        caps = InputDevice(path).capabilities()
        rel  = caps.get(ecodes.EV_REL, [])
        return ecodes.REL_X in rel and ecodes.REL_Y in rel
    except Exception:
        return False

def has_inv():
    return any(
        "[inv]" in InputDevice(p).name
        for p in glob.glob("/dev/input/event*")
        if _safe_name(p)
    )

def _safe_name(path):
    try:
        return InputDevice(path).name
    except Exception:
        return ""

def should_monitor(path):
    if not is_mouse(path):
        return False
    name = _safe_name(path)
    return ("[inv]" in name) if has_inv() else bool(name)

# ── estado global ─────────────────────────────────────────────────────────────

W = H = 0
cx = cy = last_trigger = 0.0
monitored  = set()
state_lock = asyncio.Lock()

# ── handlers ──────────────────────────────────────────────────────────────────

async def handle(dev):
    global cx, cy, last_trigger
    print(f"[hot-corner] +{dev.name} ({dev.path})", flush=True)
    try:
        async for ev in dev.async_read_loop():
            if ev.type != ecodes.EV_REL:
                continue
            async with state_lock:
                if ev.code == ecodes.REL_X:
                    cx = max(0.0, min(float(W), cx + ev.value))
                elif ev.code == ecodes.REL_Y:
                    cy = max(0.0, min(float(H), cy + ev.value))
                in_corner = cx >= W - THRESHOLD and cy <= THRESHOLD
            if in_corner:
                now = time.monotonic()
                if now - last_trigger >= COOLDOWN:
                    print(f"[hot-corner] trigger! ({cx:.0f},{cy:.0f})", flush=True)
                    trigger()
                    last_trigger = now
    except Exception as e:
        print(f"[hot-corner] -{dev.name} ({e})", flush=True)
    finally:
        monitored.discard(dev.path)

def spawn(path):
    if path in monitored or not should_monitor(path):
        return
    monitored.add(path)
    try:
        asyncio.ensure_future(handle(InputDevice(path)))
    except Exception as e:
        print(f"[hot-corner] erro {path}: {e}", flush=True)
        monitored.discard(path)

async def device_watcher():
    libc       = ctypes.cdll.LoadLibrary("libc.so.6")
    IN_CREATE  = 0x00000100
    IN_DELETE  = 0x00000200
    HDR        = struct.Struct("iIII")
    ifd        = libc.inotify_init()
    libc.inotify_add_watch(ifd, b"/dev/input", IN_CREATE | IN_DELETE)
    loop       = asyncio.get_event_loop()
    f          = os.fdopen(ifd, "rb", 0)

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

# ── main ──────────────────────────────────────────────────────────────────────

async def main():
    global W, H, cx, cy
    W, H   = get_screen_dims()
    cx, cy = W / 2.0, H / 2.0
    print(f"[hot-corner] {W}×{H} threshold={THRESHOLD}px", flush=True)
    for path in sorted(glob.glob("/dev/input/event*")):
        spawn(path)
    await device_watcher()

asyncio.run(main())
PYEOF
  '';
in
{
  home.packages = [ script ];

  systemd.user.services.niri-hot-corner = {
    Unit = {
      Description = "Hot corner superior direito → niri overview";
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
