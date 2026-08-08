{ config, pkgs, lib, ... }:
{
  # programs.espanso não existe nesse home-manager (módulo recente demais
  # pro input travado no flake.lock) — instalando e configurando na mão,
  # igual o mango.nix faz com xdg.configFile.
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

  # ── PACOTE COMUNITÁRIO PT-BR (vendorizado) ───────────────────────────────
  # O comando "espanso install" é interativo e trava em serviço systemd sem
  # terminal. Em vez disso, copiei o conteúdo REAL do pacote typofixer-pt-br
  # direto do repositório oficial do Espanso Hub (github.com/espanso/hub,
  # packages/typofixer-pt-br/0.1.0/package.yml) — verificado por mim em
  # 2026-08-07, 22 correções ortográficas reais (não abreviação de chat,
  # e sim erros ortográficos genuínos tipo "ancioso"->"ansioso").
  # O repositório original do autor (rapha-au/typofixer-pt-br) está fora do
  # ar; esse conteúdo veio do mirror oficial do Hub, que é o que o "espanso
  # install" baixaria de qualquer forma.
  xdg.configFile."espanso/match/typofixer-pt-br.yml".text = ''
    name: typofixer-pt-br
    matches:
      - trigger: "excessão"
        replace: "exceção"
        propagate_case: true
        word: true
      - trigger: "ancioso"
        replace: "ansioso"
        propagate_case: true
        word: true
      - trigger: "subcídio"
        replace: "subsídio"
        propagate_case: true
        word: true
      - trigger: "paralizado"
        replace: "paralisado"
        propagate_case: true
        word: true
      - trigger: "licensa"
        replace: "licença"
        propagate_case: true
        word: true
      - trigger: "descanço"
        replace: "descanso"
        propagate_case: true
        word: true
      - trigger: "cançaço"
        replace: "cansaço"
        propagate_case: true
        word: true
      - trigger: "ascenção"
        replace: "ascensão"
        propagate_case: true
        word: true
      - trigger: "encomodar"
        replace: "incomodar"
        propagate_case: true
        word: true
      - trigger: "extender"
        replace: "estender"
        propagate_case: true
        word: true
      - trigger: "concerteza"
        replace: "com certeza"
        propagate_case: true
        word: true
      - trigger: "derrepente"
        replace: "de repente"
        propagate_case: true
        word: true
      - trigger: "porisso"
        replace: "por isso"
        propagate_case: true
        word: true
      - trigger: "apartir de"
        replace: "a partir de"
        propagate_case: true
        word: true
      - trigger: "mecher"
        replace: "mexer"
        propagate_case: true
        word: true
      - trigger: "chingar"
        replace: "xingar"
        propagate_case: true
        word: true
      - trigger: "xuxu"
        replace: "chuchu"
        propagate_case: true
        word: true
      - trigger: "geito"
        replace: "jeito"
        propagate_case: true
        word: true
      - trigger: "beje"
        replace: "bege"
        propagate_case: true
        word: true
      - trigger: "quiz"
        replace: "quis"
        propagate_case: true
        word: true
      - trigger: "conciencia"
        replace: "consciência"
        propagate_case: true
        word: true
      - trigger: "guspir"
        replace: "cuspir"
        propagate_case: true
        word: true
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
