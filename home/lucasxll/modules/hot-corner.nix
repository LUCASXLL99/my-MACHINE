# home/lucasxll/modules/hot-corner.nix
#
# Detecta o canto superior direito e chama 'niri msg action toggle-overview'.
#
# Lê eventos REL_X/REL_Y diretamente dos dispositivos /dev/input (via evdev),
# acumula posição absoluta e detecta o canto. Necessário porque:
#   - niri não expõe cursor via IPC nem event-stream
#   - xdotool retorna posição fixa no Xwayland do niri
#   - kanata remapeia os devices para [inv] (py-evdev-uinput)

{ pkgs, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.evdev ]);

  script = pkgs.writeShellScriptBin "niri-hot-corner-right" ''
    exec ${python}/bin/python3 - << 'PYEOF'
import asyncio, subprocess, os, glob, json, time
import evdev
from evdev import InputDevice, categorize, ecodes

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
    try:
        r = niri_cmd("-j", "outputs")
        for out in json.loads(r.stdout).values():
            idx   = out.get("current_mode")
            modes = out.get("modes", [])
            if not modes:
                continue
            m     = modes[idx] if isinstance(idx, int) else modes[0]
            scale = out.get("scale") or 1.0
            return int(m["width"] / scale), int(m["height"] / scale)
    except Exception as e:
        print(f"[hot-corner] fallback 1920×1080 ({e})", flush=True)
    return 1920, 1080

def trigger():
    niri_cmd("action", "toggle-overview")

# ── device discovery ──────────────────────────────────────────────────────────

def find_mouse_devices():
    """Acha todos os /dev/input/eventN que têm REL_X e REL_Y (mouses)."""
    devices = []
    for path in sorted(glob.glob("/dev/input/event*")):
        try:
            dev = InputDevice(path)
            caps = dev.capabilities()
            if ecodes.EV_REL in caps:
                rel = caps[ecodes.EV_REL]
                if ecodes.REL_X in rel and ecodes.REL_Y in rel:
                    devices.append(dev)
                    print(f"[hot-corner] monitorando: {dev.name} ({path})", flush=True)
        except Exception:
            pass
    return devices

# ── main ──────────────────────────────────────────────────────────────────────

W, H = get_screen_dims()
print(f"[hot-corner] resolução lógica: {W}×{H}, threshold: {THRESHOLD}px", flush=True)

devices = find_mouse_devices()
if not devices:
    print("[hot-corner] nenhum dispositivo de mouse encontrado!", flush=True)
    exit(1)

# Posição acumulada — começa no centro
cx, cy = W / 2, H / 2
last_trigger = 0.0

async def handle(dev):
    global cx, cy, last_trigger
    async for event in dev.async_read_loop():
        if event.type == ecodes.EV_REL:
            if event.code == ecodes.REL_X:
                cx = max(0, min(W, cx + event.value))
            elif event.code == ecodes.REL_Y:
                cy = max(0, min(H, cy + event.value))

            if cx >= W - THRESHOLD and cy <= THRESHOLD:
                now = time.monotonic()
                if now - last_trigger >= COOLDOWN:
                    print(f"[hot-corner] trigger! cursor=({cx:.0f},{cy:.0f})", flush=True)
                    trigger()
                    last_trigger = now

async def main():
    await asyncio.gather(*[handle(dev) for dev in devices])

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
      BindsTo = [ "niri.service" ];  # para automaticamente ao sair do niri
    };
    Service = {
      ExecStart = "${script}/bin/niri-hot-corner-right";
      Restart    = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "niri.service" ];
  };
}
