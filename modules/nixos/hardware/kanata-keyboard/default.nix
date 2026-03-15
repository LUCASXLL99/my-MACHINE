{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.kernelModules = [ "uinput" ];
  hardware.uinput.enable = true;

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  users.groups.uinput = { };

  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [ "input" "uinput" ];
  };

  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          "/dev/input/by-path/pci-0000:05:00.4-usb-0:2:1.0-event-kbd"
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
           ;; ── Já existia ─────────────────────────────────────────
           caps (tap-hold 200 200 esc lctl)
           tab  (tap-hold $tap-time $hold-time bspc (layer-toggle arrow))
           del  del

           ;; ── Camada canhoto via RAlt ────────────────────────────
           ;; RAlt sozinho = RAlt | segurado = camada left-hand
           ralt (tap-hold $tap-time $hold-time ralt (layer-toggle left-hand))

           ;; Atalhos espelhados (lado direito do teclado)
           ;; RAlt + tecla = equivalente ao Ctrl+tecla do lado esquerdo
           lh-c  C-c   ;; copiar
           lh-v  C-v   ;; colar
           lh-z  C-z   ;; desfazer
           lh-y  C-y   ;; refazer
           lh-x  C-x   ;; recortar
           lh-w  C-w   ;; fechar aba
           lh-t  C-t   ;; nova aba
           lh-s  C-s   ;; salvar
           lh-a  C-a   ;; selecionar tudo
           lh-f  C-f   ;; buscar
          )

          ;; ── Camada base (sem mudanças) ──────────────────────────
          (deflayer base
           @caps @tab d h j k l
           @ralt
          )

          ;; ── Camada de navegação (tab segurado) ──────────────────
          ;; h j k l → esquerda, baixo, cima, direita
          ;; d       → delete
          (deflayer arrow
           _ _ @del left down up right
           _
          )

          ;; ── Camada canhoto (ralt segurado) ──────────────────────
          ;; Atalhos Ctrl+tecla mapeados para o lado direito
          ;; Posição visual (com tela espelhada):
          ;;   j=C-c  k=C-v  l=C-z  h=C-y
          ;;   d=C-x  (ralt já está no defsrc)
          (deflayer left-hand
           _ _ @lh-x @lh-y @lh-c @lh-z @lh-v
           _
          )
        '';
      };
    };
  };
}
