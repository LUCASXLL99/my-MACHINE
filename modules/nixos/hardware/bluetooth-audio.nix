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
    # Evita que o node bluez seja suspenso após ficar ocioso.
    # É esse suspend que costuma fazer o áudio "sumir" e nunca mais
    # voltar mesmo com o headfone continuando conectado.
    "bluez-no-suspend" = {
      "monitor.bluez.rules" = [
        {
          matches = [ { "node.name" = "~bluez_output.*"; } ];
          actions.update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
        }
      ];
    };
  };

  environment.systemPackages = [ pkgs.playerctl ];
}
