# modules/nixos/hardware/input-left-handed.nix
#
# Inverte os controles do mouse.
#
# ┌────────────┬────────────────────────────────────────────────────┐
# │ X11        │ Natural scrolling ✓  Inversão X+Y ✓ (xinput CTM) │
# │ Wayland    │ Natural scrolling ✓  Inversão: niri usa transform  │
# │            │ "flipped" no output — Wayland não expõe CTM       │
# └────────────┴────────────────────────────────────────────────────┘

{ pkgs, ... }:

{
  services.libinput = {
    enable = true;
    mouse    = { naturalScrolling = true; };
    touchpad = {
      naturalScrolling   = true;
      tapping            = true;
      disableWhileTyping = true;
    };
  };

  # Regra udev para dispositivos virtuais [inv] criados pelo mouse-invert.py.
  # Sem ela o libinput ignora os dispositivos UInput (não têm ID_INPUT_MOUSE=1).
  # \[ e \] obrigatórios — no udev [ ] são glob de char class.
  services.udev.extraRules = ''
    SUBSYSTEM=="input", KERNEL=="event*", ATTRS{name}=="*\[inv\]*", ENV{ID_INPUT}="1", ENV{ID_INPUT_MOUSE}="1"
  '';

  # X11: aplica xinput CTM (ignorado em Wayland)
  services.xserver.displayManager.sessionCommands = ''
    sleep 1
    _apply_input() {
      for id in $(${pkgs.xorg.xinput}/bin/xinput list --id-only 2>/dev/null); do
        props=$(${pkgs.xorg.xinput}/bin/xinput list-props "$id" 2>/dev/null)
        if echo "$props" | grep -q "libinput Natural Scrolling Enabled ("; then
          ${pkgs.xorg.xinput}/bin/xinput set-prop "$id" \
            "libinput Natural Scrolling Enabled" 1 || true
        fi
        if echo "$props" | grep -q "Coordinate Transformation Matrix"; then
          ${pkgs.xorg.xinput}/bin/xinput set-prop "$id" \
            "Coordinate Transformation Matrix" \
            -1 0 1 0 -1 1 0 0 1 || true
        fi
      done
    }
    _apply_input
    (sleep 5 && _apply_input) &
  '';

  # Serviço de sistema: roda antes do display-manager → funciona no SDDM e no niri.
  # Modo lido de /run/mouse-invert-mode; padrão "xy" se ausente.
  environment.systemPackages = let
    mouseInvert = pkgs.writers.writePython3Bin "mouse-invert" {
      libraries = [ pkgs.python3Packages.evdev ];
    } ''
      import sys
      import threading
      import time
      import evdev
      from evdev import ecodes, UInput

      mode = sys.argv[1] if len(sys.argv) > 1 else "xy"
      INV_X = "x" in mode
      INV_Y = "y" in mode
      print(f"[mouse-invert] modo={mode} inv_x={INV_X} inv_y={INV_Y}", flush=True)

      # Rastreia quais paths já têm thread ativa para não duplicar.
      active = {}
      active_lock = threading.Lock()


      def process(path):
          try:
              src = evdev.InputDevice(path)
              caps = src.capabilities()
              rel = caps.get(ecodes.EV_REL, [])
              if ecodes.REL_X not in rel or ecodes.REL_Y not in rel:
                  return
              if "[inv]" in src.name:
                  return
              dst = UInput.from_device(src, name=src.name + " [inv]")
              src.grab()
              gname = f"{src.name} ({src.path})"
              print(f"[mouse-invert] grabbing: {gname}", flush=True)
              for ev in src.read_loop():
                  if ev.type == ecodes.EV_REL:
                      if ev.code == ecodes.REL_X and INV_X:
                          dst.write(ev.type, ev.code, -ev.value)
                      elif ev.code == ecodes.REL_Y and INV_Y:
                          dst.write(ev.type, ev.code, -ev.value)
                      else:
                          dst.write_event(ev)
                  else:
                      dst.write_event(ev)
                  if ev.type == ecodes.EV_SYN:
                      dst.syn()
          except Exception as e:
              msg = f"[mouse-invert] {path}: {e}"
              print(msg, file=sys.stderr, flush=True)
          finally:
              with active_lock:
                  active.pop(path, None)
              try:
                  src.ungrab()
              except Exception:
                  pass


      def watch_loop():
          """Verifica periodicamente se há novos mice e inicia threads para eles."""
          while True:
              try:
                  for path in evdev.list_devices():
                      with active_lock:
                          if path in active:
                              continue
                      try:
                          d = evdev.InputDevice(path)
                          caps = d.capabilities()
                          rel = caps.get(ecodes.EV_REL, [])
                          has_xy = ecodes.REL_X in rel and ecodes.REL_Y in rel
                          if has_xy and "[inv]" not in d.name:
                              d.close()
                              with active_lock:
                                  t = threading.Thread(
                                      target=process,
                                      args=(path,), daemon=True)
                                  active[path] = t
                              t.start()
                      except Exception:
                          pass
              except Exception as e:
                  wmsg = f"[mouse-invert] watch: {e}"
                  print(wmsg, file=sys.stderr, flush=True)
              time.sleep(2)


      threading.Thread(target=watch_loop, daemon=True).start()

      try:
          while True:
              time.sleep(60)
      except KeyboardInterrupt:
          pass
    '';
  in [ mouseInvert ];

  systemd.services.mouse-invert = {
    description = "Mouse axis inverter (SDDM + Niri)";
    after    = [ "systemd-udev-settle.service" ];
    before   = [ "display-manager.service" ];
    wantedBy = [ "display-manager.service" ];
    serviceConfig = {
      Type       = "simple";
      ExecStart  = "/bin/sh -c 'MODE=$(cat /run/mouse-invert-mode 2>/dev/null || echo xy); exec mouse-invert $MODE'";
      Restart    = "on-failure";
      RestartSec = "3s";
      Environment = "PATH=/run/current-system/sw/bin";
    };
  };

  security.sudo.extraRules = [{
    users    = [ "lucasxll" ];
    commands = [
      { command = "/run/current-system/sw/bin/systemctl restart mouse-invert"; options = [ "NOPASSWD" ]; }
      { command = "/run/wrappers/bin/tee /run/mouse-invert-mode";              options = [ "NOPASSWD" ]; }
    ];
  }];
}
