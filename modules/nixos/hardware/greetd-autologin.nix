{ config, pkgs, lib, ... }:

{
  services.greetd = {
    enable  = true;
    restart = false;
    settings = rec {
      initial_session = {
        # TODO(mango): confirme o nome do binário/pacote exposto pelo módulo
        # `programs.mango` (ex.: `pkgs.mango`) — não veio no zip enviado pra
        # eu conferir o caminho exato como fiz antes com `config.programs.niri.package`.
        command = "${pkgs.mango}/bin/mango";
        user    = "lucasxll";
      };
      default_session = initial_session;
    };
  };

  security.pam.services.greetd = {};

  systemd.services.display-manager.enable = lib.mkForce false;
}
