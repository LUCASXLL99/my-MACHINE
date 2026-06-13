# home/lucasxll/modules/display-mode.nix
# DESATIVADO — não importado em default.nix.
# f-mirror / f-reset para alternar modo espelhado↔normal via xrandr (X11).
# No niri, usar niri-mirror / niri-reset (mouse-invert.nix) que operam via
# 'niri msg output' e reiniciam o mouse-invert corretamente.

{ config, pkgs, lib, ... }:

let
  stateFile = "${config.home.homeDirectory}/.config/lucasxll/display-mode";
  xrandr    = "${pkgs.xorg.xrandr}/bin/xrandr";
  awk       = "${pkgs.gawk}/bin/awk";

  xrandrApply = reflect: ''
    for _o in $(${xrandr} | ${awk} '/ connected/{print $1}'); do
      ${xrandr} --output "$_o" --reflect ${reflect}
    done
  '';

  applyMirror    = xrandrApply "x";
  applyNormal    = xrandrApply "normal";
  startupScript  = pkgs.writeShellScript "display-mode-startup" ''
    sleep 2
    _MODE=$(cat "${stateFile}" 2>/dev/null || echo "normal")
    case "$_MODE" in
      mirror) ${applyMirror} ;;
      normal) ${applyNormal} ;;
      *) echo "display-mode: valor inválido '$_MODE', usando normal" >&2; ${applyNormal} ;;
    esac
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
    _DM_MODE=$(cat "${stateFile}" 2>/dev/null || echo "normal")
    case "$_DM_MODE" in
      mirror) export GTK_TEXT_DIR=rtl; export QT_LAYOUT_DIRECTION=RTL; export LANGUAGE="''${LANGUAGE:-en}:ar" ;;
      normal) export GTK_TEXT_DIR=ltr; export QT_LAYOUT_DIRECTION=LTR; export LANGUAGE="''${LANGUAGE:-en}" ;;
    esac
    unset _DM_MODE
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
}
