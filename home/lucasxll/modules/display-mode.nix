# home/lucasxll/modules/display-mode.nix
#
# Gerencia o modo de exibição entre dois perfis:
#
#   mirror — tela espelhada + layout RTL + botões de janela à esquerda
#   normal — tela padrão    + layout LTR + botões de janela à direita
#
# Estado persistido em: ~/.config/lucasxll/display-mode
# Padrão ao primeiro boot (arquivo ausente): mirror
#
# Comandos:
#   f-mirror   ativa modo espelho ao vivo
#   f-reset    ativa modo normal  ao vivo
#
# SUBSTITUI: screen-reflect.nix — remover o import deste no default.nix
# ATIVAR:    adicionar ./modules/display-mode.nix no home/lucasxll/default.nix

{ config, pkgs, lib, ... }:

let
  # ── Caminho do arquivo de estado ─────────────────────────────
  stateFile = "${config.home.homeDirectory}/.config/lucasxll/display-mode";

  # ── Pacotes necessários ───────────────────────────────────────
  xrandr      = "${pkgs.xorg.xrandr}/bin/xrandr";
  awk         = "${pkgs.gawk}/bin/awk";
  kwrite      = "${pkgs.libsForQt5.kconfig}/bin/kwriteconfig5";
  qdbus       = "${pkgs.qt5.qttools.bin}/bin/qdbus";

  # ── Fragmento: aplica xrandr em todos os monitores ───────────
  # reflect: "x" para espelhar, "normal" para restaurar
  xrandrApply = reflect: ''
    for _o in $(${xrandr} | ${awk} '/ connected/{print $1}'); do
      ${xrandr} --output "$_o" --reflect ${reflect}
    done
  '';

  # ── Fragmento: move botões de janela (KWin) ──────────────────
  # Funciona no KDE; no bspwm não tem efeito (sem decoração KWin)
  kwinApply = left: right: ''
    ${kwrite} --file kwinrc \
      --group org.kde.kdecoration2 \
      --key ButtonsOnLeft  "${left}"
    ${kwrite} --file kwinrc \
      --group org.kde.kdecoration2 \
      --key ButtonsOnRight "${right}"
    ${qdbus} org.kde.KWin /KWin reconfigure 2>/dev/null || true
  '';

  # ── Blocos completos por modo ─────────────────────────────────
  applyMirror = ''
    ${xrandrApply "x"}
    ${kwinApply "XIA" ""}
  '';

  applyNormal = ''
    ${xrandrApply "normal"}
    ${kwinApply "" "IAX"}
  '';

  # ── Script de startup (lido pelo serviço systemd) ─────────────
  # Aguarda o servidor X estabilizar, lê o estado e aplica
  startupScript = pkgs.writeShellScript "display-mode-startup" ''
    sleep 2

    _MODE=$(cat "${stateFile}" 2>/dev/null || echo "mirror")

    case "$_MODE" in
      mirror) ${applyMirror} ;;
      normal) ${applyNormal} ;;
      *)
        echo "display-mode: valor inválido '$_MODE', usando mirror" >&2
        ${applyMirror}
        ;;
    esac

    unset _MODE
  '';

in
{
  # ── Scripts de alternância ────────────────────────────────────

  home.packages = [

    # f-mirror: salva estado + aplica modo espelho ao vivo
    (pkgs.writeShellScriptBin "f-mirror" ''
      mkdir -p "$(dirname "${stateFile}")"
      echo "mirror" > "${stateFile}"
      ${applyMirror}
      echo "✓ Modo espelho ativo"
      echo "  xrandr: reflect x"
      echo "  KWin:   botões à esquerda"
      echo "  RTL:    terá efeito nos apps abertos após o próximo login"
    '')

    # f-reset: salva estado + aplica modo normal ao vivo
    (pkgs.writeShellScriptBin "f-reset" ''
      mkdir -p "$(dirname "${stateFile}")"
      echo "normal" > "${stateFile}"
      ${applyNormal}
      echo "✓ Modo normal ativo"
      echo "  xrandr: reflect normal"
      echo "  KWin:   botões à direita"
      echo "  LTR:    terá efeito nos apps abertos após o próximo login"
    '')

  ];

  # ── ~/.xprofile ───────────────────────────────────────────────
  #
  # O SDDM sourcia este arquivo antes de iniciar a sessão X.
  # Variáveis exportadas aqui são herdadas por TODOS os processos
  # da sessão — bspwm, KDE Plasma, e cada app aberto.
  #
  # GTK_TEXT_DIR     → apps GTK (Firefox, Thunar, GIMP…)
  # QT_LAYOUT_DIRECTION → apps Qt/KDE (Dolphin, Okular, Kate…)
  #
  # NOTA: xrandr e kwriteconfig5 NÃO ficam aqui pois precisam do
  # servidor X já rodando. Eles ficam no serviço systemd abaixo.

  home.file.".xprofile".text = ''
    # ── display-mode — gerado pelo Home Manager ───────────────────
    # NÃO edite este arquivo manualmente; edite display-mode.nix

    _DM_STATE_FILE="${stateFile}"
    _DM_MODE=$(cat "$_DM_STATE_FILE" 2>/dev/null || echo "mirror")

    case "$_DM_MODE" in

      mirror)
        # Tela espelhada: layout RTL (direita → esquerda)
        export GTK_TEXT_DIR=rtl
        export QT_LAYOUT_DIRECTION=RTL
        # Força iconografia RTL nos apps GTK que respeitam LANGUAGE
        export LANGUAGE="''${LANGUAGE:-en}:ar"
        ;;

      normal)
        # Tela normal: layout LTR (esquerda → direita)
        export GTK_TEXT_DIR=ltr
        export QT_LAYOUT_DIRECTION=LTR
        export LANGUAGE="''${LANGUAGE:-en}"
        ;;

    esac

    unset _DM_STATE_FILE _DM_MODE
  '';

  # ── xsession.profileExtra ─────────────────────────────────────
  #
  # Fonte complementar ao .xprofile: garante que as variáveis
  # estejam disponíveis mesmo quando o DM não sourcia .xprofile.
  # O Home Manager injeta este bloco no .xsession gerado,
  # antes de qualquer programa ser iniciado.

  xsession.profileExtra = ''
    # display-mode: replica o .xprofile para sessões sem DM-sourcing
    if [ -f "${stateFile}" ]; then
      _DM_MODE=$(cat "${stateFile}")
      case "$_DM_MODE" in
        mirror)
          export GTK_TEXT_DIR=rtl
          export QT_LAYOUT_DIRECTION=RTL
          ;;
        normal)
          export GTK_TEXT_DIR=ltr
          export QT_LAYOUT_DIRECTION=LTR
          ;;
      esac
      unset _DM_MODE
    else
      # Arquivo ausente → padrão mirror
      export GTK_TEXT_DIR=rtl
      export QT_LAYOUT_DIRECTION=RTL
    fi
  '';

  # ── Serviço systemd de startup ────────────────────────────────
  #
  # Aplica xrandr + kwriteconfig5 após o servidor X estar pronto.
  # Substitui o flip-screen do screen-reflect.nix, mas de forma
  # condicional: lê o estado antes de agir.

  systemd.user.services.display-mode = {
    Unit = {
      Description = "Aplica modo de exibição (mirror/normal) na sessão";
      After       = "graphical-session.target";
      PartOf      = "graphical-session.target";
    };
    Service = {
      Type      = "oneshot";
      ExecStart = "${startupScript}";
      # Reinicia se o arquivo de estado for alterado externamente
      RemainAfterExit = false;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # ── XDG autostart (KDE Plasma) ───────────────────────────────
  #
  # Para quando o usuário está no KDE e o systemd user não dispara.
  # Executa o mesmo startupScript via .desktop.

  xdg.configFile."autostart/display-mode.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Display Mode
    Exec=${startupScript}
    X-KDE-autostart-phase=1
    Hidden=false
    X-GNOME-Autostart-enabled=true
  '';
}
