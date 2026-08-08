{ config, pkgs, lib, ... }:

{
  services.greetd = {
    enable  = true;
    restart = false;
    settings = rec {
      initial_session = {
        # Confirmado na doc oficial do módulo NixOS do mango: com
        # `programs.mango.enable = true`, o binário `mango` já entra no
        # PATH do sistema (não é um pacote de nixpkgs, então `pkgs.mango`
        # não existe — daí o erro "attribute 'mango' missing").
        command = "mango";
        user    = "lucasxll";
      };
      default_session = initial_session;
    };
  };

  security.pam.services.greetd = {};

  systemd.services.display-manager.enable = lib.mkForce false;
}
