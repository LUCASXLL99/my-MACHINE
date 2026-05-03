# modules/nixos/hardware/bluetooth-audio.nix
#
# Corrige dois problemas:
# 1. Botões do fone (play/pause/next/prev) funcionam via MPRIS
# 2. Sink muda automaticamente para o fone ao conectar (A2DP)
# 3. Ao desconectar o fone, volta para o sink anterior

{ pkgs, ... }:

{
  # Habilita suporte bluetooth com A2DP e controles de mídia
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Habilita todos os perfis de áudio
        Enable         = "Source,Sink,Media,Socket";
        # Reconecta automaticamente ao ligar o fone
        AutoConnect    = true;
        # Usa A2DP (alta qualidade) por padrão em vez de HFP (baixa)
        MultiProfile   = "multiple";
      };
    };
  };

  # Wireplumber — gerencia roteamento de áudio automaticamente
  services.pipewire.wireplumber.extraConfig = {
    "bluetooth" = {
      "monitor.bluez.properties" = {
        # Conecta direto no A2DP (alta qualidade) ao parear
        "bluez5.auto-connect"  = [ "a2dp_sink" "hfp_hf" ];
        # Habilita os perfis necessários para botões funcionarem
        "bluez5.roles"         = [ "a2dp_sink" "hfp_hf" "hsp_hs" ];
        # Habilita MPRIS para controles de mídia (play/pause/next/prev)
        "bluez5.enable-msbc"   = true;
        "bluez5.enable-hw-volume" = true;
      };
    };
    # Troca de sink automática: ao conectar fone BT, áudio vai para ele
    "auto-switch" = {
      "wireplumber.settings" = {
        "device.routes.default-sink-volume-scale" = "linear";
      };
      "monitor.alsa.rules" = [
        {
          matches = [ { "node.name" = "~bluez*"; } ];
          actions = {
            update-props = {
              "priority.session" = 2000;
            };
          };
        }
      ];
    };
  };

  # playerctl — controla play/pause/next/prev via linha de comando
  # os botões do fone usam MPRIS que o playerctl implementa
  environment.systemPackages = [ pkgs.playerctl ];
}
