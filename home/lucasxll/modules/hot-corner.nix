# home/lucasxll/modules/hot-corner.nix
# Detecta o canto superior direito e chama 'niri msg action toggle-overview'.
# Usa evdev (leitura de /dev/input/event*) com fallback para /dev/input/mice.
# Resolução detectada via niri IPC; configurável por HOT_CORNER_THRESHOLD e HOT_CORNER_COOLDOWN.

{ pkgs, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.evdev ]);

  script = pkgs.writeShellScriptBin "niri-hot-corner-right" ''
    exec ${python}/bin/python3 - << 'PYEOF'
import sys, time, subprocess, os, glob, json, select

THRESHOLD = int(os.environ.get("HOT_CORNER_THRESHOLD", "8"))
COOLDOWN  = float(os.environ.get("HOT_CORNER_COOLDOWN", "1.5"))

def niri_socket():
    s = os.environ.get("NIRI_SOCKET", "")
    if s and os.path.exists(s):
        return s
    hits = glob.glob(f"/run/user/{os.getuid()}/niri.*.sock")
    return hits[0] if hits else None

def niri_cmd(*args):
    sock = niri_socket()
    env  = {**os.environ, **( {"NIRI_SOCKET": sock} if sock else {})}
    return subprocess.run(["niri", "msg", *args], capture_output=True, text=True,
                          timeout=3, env=env)

def get_screen_dims():
    try:
        r = niri_cmd("-j", "outputs")
        for out in json.loads(r.stdout).values():
            m = out.get("current_mode") or {}
            if m.get("width") and m.get("height"):
                return m["width"], m["height"]
    except Exception as e:
        print(f"[hot-corner] fallback 1920×1080 ({e})", flush=True)
    return 1920, 1080

def trigger():
    niri_cmd("action", "toggle-overview")

def open_evdev_mouse():
    try:
        import evdev
        for path in evdev.list_devices():
            try:
                dev  = evdev.InputDevice(path)
                caps = dev.capabilities()
                rel  = caps.get(evdev.ecodes.EV_REL, [])
                if evdev.ecodes.REL_X in rel and evdev.ecodes.REL_Y in rel:
                    print(f"[hot-corner] evdev: {dev.name} ({path})", flush=True)
                    return ("evdev", dev)
            except Exception:
                pass
    except ImportError:
        pass
    return None

def open_mice_fallback():
    try:
        f = open("/dev/input/mice", "rb")
        print("[hot-corner] fallback: /dev/input/mice", flush=True)
        return ("mice", f)
    except PermissionError:
        print("[hot-corner] sem acesso a /dev/input/mice", file=sys.stderr, flush=True)
        sys.exit(1)

W, H = get_screen_dims()
print(f"[hot-corner] resolução: {W}×{H}, threshold: {THRESHOLD}px", flush=True)

x, y         = W // 2, H // 2
last_trigger = 0.0

source = open_evdev_mouse() or open_mice_fallback()
kind   = source[0]
dev    = source[1]

if kind == "evdev":
    import evdev
    for event in dev.read_loop():
        if event.type == evdev.ecodes.EV_REL:
            if   event.code == evdev.ecodes.REL_X: x = max(0, min(W - 1, x + event.value))
            elif event.code == evdev.ecodes.REL_Y: y = max(0, min(H - 1, y + event.value))
            if x >= W - THRESHOLD and y <= THRESHOLD:
                now = time.monotonic()
                if now - last_trigger >= COOLDOWN:
                    trigger()
                    last_trigger = now
else:
    import struct
    while True:
        data = dev.read(3)
        if len(data) < 3:
            continue
        dx = struct.unpack("b", bytes([data[1]]))[0]
        dy = struct.unpack("b", bytes([data[2]]))[0]
        x  = max(0, min(W - 1, x + dx))
        y  = max(0, min(H - 1, y - dy))
        if x >= W - THRESHOLD and y <= THRESHOLD:
            now = time.monotonic()
            if now - last_trigger >= COOLDOWN:
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
      After        = [ "graphical-session.target" ];
      PartOf       = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart  = "${script}/bin/niri-hot-corner-right";
      Restart    = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
