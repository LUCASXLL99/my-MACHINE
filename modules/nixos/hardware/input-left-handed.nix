# nixos-Modules/Modules-Hardware/input-left-handed.nix
#
# Inverte os controles do mouse — funciona em X11 e parcialmente em Wayland.
#
# ┌─────────────────────────────────────────────────────────────────┐
# │  O que funciona em cada protocolo:                              │
# │                                                                 │
# │  X11 (BSPWM):                                                   │
# │    ✓ Natural scrolling  (via xinput)                            │
# │    ✓ Inversão X + Y     (via Coordinate Transformation Matrix)  │
# │                                                                 │
# │  Wayland (Niri, Plasma Wayland):                                │
# │    ✓ Natural scrolling  (via services.libinput — global)        │
# │    ✗ Inversão de eixos  — protocolo Wayland não expõe           │
# │      Coordinate Transformation Matrix para mice.                │
# │      Cada compositor precisa lidar por conta:                   │
# │        • Niri:           transform "flipped" no output          │
# │          (inverte X do cursor junto com a tela)                 │
# │        • Plasma Wayland: configurar via KWin settings           │
# └─────────────────────────────────────────────────────────────────┘

{ pkgs, ... }:

{
  services.libinput = {
    enable = true;

    # ── Configuração declarativa — aplica em X11 E em Wayland ──────
    # Natural scrolling: rolar para baixo → conteúdo sobe (estilo touchpad Mac)
    mouse = {
      naturalScrolling = true;
    };
    touchpad = {
      naturalScrolling  = true;
      tapping           = true;   # clique ao toque leve
      disableWhileTyping = true;
    };
  };

  # ── Wayland: regra udev para dispositivos virtuais [inv] ───────────
  # O libinput (usado pelo Niri e outros compositores Wayland) descobre
  # dispositivos via udev — não lê /dev/input diretamente como o X11.
  # Quando o mouse-invert.py cria dispositivos via UInput, o udev não
  # propaga automaticamente ID_INPUT_MOUSE=1, então o libinput os ignora.
  # Esta regra conserta isso: qualquer evento cujo nome contenha "[inv]"
  # recebe as propriedades necessárias para o libinput reconhecê-lo.
  # Nota: \[ e \] são obrigatórios — no udev [ ] são glob de char class.
  services.udev.extraRules = ''
    SUBSYSTEM=="input", KERNEL=="event*", ATTRS{name}=="*\[inv\]*", ENV{ID_INPUT}="1", ENV{ID_INPUT_MOUSE}="1"
  '';

  # ── X11 apenas: sessionCommands ────────────────────────────────────
  # xinput e Coordinate Transformation Matrix são conceitos X11 puros.
  # Em sessões Wayland (Niri, Plasma Wayland) este bloco é ignorado.
  services.xserver.displayManager.sessionCommands = ''
    # Aguarda X estabilizar
    sleep 1

    _apply_input() {
      for id in $(${pkgs.xorg.xinput}/bin/xinput list --id-only 2>/dev/null); do
        props=$(${pkgs.xorg.xinput}/bin/xinput list-props "$id" 2>/dev/null)

        # Natural Scrolling
        if echo "$props" | grep -q "libinput Natural Scrolling Enabled ("; then
          ${pkgs.xorg.xinput}/bin/xinput set-prop "$id" \
            "libinput Natural Scrolling Enabled" 1 || true
        fi

        # Inversão dos eixos — rotação 180° (X e Y invertidos)
        if echo "$props" | grep -q "Coordinate Transformation Matrix"; then
          ${pkgs.xorg.xinput}/bin/xinput set-prop "$id" \
            "Coordinate Transformation Matrix" \
            -1 0 1 0 -1 1 0 0 1 || true
        fi
      done
    }

    _apply_input

    # Reaplica após 5s para dispositivos que demoram para ser reconhecidos
    (sleep 5 && _apply_input) &
  '';

  # ── Sistema: mouse-invert como serviço raiz (SDDM + niri) ──────────
  #
  # Roda antes do display-manager → dispositivos [inv] existem no SDDM
  # Wayland. Fica ativo durante a sessão niri também (sem serviço de
  # usuário conflitante). O modo (y/xy) é lido de /run/mouse-invert-mode;
  # se o arquivo não existir, usa "y" (tela espelhada por padrão).

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


      def process(src):
          try:
              dst = UInput.from_device(src, name=src.name + " [inv]")
              src.grab()
              print(f"[mouse-invert] grabbing: {src.name} ({src.path})", flush=True)
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
              print(f"[mouse-invert] erro: {e}", file=sys.stderr, flush=True)
          finally:
              try:
                  src.ungrab()
              except Exception:
                  pass


      def find_mice():
          found = []
          for path in evdev.list_devices():
              try:
                  d = evdev.InputDevice(path)
                  caps = d.capabilities()
                  rel = caps.get(ecodes.EV_REL, [])
                  if ecodes.REL_X in rel and ecodes.REL_Y in rel:
                      if "[inv]" not in d.name:
                          found.append(d)
              except Exception:
                  pass
          return found


      mice = find_mice()
      if not mice:
          print("[mouse-invert] nenhum mouse encontrado", file=sys.stderr)
          sys.exit(1)

      for m in mice:
          threading.Thread(target=process, args=(m,), daemon=True).start()

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
      ExecStart  = "/bin/sh -c 'MODE=$(cat /run/mouse-invert-mode 2>/dev/null || echo y); exec mouse-invert $MODE'";
      Restart    = "on-failure";
      RestartSec = "3s";
      # mouse-invert precisa do PATH do sistema para encontrar o binário
      Environment = "PATH=/run/current-system/sw/bin";
    };
  };

  # Permite que lucasxll controle mouse-invert sem senha (para niri-mirror/reset)
  security.sudo.extraRules = [{
    users    = [ "lucasxll" ];
    commands = [
      { command = "/run/current-system/sw/bin/systemctl restart mouse-invert"; options = [ "NOPASSWD" ]; }
      { command = "/run/wrappers/bin/tee /run/mouse-invert-mode";              options = [ "NOPASSWD" ]; }
    ];
  }];

}
