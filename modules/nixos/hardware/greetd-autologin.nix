{ config, pkgs, lib, ... }:

{
  services.greetd = {
    enable  = true;
    restart = false;
    settings = rec {
      initial_session = {
        # Correção: "mango" solto (como a doc oficial mostra) depende do
        # binário estar no PATH do processo do greetd — deu "binário não
        # encontrado" no seu boot. Caminho completo do pacote, igual o
        # arquivo original fazia com o niri, é mais confiável e não depende
        # de PATH nenhum.
        command = "${config.programs.mango.package}/bin/mango";
        user    = "lucasxll";
      };
      default_session = initial_session;
    };
  };

  security.pam.services.greetd = {};

  systemd.services.display-manager.enable = lib.mkForce false;
}
