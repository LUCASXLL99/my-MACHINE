# home/lucasxll/modules/display-mode.nix
#
# Gerencia dois perfis de exibição:
#   mirror — tela espelhada + layout RTL + botões de janela à esquerda
#   normal — tela padrão    + layout LTR + botões de janela à direita
#
# Estado: ~/.config/lucasxll/display-mode  (padrão: normal)
# Comandos: f-mirror | f-reset

{ config, pkgs, lib, ... }:

let
  stateFile = "${config.home.homeDirectory}/.config/lucasxll/display-mode";

  xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
  awk    = "${pkgs.gawk}/bin/awk";
  kwrite = "${pkgs.libsForQt5.kconfig}/bin/kwriteconfig5";
  qdbus  = "${pkgs.qt5.qttools.bin}/bin/qdbus";

  xrandrApply = reflect: ''
    for _o in $(${xrandr} | ${awk} '/ connected/{print $1}'); do
      ${xrandr} --output "$_o" --reflect ${reflect}
    done
  '';

  kwinApply = left: right: ''
    ${kwrite} --file kwinrc \
      --group org.kde.kdecoration2 \
      --key ButtonsOnLeft  "${left}"
    ${kwrite} --file kwinrc \
      --group org.kde.kdecoration2 \
      --key ButtonsOnRight "${right}"
    ${qdbus} org.kde.KWin /KWin reconfigure 2>/dev/null || true
  '';

  applyMirror = ''
    ${xrandrApply "x"}
    ${kwinApply "XIA" ""}
  '';

  applyNormal = ''
    ${xrandrApply "normal"}
    ${kwinApply "" "IAX"}
  '';

  startupScript = pkgs.writeShellScript "display-mode-startup" ''
    sleep 2
    _MODE=$(cat "${stateFile}" 2>/dev/null || echo "normal")
    case "$_MODE" in
      mirror) ${applyMirror} ;;
      normal) ${applyNormal} ;;
      *)
        echo "display-mode: valor inválido '$_MODE', usando normal" >&2
        ${applyNormal}
        ;;
    esac
    unset _MODE
  '';

in
{
  home.packages = [
    (pkgs.writeShellScriptBin "f-mirror" ''
      mkdir -p "$(dirname "${stateFile}")"
      echo "mirror" > "${stateFile}"
      ${applyMirror}
      echo "✓ Modo espelho ativo (RTL terá efeito nos apps abertos após o próximo login)"
    '')

    (pkgs.writeShellScriptBin "f-reset" ''
      mkdir -p "$(dirname "${stateFile}")"
      echo "normal" > "${stateFile}"
      ${applyNormal}
      echo "✓ Modo normal ativo (LTR terá efeito nos apps abertos após o próximo login)"
    '')
  ];

  # SDDM sourcia .xprofile antes de iniciar a sessão X.
  # GTK_TEXT_DIR / QT_LAYOUT_DIRECTION herdados por todos os processos da sessão.
  # xrandr/kwriteconfig5 ficam no serviço systemd (precisam do X já rodando).
  home.file.".xprofile".text = ''
    # display-mode — gerado pelo Home Manager (não editar manualmente)

    _DM_STATE_FILE="${stateFile}"
    _DM_MODE=$(cat "$_DM_STATE_FILE" 2>/dev/null || echo "normal")

    case "$_DM_MODE" in
      mirror)
        export GTK_TEXT_DIR=rtl
        export QT_LAYOUT_DIRECTION=RTL
        export LANGUAGE="''${LANGUAGE:-en}:ar"
        ;;
      normal)
        export GTK_TEXT_DIR=ltr
        export QT_LAYOUT_DIRECTION=LTR
        export LANGUAGE="''${LANGUAGE:-en}"
        ;;
    esac

    unset _DM_STATE_FILE _DM_MODE
  '';

  # Replica .xprofile para sessões onde o DM não faz source dele
  xsession.profileExtra = ''
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
      export GTK_TEXT_DIR=ltr
      export QT_LAYOUT_DIRECTION=LTR
    fi
  '';

  systemd.user.services.display-mode = {
    Unit = {
      Description = "Aplica modo de exibição (mirror/normal) na sessão";
      After       = "graphical-session.target";
      PartOf      = "graphical-session.target";
    };
    Service = {
      Type            = "oneshot";
      ExecStart       = "${startupScript}";
      RemainAfterExit = false;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

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
