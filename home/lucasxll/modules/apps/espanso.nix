{ config, pkgs, lib, ... }:
{
  # programs.espanso não existe nesse home-manager (módulo recente demais
  # pro input travado no flake.lock) — instalando e configurando na mão,
  # igual o niri.nix faz com xdg.configFile.
  home.packages = [ pkgs.espanso-wayland ];

  xdg.configFile."espanso/config/default.yml".text = ''
    # Sem prefixo: as correções abaixo disparam ao terminar de digitar a
    # palavra errada (word boundary) — não precisa digitar ":algo" antes.
    backend: Auto
    word_separators: [" ", ".", ",", "!", "?", "\n", ";", ":"]
  '';

  xdg.configFile."espanso/match/base.yml".text = ''
    matches:
      # Erros de digitação / abreviações comuns em PT-BR
      - trigger: "nao"
        replace: "não"
      - trigger: "vc"
        replace: "você"
      - trigger: "vcs"
        replace: "vocês"
      - trigger: "pq"
        replace: "porque"
      - trigger: "tb"
        replace: "também"
      - trigger: "tbm"
        replace: "também"
      - trigger: "tbem"
        replace: "também"
      - trigger: "obg"
        replace: "obrigado"
      - trigger: "obrig"
        replace: "obrigado"
      - trigger: "mto"
        replace: "muito"
      - trigger: "mt"
        replace: "muito"
      - trigger: "entao"
        replace: "então"
      - trigger: "eh"
        replace: "é"
      - trigger: "agr"
        replace: "agora"
      - trigger: "hj"
        replace: "hoje"
      - trigger: "blz"
        replace: "beleza"
      - trigger: "blza"
        replace: "beleza"
      - trigger: "vlw"
        replace: "valeu"
      - trigger: "cmg"
        replace: "comigo"
      - trigger: "ctg"
        replace: "contigo"
      - trigger: "pra"
        replace: "para"
      - trigger: "pro"
        replace: "para o"
      - trigger: "qdo"
        replace: "quando"
      - trigger: "qq"
        replace: "qualquer"
      - trigger: "qlq"
        replace: "qualquer"
      - trigger: "sdd"
        replace: "saudade"
      - trigger: "sdds"
        replace: "saudades"
      - trigger: "vdd"
        replace: "verdade"
      - trigger: "vamo"
        replace: "vamos"
      - trigger: "flw"
        replace: "falou"
      - trigger: "dboa"
        replace: "de boa"
      - trigger: "td"
        replace: "tudo"
      - trigger: "tds"
        replace: "todos"
      - trigger: "pfv"
        replace: "por favor"
      - trigger: "pfvr"
        replace: "por favor"
      - trigger: "add"
        replace: "adicionar"
      - trigger: "att"
        replace: "atualizar"
      - trigger: "dnv"
        replace: "de novo"
      - trigger: "msm"
        replace: "mesmo"
      - trigger: "msmo"
        replace: "mesmo"
      - trigger: "aki"
        replace: "aqui"
      - trigger: "axo"
        replace: "acho"
      - trigger: "cmo"
        replace: "como"
      - trigger: "dpois"
        replace: "depois"
      - trigger: "eng"
        replace: "então"
      - trigger: "fzr"
        replace: "fazer"
      - trigger: "gnt"
        replace: "gente"
      - trigger: "hrs"
        replace: "horas"
      - trigger: "infos"
        replace: "informações"
      - trigger: "mlr"
        replace: "melhor"
      - trigger: "nd"
        replace: "nada"
      - trigger: "ngm"
        replace: "ninguém"
      - trigger: "oq"
        replace: "o que"
      - trigger: "pdr"
        replace: "poder"
      - trigger: "pgto"
        replace: "pagamento"
      - trigger: "pblm"
        replace: "problema"
      - trigger: "qm"
        replace: "quem"
      - trigger: "sempr"
        replace: "sempre"
      - trigger: "tp"
        replace: "tipo"
      - trigger: "trampo"
        replace: "trabalho"
      - trigger: "xq"
        replace: "por que"
      # Removi de propósito gatilhos de 1 letra só (tipo "n" -> "não",
      # "p" -> "para"): eles disparariam demais em contextos errados
      # (contagem, código, etc.) e virariam mais incômodo que ajuda.
  '';

  # Serviço systemd em vez de spawn-at-startup, mesmo padrão do
  # noctalia-shell.service: garante ambiente Wayland pronto antes de subir.
  systemd.user.services.espanso = {
    Unit = {
      Description = "Espanso — expansor/corretor de texto em tempo real";
      After       = [ "graphical-session.target" ];
      PartOf      = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart  = "${pkgs.espanso-wayland}/bin/espanso daemon";
      Restart    = "on-failure";
      RestartSec = "3s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
