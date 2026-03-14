# home/lucasxll/modules/gammastep.nix
# Modo noturno: 18:00 → 2000K / 06:00 → 6500K
# DESATIVAR: comentar o import no default.nix

{ ... }:

{
  services.gammastep = {
    enable      = true;
    tray        = true;
    dawnTime    = "06:00";
    duskTime    = "18:00";
    temperature = { day = 6500; night = 2000; };
    settings.general = {
      fade             = 1;
      adjustment-method = "randr";
    };
  };
}
