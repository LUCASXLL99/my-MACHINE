# home/lucasxll/modules/screen-reflect.nix
# Espelha a tela horizontalmente (X11 e KDE).
# DESATIVAR: comentar o import em default.nix

{ pkgs, ... }:

{
  xdg.configFile."autostart/flip-screen.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Flip Screen
    Exec=/bin/sh -c 'sleep 2 && for o in $(${pkgs.xorg.xrandr}/bin/xrandr | ${pkgs.gawk}/bin/awk "/ connected/{print \$1}"); do ${pkgs.xorg.xrandr}/bin/xrandr --output "$o" --reflect x; done'
    X-KDE-autostart-phase=1
    Hidden=false
    X-GNOME-Autostart-enabled=true
  '';

  systemd.user.services.flip-screen = {
    Unit = {
      Description = "Flip screen horizontally";
      After  = "graphical-session.target";
      PartOf = "graphical-session.target";
    };
    Service = {
      Type      = "oneshot";
      ExecStart = "/bin/sh -c 'sleep 2 && for o in $(${pkgs.xorg.xrandr}/bin/xrandr | ${pkgs.gawk}/bin/awk \"/ connected/{print \\$1}\"); do ${pkgs.xorg.xrandr}/bin/xrandr --output \"$o\" --reflect x; done'";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
