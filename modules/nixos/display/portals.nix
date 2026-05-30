{ pkgs, ... }:

{
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common.default = [ "gtk" ];
      niri = {
        default                                     = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast"    = [ "wlr" ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [ "wlr" ];
        "org.freedesktop.impl.portal.FileChooser"   = [ "gtk" ];
        "org.freedesktop.impl.portal.Settings"      = [ "gtk" ];
      };
    };
  };
}
