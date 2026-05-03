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
}
