# home/lucasxll/modules/hot-corner.nix
#
# Hot corner canto superior DIREITO → toggle overview do Niri.
# Lê /dev/input/mice (Python stdlib puro, sem evdev).

{ pkgs, lib, ... }:

let
  hot-corner-script = pkgs.writeShellScriptBin "niri-hot-corner-right" ''
    exec ${pkgs.python3}/bin/python3 - << 'PYEOF'
import struct, time, subprocess, os, glob

W         = 1920
H         = 1080
THRESHOLD = 8
COOLDOWN  = 1.5

x, y         = W // 2, H // 2
last_trigger = 0.0

# descobre o socket do niri
def niri_socket():
    s = os.environ.get("NIRI_SOCKET", "")
    if s and os.path.exists(s):
        return s
    uid = os.getuid()
    hits = glob.glob(f"/run/user/{uid}/niri.*.sock")
    return hits[0] if hits else None

def trigger():
    sock = niri_socket()
    env  = {**os.environ}
    if sock:
        env["NIRI_SOCKET"] = sock
    subprocess.Popen(["niri", "msg", "action", "toggle-overview"], env=env)

try:
    f = open("/dev/input/mice", "rb")
except PermissionError:
    # tenta via sudo udevadm ou simplesmente sai com mensagem
    import sys
    print("Sem acesso a /dev/input/mice — adicione o usuário ao grupo 'input'", flush=True)
    sys.exit(1)

while True:
    data = f.read(3)
    if len(data) < 3:
        continue
    dx = struct.unpack("b", bytes([data[1]]))[0]
    dy = struct.unpack("b", bytes([data[2]]))[0]
    x  = max(0, min(W - 1, x + dx))
    y  = max(0, min(H - 1, y - dy))   # eixo Y invertido no /dev/input/mice

    if x >= W - THRESHOLD and y <= THRESHOLD:
        now = time.monotonic()
        if now - last_trigger >= COOLDOWN:
            trigger()
            last_trigger = now
PYEOF
  '';
in
{
  home.packages = [ hot-corner-script ];

  systemd.user.services.niri-hot-corner = {
    Unit = {
      Description = "Hot corner canto superior direito → niri overview";
      After        = [ "graphical-session.target" ];
      PartOf       = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${hot-corner-script}/bin/niri-hot-corner-right";
      Restart    = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
