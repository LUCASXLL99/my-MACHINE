# home/lucasxll/modules/hot-corner.nix
#
# Detecta o canto superior direito e chama 'niri msg action toggle-overview'.
#
# Usa polling da posição absoluta do cursor via 'xdotool getmouselocation'
# (Xwayland/X11), já que o niri não expõe cursor-position via IPC.

{ pkgs, ... }:

let
  python = pkgs.python3;

  script = pkgs.writeShellScriptBin "niri-hot-corner-right" ''
    exec ${python}/bin/python3 - << 'PYEOF'
import sys, time, subprocess, os, glob, json

THRESHOLD = int(os.environ.get("HOT_CORNER_THRESHOLD", "8"))
COOLDOWN  = float(os.environ.get("HOT_CORNER_COOLDOWN", "1.5"))
POLL_HZ   = float(os.environ.get("HOT_CORNER_POLL_HZ", "60"))

# ── helpers ───────────────────────────────────────────────────────────────────

def niri_socket():
    s = os.environ.get("NIRI_SOCKET", "")
    if s and os.path.exists(s):
        return s
    hits = glob.glob(f"/run/user/{os.getuid()}/niri.*.sock")
    return hits[0] if hits else None

def niri_cmd(*args):
    sock = niri_socket()
    env  = {**os.environ, **({"NIRI_SOCKET": sock} if sock else {})}
    return subprocess.run(["niri", "msg", *args], capture_output=True, text=True,
                          timeout=3, env=env)

def get_screen_dims():
    """Detecta resolução do output primário via niri IPC."""
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

def get_cursor_pos():
    """Lê posição absoluta do cursor via xdotool (Xwayland)."""
    try:
        env = {**os.environ, "DISPLAY": os.environ.get("DISPLAY", ":1")}
        r = subprocess.run(
            ["xdotool", "getmouselocation", "--shell"],
            capture_output=True, text=True, timeout=3, env=env
        )
        if r.returncode != 0:
            return None
        vals = dict(line.split("=", 1) for line in r.stdout.splitlines() if "=" in line)
        return float(vals["X"]), float(vals["Y"])
    except Exception:
        return None

def trigger():
    niri_cmd("action", "toggle-overview")

# ── main ──────────────────────────────────────────────────────────────────────

W, H = get_screen_dims()
print(f"[hot-corner] resolução lógica: {W}×{H}, threshold: {THRESHOLD}px, poll: {POLL_HZ}Hz", flush=True)

last_trigger = 0.0
interval     = 1.0 / POLL_HZ

while True:
    pos = get_cursor_pos()
    if pos is not None:
        cx, cy = pos
        if cx >= W - THRESHOLD and cy <= THRESHOLD:
            now = time.monotonic()
            if now - last_trigger >= COOLDOWN:
                print(f"[hot-corner] trigger! cursor=({cx:.0f},{cy:.0f})", flush=True)
                trigger()
                last_trigger = now
    time.sleep(interval)
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
