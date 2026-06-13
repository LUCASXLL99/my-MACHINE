# home/lucasxll/modules/screen-reflect.nix
# DESATIVADO — não importado em default.nix.
# Espelhamento X11 via xrandr. Substituído por niri-mirror (mouse-invert.nix)
# que opera nativamente no Wayland via 'niri msg output'.

{ pkgs, ... }:

{
  systemd.user.services.flip-screen = {
    Unit = {
      Description = "Flip screen horizontally (X11)";
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
