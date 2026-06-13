# home/lucasxll/modules/hot-corner.nix
#
# Detecta o canto superior direito e chama 'niri msg action toggle-overview'.
#
# Lê eventos REL_X/REL_Y diretamente dos /dev/input via evdev.
# Resiliente a: plug/unplug em runtime, reinício sem mouse externo,
# serviço subindo antes do niri, dessincronização de posição acumulada.

{ pkgs, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.evdev ]);

  script = pkgs.writeShellScriptBin "niri-hot-corner-right" ''
    exec ${python}/bin/python3 - << 'PYEOF'
import asyncio, subprocess, os, glob, json, time, struct
import evdev
from evdev import InputDevice, ecodes

THRESHOLD = int(os.environ.get("HOT_CORNER_THRESHOLD", "8"))
COOLDOWN  = float(os.environ.get("HOT_CORNER_COOLDOWN", "1.5"))

# ── niri helpers ──────────────────────────────────────────────────────────────

def niri_socket():
    s = os.environ.get("NIRI_SOCKET", "")
    if s and os.path.exists(s):
        return s
    hits = glob.glob(f"/run/user/{os.getuid()}/niri.*.sock")
    return hits[0] if hits else None

def niri_env():
    env = {**os.environ}
    sock = niri_socket()
    if sock:
        env["NIRI_SOCKET"] = sock
    return env

def niri_cmd(*args):
    return subprocess.run(["niri", "msg", *args], capture_output=True, text=True,
                          timeout=3, env=niri_env())

def get_screen_dims():
    """Tenta até conseguir — serviço pode subir antes do niri estar pronto."""
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
        print(f"[hot-corner] aguardando niri... (tentativa {attempt+1}/20)", flush=True)
        time.sleep(1)
    print("[hot-corner] fallback 1920×1080", flush=True)
    return 1920, 1080

def trigger():
    niri_cmd("action", "toggle-overview")

# ── device helpers ────────────────────────────────────────────────────────────

def is_mouse_device(path):
    try:
        dev = InputDevice(path)
        caps = dev.capabilities()
        if ecodes.EV_REL in caps:
            rel = caps[ecodes.EV_REL]
            return ecodes.REL_X in rel and ecodes.REL_Y in rel
    except Exception:
        pass
    return False

def has_inv_devices():
    for path in glob.glob("/dev/input/event*"):
        try:
            if "[inv]" in InputDevice(path).name:
                return True
        except Exception:
            pass
    return False

def should_monitor(path):
    """
    Se kanata está ativo: monitora só [inv] (evita contar deltas em dobro).
    Se kanata não está: monitora todos os mouse devices.
    """
    if not is_mouse_device(path):
        return False
    try:
        name = InputDevice(path).name
        if has_inv_devices():
            return "[inv]" in name
        return True
    except Exception:
        return False

# ── estado global ─────────────────────────────────────────────────────────────

W, H         = 1920, 1080
cx = cy      = 0.0
last_trigger = 0.0
monitored    = set()
state_lock   = asyncio.Lock()

# ── handler por device ────────────────────────────────────────────────────────

async def handle(dev):
    global cx, cy, last_trigger
    print(f"[hot-corner] +monitorando: {dev.name} ({dev.path})", flush=True)
    try:
        async for event in dev.async_read_loop():
            if event.type == ecodes.EV_REL:
                async with state_lock:
                    if event.code == ecodes.REL_X:
                        cx = max(0.0, min(float(W), cx + event.value))
                    elif event.code == ecodes.REL_Y:
                        cy = max(0.0, min(float(H), cy + event.value))
                    in_corner = cx >= W - THRESHOLD and cy <= THRESHOLD

                if in_corner:
                    now = time.monotonic()
                    if now - last_trigger >= COOLDOWN:
                        print(f"[hot-corner] trigger! cursor=({cx:.0f},{cy:.0f})", flush=True)
                        trigger()
                        last_trigger = now
    except Exception as e:
        print(f"[hot-corner] -desconectado: {dev.name} ({e})", flush=True)
    finally:
        monitored.discard(dev.path)

# ── watcher de novos devices via inotify ──────────────────────────────────────

async def device_watcher():
    import ctypes
    libc = ctypes.cdll.LoadLibrary("libc.so.6")
    IN_CREATE = 0x00000100
    IN_DELETE = 0x00000200

    inotify_fd = libc.inotify_init()
    libc.inotify_add_watch(inotify_fd, b"/dev/input", IN_CREATE | IN_DELETE)

    loop = asyncio.get_event_loop()
    f    = os.fdopen(inotify_fd, "rb", 0)

    EVENT_HDR = struct.Struct("iIII")  # wd, mask, cookie, length

    async def read_events():
        while True:
            data = await loop.run_in_executor(None, f.read, EVENT_HDR.size + 256)
            if not data:
                break
            wd, mask, cookie, length = EVENT_HDR.unpack_from(data)
            name = data[EVENT_HDR.size:EVENT_HDR.size + length].rstrip(b"\x00").decode(errors="ignore")
            path = f"/dev/input/{name}"

            if not name.startswith("event"):
                continue

            if mask & IN_CREATE:
                await asyncio.sleep(0.15)  # aguarda kernel configurar permissões
                if path not in monitored and should_monitor(path):
                    monitored.add(path)
                    try:
                        dev = InputDevice(path)
                        asyncio.ensure_future(handle(dev))
                    except Exception as e:
                        print(f"[hot-corner] erro ao abrir {path}: {e}", flush=True)
                        monitored.discard(path)

            elif mask & IN_DELETE:
                monitored.discard(path)

    await read_events()

# ── main ──────────────────────────────────────────────────────────────────────

async def main():
    global W, H, cx, cy

    W, H   = get_screen_dims()
    cx, cy = W / 2.0, H / 2.0
    print(f"[hot-corner] resolução lógica: {W}×{H}, threshold: {THRESHOLD}px", flush=True)

    # Devices já presentes na inicialização
    for path in sorted(glob.glob("/dev/input/event*")):
        if path not in monitored and should_monitor(path):
            monitored.add(path)
            try:
                dev = InputDevice(path)
                asyncio.ensure_future(handle(dev))
            except Exception as e:
                print(f"[hot-corner] erro ao abrir {path}: {e}", flush=True)
                monitored.discard(path)

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
