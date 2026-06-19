{ config, lib, pkgs, ... }:

{
  boot.kernelModules   = [ "uinput" ];
  hardware.uinput.enable = true;

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  users.groups.uinput = {};

  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [ "input" "uinput" ];
  };

  services.kanata = {
    enable = true;
    keyboards.internalKeyboard = {
      devices = [
        # Somente o teclado interno (PS/2 — estável, nunca muda de caminho)
        # O Corne foi REMOVIDO desta lista intencionalmente: ele já faz todo
        # o remapeamento no firmware QMK. Se o Kanata monitorar o Corne,
        # ele intercepta o KC_CAPS enviado pelo tap-dance e o converte em
        # Esc/Ctrl, fazendo o Caps Lock nunca chegar ao sistema.
        "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
      ];
      extraDefCfg = "process-unmapped-keys yes";
      config = ''
        (defsrc
         caps tab d h j k l
         ralt
        )

        (defvar
         tap-time  200
         hold-time 200
        )

        (defalias
         caps (tap-hold 200 200 esc lctl)
         tab  (tap-hold $tap-time $hold-time bspc (layer-toggle arrow))
         del  del
         ralt (tap-hold $tap-time $hold-time ralt (layer-toggle left-hand))

         ;; RAlt + tecla = Ctrl+tecla equivalente (lado direito espelhado)
         lh-c C-c  lh-v C-v  lh-z C-z  lh-y C-y
         lh-x C-x  lh-w C-w  lh-t C-t  lh-s C-s
         lh-a C-a  lh-f C-f
        )

        (deflayer base
         @caps @tab d h j k l
         @ralt
        )

        ;; tab segurado: h j k l → esquerda, baixo, cima, direita | d → delete
        (deflayer arrow
         _ _ @del left down up right
         _
        )

        ;; ralt segurado: atalhos Ctrl mapeados para o lado direito
        (deflayer left-hand
         _ _ @lh-x @lh-y @lh-c @lh-z @lh-v
         _
        )
      '';
    };
  };
}
