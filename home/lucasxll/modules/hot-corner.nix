# home/lucasxll/modules/hot-corner.nix
#
# Detecta o canto superior direito e chama 'niri msg action toggle-overview'.
#
# Usa 'niri msg event-stream' (Wayland nativo) para receber eventos de
# movimento do cursor em tempo real — sem polling, sem dessincronias de escala.

{ pkgs, ... }:

let
  python = pkgs.python3;

  script = pkgs.writeShellScriptBin "niri-hot-corner-right" ''
    exec ${python}/bin/python3 - << 'PYEOF'
import sys, time, subprocess, os, glob, json

THRESHOLD = int(os.environ.get("HOT_CORNER_THRESHOLD", "8"))
COOLDOWN  = float(os.environ.get("HOT_CORNER_COOLDOWN", "1.5"))

# ── helpers ───────────────────────────────────────────────────────────────────

def niri_socket():
    s = os.environ.get("NIRI_SOCKET", "")
    if s and os.path.exists(s):
        return s
    hits = glob.glob(f"/run/user/{os.getuid()}/niri.*.sock")
    return hits[0] if hits else None

def niri_env():
    sock = niri_socket()
    env  = {**os.environ}
    if sock:
        env["NIRI_SOCKET"] = sock
    return env

def niri_cmd(*args):
    return subprocess.run(["niri", "msg", *args], capture_output=True, text=True,
                          timeout=3, env=niri_env())

def get_screen_dims():
    """Detecta resolução lógica do output primário via niri IPC."""
    try:
        r = niri_cmd("-j", "outputs")
        for out in json.loads(r.stdout).values():
            m = out.get("current_mode") or {}
            if m.get("width") and m.get("height"):
                scale = out.get("scale") or 1.0
                return int(m["width"] / scale), int(m["height"] / scale)
    except Exception as e:
        print(f"[hot-corner] fallback 1920×1080 ({e})", flush=True)
    return 1920, 1080

def trigger():
    niri_cmd("action", "toggle-overview")

# ── main: assina event-stream ────────────────────────────────────────────────

W, H = get_screen_dims()
print(f"[hot-corner] resolução lógica: {W}×{H}, threshold: {THRESHOLD}px", flush=True)

last_trigger = 0.0

proc = subprocess.Popen(
    ["niri", "msg", "-j", "event-stream"],
    stdout=subprocess.PIPE, text=True, env=niri_env()
)

for raw in proc.stdout:
    raw = raw.strip()
    if not raw:
        continue
    try:
        ev = json.loads(raw)
    except json.JSONDecodeError:
        continue

    # Evento de movimento do cursor: {"PointerMotionAbsolute":{"x":…,"y":…}}
    # ou {"PointerMotion":{"dx":…,"dy":…}} — usamos apenas o absoluto
    pos = None
    if isinstance(ev, dict):
        pma = ev.get("PointerMotionAbsolute")
        if pma:
            pos = (float(pma["x"]), float(pma["y"]))

    if pos is None:
        continue

    cx, cy = pos
    if cx >= W - THRESHOLD and cy <= THRESHOLD:
        now = time.monotonic()
        if now - last_trigger >= COOLDOWN:
            print(f"[hot-corner] trigger! cursor=({cx:.0f},{cy:.0f})", flush=True)
            trigger()
            last_trigger = now
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
