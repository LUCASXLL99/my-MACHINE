# home/lucasxll/modules/picom.nix

{ ... }:

{
  services.picom = {
    enable  = true;
    backend = "glx";
    vSync   = true;
    shadow  = true;
    fade    = true;
    shadowOffsets  = [ (-8) (-8) ];
    shadowOpacity  = 0.5;
    fadeSteps      = [ 0.06 0.06 ];
    settings = {
      shadow-radius   = 10;
      corner-radius   = 8;
      inactive-opacity        = 0.88;
      active-opacity          = 1.0;
      blur-method             = "dual_kawase";
      blur-strength           = 4;
      use-damage              = true;
      detect-rounded-corners  = true;
      shadow-exclude = [
        "name = 'Notification'"
        "class_g = 'Polybar'"
        "class_g = 'dunst'"
      ];
      blur-background-exclude = [
        "class_g = 'Polybar'"
        "class_g = 'dunst'"
      ];
      rounded-corners-exclude = [ "class_g = 'Polybar'" ];
      opacity-rule = [
        "100:class_g = 'Rofi'"
        "100:class_g = 'Polybar'"
        "95:class_g  = 'vivaldi-stable'"
        "95:class_g  = 'obsidian'"
      ];
    };
  };
}
