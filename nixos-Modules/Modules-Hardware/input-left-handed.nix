# nixos-Modules/Modules-Hardware/input-left-handed.nix
#
# Inverte todos os ponteiros (mouses + touchpad) via sessionCommands.
# Aplica dinamicamente em todos os dispositivos presentes no login,
# sem hardcodar nomes — qualquer mouse futuro já é coberto.
#
# ATIVAR:    descomentar o import no configuration.nix + rebuild
# DESATIVAR: comentar o import no configuration.nix + rebuild

{ pkgs, ... }:

{
  services.libinput.enable = true;

  services.xserver.displayManager.sessionCommands = ''
    # Aguarda X estabilizar
    sleep 1

    # Aplica em todos os dispositivos que suportam libinput
    for id in $(${pkgs.xorg.xinput}/bin/xinput list --id-only); do
      props=$(${pkgs.xorg.xinput}/bin/xinput list-props "$id" 2>/dev/null)

      # Natural Scrolling (rolar baixo → sobe)
      if echo "$props" | grep -q "libinput Natural Scrolling Enabled ("; then
        ${pkgs.xorg.xinput}/bin/xinput set-prop "$id" "libinput Natural Scrolling Enabled" 1 || true
      fi

      # Inversão dos eixos (rotação 180°)
      if echo "$props" | grep -q "Coordinate Transformation Matrix"; then
        ${pkgs.xorg.xinput}/bin/xinput set-prop "$id" "Coordinate Transformation Matrix" \
          -1 0 1 0 -1 1 0 0 1 || true
      fi
    done

    # Reaplica após 5s para dispositivos que demoram para ser reconhecidos
    (sleep 5
      for id in $(${pkgs.xorg.xinput}/bin/xinput list --id-only); do
        props=$(${pkgs.xorg.xinput}/bin/xinput list-props "$id" 2>/dev/null)
        if echo "$props" | grep -q "libinput Natural Scrolling Enabled ("; then
          ${pkgs.xorg.xinput}/bin/xinput set-prop "$id" "libinput Natural Scrolling Enabled" 1 || true
        fi
        if echo "$props" | grep -q "Coordinate Transformation Matrix"; then
          ${pkgs.xorg.xinput}/bin/xinput set-prop "$id" "Coordinate Transformation Matrix" \
            -1 0 1 0 -1 1 0 0 1 || true
        fi
      done
    ) &
  '';
}
