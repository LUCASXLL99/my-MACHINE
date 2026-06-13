# home/lucasxll/modules/hot-corner.nix
#
# Detecta o canto superior direito e chama 'niri msg action toggle-overview'.
#
# niri não expõe cursor via IPC nem via event-stream — usa polling com
# xdotool (Xwayland). A resolução é lida via niri IPC onde current_mode
# é um índice inteiro na lista modes[].

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
    """Detecta resolução lógica do output primário via niri IPC.
    current_mode é um índice inteiro em modes[], não um dict."""
    try:
        r = niri_cmd("-j", "outputs")
        for out in json.loads(r.stdout).values():
            idx   = out.get("current_mode")
            modes = out.get("modes", [])
            if idx is None or not modes:
                continue
            m     = modes[idx] if isinstance(idx, int) else modes[0]
            scale = out.get("scale") or 1.0
            return int(m["width"] / scale), int(m["height"] / scale)
    except Exception as e:
        print(f"[hot-corner] fallback 1920×1080 ({e})", flush=True)
    return 1920, 1080

def get_cursor_pos():
    """Polling via xdotool (Xwayland). Coordenadas físicas — dividimos pela
    escala do output para obter coordenadas lógicas comparáveis ao W/H."""
    try:
        env = {**os.environ, "DISPLAY": os.environ.get("DISPLAY", ":0")}
        r = subprocess.run(
            ["xdotool", "getmouselocation", "--shell"],
            capture_output=True, text=True, timeout=1, env=env
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
