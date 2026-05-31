# home/lucasxll/modules/screen-reflect.nix
#
# Espelha a tela horizontalmente em qualquer WM/DE
# Funciona no KDE, bspwm e qualquer outro
#
# DESATIVAR: comentar o import no default.nix

{ pkgs, ... }:

{
  # Autostart via XDG — funciona no KDE e em qualquer DE que respeite XDG
  xdg.configFile."autostart/flip-screen.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Flip Screen
    Exec=/bin/sh -c 'sleep 2 && for o in $(${pkgs.xorg.xrandr}/bin/xrandr | ${pkgs.gawk}/bin/awk "/ connected/{print \$1}"); do ${pkgs.xorg.xrandr}/bin/xrandr --output "$o" --reflect x; done'
    X-KDE-autostart-phase=1
    Hidden=false
    X-GNOME-Autostart-enabled=true
  '';

  # Para bspwm — via systemd user service que roda após o login
  systemd.user.services.flip-screen = {
    Unit = {
      Description    = "Flip screen horizontally";
      After          = "graphical-session.target";
      PartOf         = "graphical-session.target";
    };
    Service = {
      Type      = "oneshot";
      ExecStart = "/bin/sh -c 'sleep 2 && for o in $(${pkgs.xorg.xrandr}/bin/xrandr | ${pkgs.gawk}/bin/awk \"/ connected/{print \\$1}\"); do ${pkgs.xorg.xrandr}/bin/xrandr --output \"$o\" --reflect x; done'";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
