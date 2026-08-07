{ config, pkgs, lib, ... }:
{
  programs.espanso = {
    enable = true;

    # Wayland puro (niri): usa injeção de teclado virtual via wlroots,
    # não depende de X11 nem de IBus.
    package = pkgs.espanso-wayland;

    configs = {
      default = {
        # Sem prefixo: as correções abaixo disparam assim que você termina
        # de digitar a palavra errada (word boundary), igual autocorreção
        # de celular. Não precisa digitar ":algo" antes.
        backend = "Auto";
        word_separators = [ " " "." "," "!" "?" "\n" ";" ":" ];
      };
    };

    matches = {
      # Base de correções comuns em português. É só um começo — adicione
      # os erros que você mais comete no dia a dia aqui embaixo, no mesmo
      # formato { trigger = "..."; replace = "..."; }.
      base = {
        matches = [
          # Erros de digitação / abreviações comuns
          { trigger = "nao"; replace = "não"; }
          { trigger = "vc"; replace = "você"; }
          { trigger = "vcs"; replace = "vocês"; }
          { trigger = "pq"; replace = "porque"; }
          { trigger = "tb"; replace = "também"; }
          { trigger = "tbm"; replace = "também"; }
          { trigger = "q"; replace = "que"; }
          { trigger = "obg"; replace = "obrigado"; }
          { trigger = "vdd"; replace = "verdade"; }
          { trigger = "mto"; replace = "muito"; }
          { trigger = "mt"; replace = "muito"; }
          { trigger = "ateh"; replace = "até"; }
          { trigger = "entao"; replace = "então"; }
          { trigger = "eh"; replace = "é"; }
          { trigger = "agr"; replace = "agora"; }
          { trigger = "hj"; replace = "hoje"; }
          { trigger = "blz"; replace = "beleza"; }
          { trigger = "vlw"; replace = "valeu"; }
          { trigger = "cmg"; replace = "comigo"; }
          { trigger = "ctg"; replace = "contigo"; }
          { trigger = "pra"; replace = "para"; }
          { trigger = "pro"; replace = "para o"; }
          { trigger = "qdo"; replace = "quando"; }
          { trigger = "qq"; replace = "qualquer"; }
          { trigger = "sdd"; replace = "saudade"; }

          # ── Mais abreviações/erros comuns de digitação rápida em PT-BR ──
          { trigger = "vamo"; replace = "vamos"; }
          { trigger = "flw"; replace = "falou"; }
          { trigger = "dboa"; replace = "de boa"; }
          { trigger = "td"; replace = "tudo"; }
          { trigger = "tds"; replace = "todos"; }
          { trigger = "tbem"; replace = "também"; }
          { trigger = "pfv"; replace = "por favor"; }
          { trigger = "pfvr"; replace = "por favor"; }
          { trigger = "vdd?"; replace = "verdade?"; }
          { trigger = "blza"; replace = "beleza"; }
          { trigger = "vlws"; replace = "valeus"; }
          { trigger = "add"; replace = "adicionar"; }
          { trigger = "att"; replace = "atualizar"; }
          { trigger = "dnv"; replace = "de novo"; }
          { trigger = "msm"; replace = "mesmo"; }
          { trigger = "msmo"; replace = "mesmo"; }
          { trigger = "aki"; replace = "aqui"; }
          { trigger = "axo"; replace = "acho"; }
          { trigger = "cmo"; replace = "como"; }
          { trigger = "dpois"; replace = "depois"; }
          { trigger = "eng"; replace = "então"; }
          { trigger = "fzr"; replace = "fazer"; }
          { trigger = "gnt"; replace = "gente"; }
          { trigger = "hrs"; replace = "horas"; }
          { trigger = "infos"; replace = "informações"; }
          { trigger = "mlr"; replace = "melhor"; }
          { trigger = "nd"; replace = "nada"; }
          { trigger = "ngm"; replace = "ninguém"; }
          { trigger = "obrig"; replace = "obrigado"; }
          { trigger = "oq"; replace = "o que"; }
          { trigger = "pdr"; replace = "poder"; }
          { trigger = "pgto"; replace = "pagamento"; }
          { trigger = "pblm"; replace = "problema"; }
          { trigger = "qlq"; replace = "qualquer"; }
          { trigger = "qm"; replace = "quem"; }
          { trigger = "sdds"; replace = "saudades"; }
          { trigger = "sempr"; replace = "sempre"; }
          { trigger = "tp"; replace = "tipo"; }
          { trigger = "trampo"; replace = "trabalho"; }
          { trigger = "xq"; replace = "por que"; }
          # Removi de propósito gatilhos de 1 letra só, tipo "n" -> "não" e
          # "p" -> "para": eles disparariam sozinhos demais (ex: contando
          # "1, n, 3" ou variável de código "p") e virariam mais incômodo
          # que ajuda. Se quiser algum desses mesmo assim, me avisa.
        ];
      };
    };
  };
}
