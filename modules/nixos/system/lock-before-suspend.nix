{ pkgs, ... }:
{
  # ── LOCK CONFIÁVEL ANTES DE SUSPENDER ────────────────────────────────────
  # O "lockOnSuspend = true" do noctalia (home/lucasxll/modules/wayland/
  # noctalia.nix) mostrou na prática não travar de forma confiável — testes
  # em 2026-08-07 mostraram o notebook voltando do suspend sem pedir senha
  # nenhuma. Isso porque o hook interno do noctalia dispara o lock de forma
  # assíncrona, e o kernel congela os processos userspace (ver "Freezing
  # user space processes" no journalctl) antes da tela de lock ter garantia
  # de ter montado.
  #
  # Scripts em /etc/systemd/system-sleep/ são o mecanismo OFICIAL do systemd
  # pra isso: o systemd roda esse script e ESPERA ele terminar antes de
  # continuar o suspend de verdade — elimina a corrida sem precisar de
  # inibidor manual nem busctl monitor (abordagem anterior, mais frágil).
  environment.etc."systemd/system-sleep/lock-screen.sh" = {
    mode = "0755";
    text = ''
      #!/bin/sh
      # $1 = pre|post, $2 = suspend|hibernate|hybrid-sleep
      case "$1" in
        pre)
          USER_NAME="lucasxll"
          USER_UID=$(${pkgs.coreutils}/bin/id -u "$USER_NAME")
          RUNTIME_DIR="/run/user/$USER_UID"

          # Acha o socket wayland ativo do usuário (normalmente wayland-1).
          WAYLAND_SOCK=$(${pkgs.findutils}/bin/find "$RUNTIME_DIR" -maxdepth 1 -name 'wayland-*' -not -name '*.lock' -printf '%f\n' 2>/dev/null | head -n1)

          if [ -n "$WAYLAND_SOCK" ]; then
            ${pkgs.su}/bin/su -l "$USER_NAME" -c "
              export XDG_RUNTIME_DIR='$RUNTIME_DIR'
              export WAYLAND_DISPLAY='$WAYLAND_SOCK'
              noctalia-shell ipc call lockScreen lock
            " 2>&1 | ${pkgs.systemd}/bin/systemd-cat -t lock-before-suspend

            # Dá tempo da tela de lock realmente montar antes do freeze do
            # kernel continuar — sem isso ainda existe uma janela de corrida.
            sleep 1
          else
            ${pkgs.systemd}/bin/systemd-cat -t lock-before-suspend <<< "WAYLAND_DISPLAY não encontrado em $RUNTIME_DIR, pulando lock"
          fi
          ;;
        post)
          # nada a fazer no resume — só existe pra documentar o par pre/post
          ;;
      esac
      exit 0
    '';
  };
}
