{ pkgs, ... }:

{
  hardware.bluetooth = {
    powerOnBoot = true;
    settings.General = {
      Enable       = "Source,Sink,Media,Socket";
      AutoConnect  = true;
      MultiProfile = "multiple";
      Experimental = true;  # desativa hsphfpd (conflita com wireplumber)
    };
  };

  services.pipewire.wireplumber.extraConfig = {
    "bluetooth" = {
      "monitor.bluez.properties" = {
        "bluez5.auto-connect"     = [ "a2dp_sink" "hfp_hf" ];
        "bluez5.roles"            = [ "a2dp_sink" "a2dp_source" "hfp_hf" "hsp_hs" ];
        "bluez5.enable-msbc"      = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.hfphsp-backend"   = "native";
      };
    };
    "auto-switch" = {
      "monitor.alsa.rules" = [
        {
          matches = [ { "node.name" = "~bluez*"; } ];
          actions.update-props."priority.session" = 2000;
        }
      ];
    };
  };

  environment.systemPackages = [ pkgs.playerctl ];
}
