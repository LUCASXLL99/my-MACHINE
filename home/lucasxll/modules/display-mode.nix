# home/lucasxll/modules/display-mode.nix
# f-mirror / f-reset — alterna perfil espelhado↔normal.
#
# Usa xrandr (X11) para espelhar o display — funciona na sessão bspwm e
# também em niri via xwayland-satellite (xrandr afeta apenas o display virtual).
# Para espelhar o output Wayland no niri, usar wlr-randr ou niri msg output.

{ config, pkgs, lib, ... }:

let
  stateFile = "${config.home.homeDirectory}/.config/lucasxll/display-mode";

  xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
  awk    = "${pkgs.gawk}/bin/awk";

  xrandrApply = reflect: ''
    for _o in $(${xrandr} | ${awk} '/ connected/{print $1}'); do
      ${xrandr} --output "$_o" --reflect ${reflect}
    done
  '';

  applyMirror = xrandrApply "x";
  applyNormal = xrandrApply "normal";

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
      echo "✓ Modo espelho ativo"
    '')
    (pkgs.writeShellScriptBin "f-reset" ''
      mkdir -p "$(dirname "${stateFile}")"
      echo "normal" > "${stateFile}"
      ${applyNormal}
      echo "✓ Modo normal ativo"
    '')
  ];

  home.file.".xprofile".text = ''
    # display-mode — gerado pelo Home Manager, não editar manualmente
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

  xsession.profileExtra = ''
    if [ -f "${stateFile}" ]; then
      _DM_MODE=$(cat "${stateFile}")
      case "$_DM_MODE" in
        mirror) export GTK_TEXT_DIR=rtl; export QT_LAYOUT_DIRECTION=RTL ;;
        normal) export GTK_TEXT_DIR=ltr; export QT_LAYOUT_DIRECTION=LTR ;;
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
    Hidden=false
    X-GNOME-Autostart-enabled=true
  '';
}
