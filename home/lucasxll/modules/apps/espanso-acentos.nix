{ config, pkgs, lib, ... }:
{
  # ── 3000 correções de acentuação (gerado de dicionário real) ────────────
  # Pares "sem acento -> com acento" extraídos do dicionário oficial pt_BR
  # (o mesmo usado pelo LibreOffice/Firefox), filtrando qualquer palavra cuja
  # forma sem acento também seja válida sozinha (evita quebrar frases como
  # "esta casa" virando "está casa"). Gerado e verificado em 2026-08-07.
  #
  # AVISO DE QUALIDADE: sem dado de frequência de uso, não dá pra saber quais
  # dessas 3000 são comuns no dia a dia e quais são raras/técnicas. Se algo
  # atrapalhar mais do que ajudar, é só remover a linha correspondente aqui.
  xdg.configFile."espanso/match/acentos-3000.yml".text = ''
    name: acentos-3000
    matches:
          - trigger: "abax"
            replace: "ábax"
            propagate_case: true
            word: true
          - trigger: "abia"
            replace: "ábia"
            propagate_case: true
            word: true
          - trigger: "abis"
            replace: "ábis"
            propagate_case: true
            word: true
          - trigger: "aboi"
            replace: "aboí"
            propagate_case: true
            word: true
          - trigger: "acae"
            replace: "acaé"
            propagate_case: true
            word: true
          - trigger: "acai"
            replace: "açaí"
            propagate_case: true
            word: true
          - trigger: "acao"
            replace: "ação"
            propagate_case: true
            word: true
          - trigger: "acem"
            replace: "acém"
            propagate_case: true
            word: true
          - trigger: "acer"
            replace: "ácer"
            propagate_case: true
            word: true
          - trigger: "acie"
            replace: "ácie"
            propagate_case: true
            word: true
          - trigger: "acio"
            replace: "ácio"
            propagate_case: true
            word: true
          - trigger: "acra"
            replace: "acrá"
            propagate_case: true
            word: true
          - trigger: "acua"
            replace: "acuã"
            propagate_case: true
            word: true
          - trigger: "acue"
            replace: "acué"
            propagate_case: true
            word: true
          - trigger: "adai"
            replace: "adaí"
            propagate_case: true
            word: true
          - trigger: "adao"
            replace: "adão"
            propagate_case: true
            word: true
          - trigger: "adax"
            replace: "ádax"
            propagate_case: true
            word: true
          - trigger: "adja"
            replace: "adjá"
            propagate_case: true
            word: true
          - trigger: "afao"
            replace: "afão"
            propagate_case: true
            word: true
          - trigger: "afio"
            replace: "áfio"
            propagate_case: true
            word: true
          - trigger: "afis"
            replace: "áfis"
            propagate_case: true
            word: true
          - trigger: "afua"
            replace: "afuá"
            propagate_case: true
            word: true
          - trigger: "agai"
            replace: "agaí"
            propagate_case: true
            word: true
          - trigger: "agau"
            replace: "agaú"
            propagate_case: true
            word: true
          - trigger: "agbe"
            replace: "agbê"
            propagate_case: true
            word: true
          - trigger: "ager"
            replace: "áger"
            propagate_case: true
            word: true
          - trigger: "agil"
            replace: "ágil"
            propagate_case: true
            word: true
          - trigger: "agio"
            replace: "ágio"
            propagate_case: true
            word: true
          - trigger: "agni"
            replace: "ágni"
            propagate_case: true
            word: true
          - trigger: "agoe"
            replace: "agoé"
            propagate_case: true
            word: true
          - trigger: "agua"
            replace: "água"
            propagate_case: true
            word: true
          - trigger: "aguo"
            replace: "águo"
            propagate_case: true
            word: true
          - trigger: "aida"
            replace: "aída"
            propagate_case: true
            word: true
          - trigger: "ailo"
            replace: "ailó"
            propagate_case: true
            word: true
          - trigger: "aima"
            replace: "aimã"
            propagate_case: true
            word: true
          - trigger: "aipa"
            replace: "aipá"
            propagate_case: true
            word: true
          - trigger: "aira"
            replace: "airã"
            propagate_case: true
            word: true
          - trigger: "aiue"
            replace: "aiuê"
            propagate_case: true
            word: true
          - trigger: "aiva"
            replace: "aíva"
            propagate_case: true
            word: true
          - trigger: "alao"
            replace: "alão"
            propagate_case: true
            word: true
          - trigger: "alea"
            replace: "aléa"
            propagate_case: true
            word: true
          - trigger: "alem"
            replace: "além"
            propagate_case: true
            word: true
          - trigger: "aleu"
            replace: "aléu"
            propagate_case: true
            word: true
          - trigger: "alfa"
            replace: "alfá"
            propagate_case: true
            word: true
          - trigger: "alio"
            replace: "álio"
            propagate_case: true
            word: true
          - trigger: "aloa"
            replace: "aloá"
            propagate_case: true
            word: true
          - trigger: "aloe"
            replace: "áloe"
            propagate_case: true
            word: true
          - trigger: "alua"
            replace: "aluá"
            propagate_case: true
            word: true
          - trigger: "alva"
            replace: "alvã"
            propagate_case: true
            word: true
          - trigger: "amao"
            replace: "amão"
            propagate_case: true
            word: true
          - trigger: "amas"
            replace: "amás"
            propagate_case: true
            word: true
          - trigger: "ambe"
            replace: "ambé"
            propagate_case: true
            word: true
          - trigger: "amem"
            replace: "amém"
            propagate_case: true
            word: true
          - trigger: "amen"
            replace: "ámen"
            propagate_case: true
            word: true
          - trigger: "amio"
            replace: "âmio"
            propagate_case: true
            word: true
          - trigger: "amos"
            replace: "amós"
            propagate_case: true
            word: true
          - trigger: "anao"
            replace: "anão"
            propagate_case: true
            word: true
          - trigger: "ando"
            replace: "andó"
            propagate_case: true
            word: true
          - trigger: "anem"
            replace: "aném"
            propagate_case: true
            word: true
          - trigger: "anui"
            replace: "anuí"
            propagate_case: true
            word: true
          - trigger: "anuo"
            replace: "ânuo"
            propagate_case: true
            word: true
          - trigger: "anus"
            replace: "ânus"
            propagate_case: true
            word: true
          - trigger: "aola"
            replace: "aolá"
            propagate_case: true
            word: true
          - trigger: "apio"
            replace: "ápio"
            propagate_case: true
            word: true
          - trigger: "apis"
            replace: "ápis"
            propagate_case: true
            word: true
          - trigger: "apos"
            replace: "após"
            propagate_case: true
            word: true
          - trigger: "apue"
            replace: "apué"
            propagate_case: true
            word: true
          - trigger: "apui"
            replace: "apuí"
            propagate_case: true
            word: true
          - trigger: "arai"
            replace: "araí"
            propagate_case: true
            word: true
          - trigger: "arao"
            replace: "arão"
            propagate_case: true
            word: true
          - trigger: "arca"
            replace: "arçã"
            propagate_case: true
            word: true
          - trigger: "area"
            replace: "área"
            propagate_case: true
            word: true
          - trigger: "ares"
            replace: "arês"
            propagate_case: true
            word: true
          - trigger: "aria"
            replace: "ária"
            propagate_case: true
            word: true
          - trigger: "arie"
            replace: "arié"
            propagate_case: true
            word: true
          - trigger: "arna"
            replace: "arnã"
            propagate_case: true
            word: true
          - trigger: "arua"
            replace: "aruã"
            propagate_case: true
            word: true
          - trigger: "arue"
            replace: "arué"
            propagate_case: true
            word: true
          - trigger: "arum"
            replace: "árum"
            propagate_case: true
            word: true
          - trigger: "asca"
            replace: "ascá"
            propagate_case: true
            word: true
          - trigger: "asio"
            replace: "ásio"
            propagate_case: true
            word: true
          - trigger: "asoo"
            replace: "ásoo"
            propagate_case: true
            word: true
          - trigger: "assu"
            replace: "assú"
            propagate_case: true
            word: true
          - trigger: "atia"
            replace: "atiá"
            propagate_case: true
            word: true
          - trigger: "atio"
            replace: "átio"
            propagate_case: true
            word: true
          - trigger: "atis"
            replace: "átis"
            propagate_case: true
            word: true
          - trigger: "auai"
            replace: "auaí"
            propagate_case: true
            word: true
          - trigger: "auno"
            replace: "aúno"
            propagate_case: true
            word: true
          - trigger: "avai"
            replace: "avaí"
            propagate_case: true
            word: true
          - trigger: "avao"
            replace: "avão"
            propagate_case: true
            word: true
          - trigger: "avel"
            replace: "ável"
            propagate_case: true
            word: true
          - trigger: "avio"
            replace: "ávio"
            propagate_case: true
            word: true
          - trigger: "aviu"
            replace: "aviú"
            propagate_case: true
            word: true
          - trigger: "avos"
            replace: "avôs"
            propagate_case: true
            word: true
          - trigger: "axel"
            replace: "áxel"
            propagate_case: true
            word: true
          - trigger: "axil"
            replace: "áxil"
            propagate_case: true
            word: true
          - trigger: "axua"
            replace: "axuá"
            propagate_case: true
            word: true
          - trigger: "azem"
            replace: "ázem"
            propagate_case: true
            word: true
          - trigger: "azeo"
            replace: "ázeo"
            propagate_case: true
            word: true
          - trigger: "baba"
            replace: "babá"
            propagate_case: true
            word: true
          - trigger: "bade"
            replace: "badé"
            propagate_case: true
            word: true
          - trigger: "bado"
            replace: "badó"
            propagate_case: true
            word: true
          - trigger: "baie"
            replace: "baié"
            propagate_case: true
            word: true
          - trigger: "bale"
            replace: "balé"
            propagate_case: true
            word: true
          - trigger: "bali"
            replace: "báli"
            propagate_case: true
            word: true
          - trigger: "bama"
            replace: "bamá"
            propagate_case: true
            word: true
          - trigger: "bare"
            replace: "baré"
            propagate_case: true
            word: true
          - trigger: "basa"
            replace: "basã"
            propagate_case: true
            word: true
          - trigger: "bata"
            replace: "batá"
            propagate_case: true
            word: true
          - trigger: "bato"
            replace: "bató"
            propagate_case: true
            word: true
          - trigger: "baua"
            replace: "bauá"
            propagate_case: true
            word: true
          - trigger: "bava"
            replace: "bavá"
            propagate_case: true
            word: true
          - trigger: "baxa"
            replace: "baxá"
            propagate_case: true
            word: true
          - trigger: "baxe"
            replace: "baxé"
            propagate_case: true
            word: true
          - trigger: "baze"
            replace: "bazé"
            propagate_case: true
            word: true
          - trigger: "bebe"
            replace: "bebé"
            propagate_case: true
            word: true
          - trigger: "beca"
            replace: "beçá"
            propagate_case: true
            word: true
          - trigger: "beem"
            replace: "beém"
            propagate_case: true
            word: true
          - trigger: "befa"
            replace: "befá"
            propagate_case: true
            word: true
          - trigger: "bele"
            replace: "belê"
            propagate_case: true
            word: true
          - trigger: "bene"
            replace: "bené"
            propagate_case: true
            word: true
          - trigger: "bica"
            replace: "biça"
            propagate_case: true
            word: true
          - trigger: "bico"
            replace: "bicó"
            propagate_case: true
            word: true
          - trigger: "bide"
            replace: "bidê"
            propagate_case: true
            word: true
          - trigger: "bido"
            replace: "bidó"
            propagate_case: true
            word: true
          - trigger: "bipe"
            replace: "bipé"
            propagate_case: true
            word: true
          - trigger: "biro"
            replace: "birô"
            propagate_case: true
            word: true
          - trigger: "blas"
            replace: "blás"
            propagate_case: true
            word: true
          - trigger: "bobi"
            replace: "bóbi"
            propagate_case: true
            word: true
          - trigger: "boco"
            replace: "bocó"
            propagate_case: true
            word: true
          - trigger: "bocu"
            replace: "boçu"
            propagate_case: true
            word: true
          - trigger: "bodo"
            replace: "bodó"
            propagate_case: true
            word: true
          - trigger: "boer"
            replace: "bôer"
            propagate_case: true
            word: true
          - trigger: "bofe"
            replace: "bofé"
            propagate_case: true
            word: true
          - trigger: "bofo"
            replace: "bofó"
            propagate_case: true
            word: true
          - trigger: "bogo"
            replace: "bogó"
            propagate_case: true
            word: true
          - trigger: "bone"
            replace: "boné"
            propagate_case: true
            word: true
          - trigger: "bora"
            replace: "borá"
            propagate_case: true
            word: true
          - trigger: "bore"
            replace: "boré"
            propagate_case: true
            word: true
          - trigger: "boso"
            replace: "bosó"
            propagate_case: true
            word: true
          - trigger: "bozo"
            replace: "bozó"
            propagate_case: true
            word: true
          - trigger: "bras"
            replace: "brás"
            propagate_case: true
            word: true
          - trigger: "buca"
            replace: "bucã"
            propagate_case: true
            word: true
          - trigger: "buem"
            replace: "buém"
            propagate_case: true
            word: true
          - trigger: "bufe"
            replace: "bufê"
            propagate_case: true
            word: true
          - trigger: "buje"
            replace: "bujé"
            propagate_case: true
            word: true
          - trigger: "bure"
            replace: "burê"
            propagate_case: true
            word: true
          - trigger: "caba"
            replace: "cabã"
            propagate_case: true
            word: true
          - trigger: "caca"
            replace: "cacá"
            propagate_case: true
            word: true
          - trigger: "cadi"
            replace: "cádi"
            propagate_case: true
            word: true
          - trigger: "caem"
            replace: "caém"
            propagate_case: true
            word: true
          - trigger: "caia"
            replace: "caiã"
            propagate_case: true
            word: true
          - trigger: "caja"
            replace: "cajã"
            propagate_case: true
            word: true
          - trigger: "calo"
            replace: "calô"
            propagate_case: true
            word: true
          - trigger: "came"
            replace: "camé"
            propagate_case: true
            word: true
          - trigger: "cana"
            replace: "caná"
            propagate_case: true
            word: true
          - trigger: "capo"
            replace: "capô"
            propagate_case: true
            word: true
          - trigger: "cara"
            replace: "cará"
            propagate_case: true
            word: true
          - trigger: "care"
            replace: "caré"
            propagate_case: true
            word: true
          - trigger: "caua"
            replace: "cauá"
            propagate_case: true
            word: true
          - trigger: "caue"
            replace: "cauê"
            propagate_case: true
            word: true
          - trigger: "caui"
            replace: "cauí"
            propagate_case: true
            word: true
          - trigger: "cece"
            replace: "cecé"
            propagate_case: true
            word: true
          - trigger: "cele"
            replace: "celé"
            propagate_case: true
            word: true
          - trigger: "chao"
            replace: "chão"
            propagate_case: true
            word: true
          - trigger: "chas"
            replace: "chás"
            propagate_case: true
            word: true
          - trigger: "chua"
            replace: "chuá"
            propagate_case: true
            word: true
          - trigger: "chue"
            replace: "chué"
            propagate_case: true
            word: true
          - trigger: "ciao"
            replace: "cião"
            propagate_case: true
            word: true
          - trigger: "cida"
            replace: "cidã"
            propagate_case: true
            word: true
          - trigger: "cife"
            replace: "cifé"
            propagate_case: true
            word: true
          - trigger: "cime"
            replace: "cimé"
            propagate_case: true
            word: true
          - trigger: "cleo"
            replace: "cléo"
            propagate_case: true
            word: true
          - trigger: "cloe"
            replace: "clóe"
            propagate_case: true
            word: true
          - trigger: "code"
            replace: "codé"
            propagate_case: true
            word: true
          - trigger: "codo"
            replace: "codó"
            propagate_case: true
            word: true
          - trigger: "coix"
            replace: "cóix"
            propagate_case: true
            word: true
          - trigger: "core"
            replace: "coré"
            propagate_case: true
            word: true
          - trigger: "cosa"
            replace: "cosã"
            propagate_case: true
            word: true
          - trigger: "coto"
            replace: "cotó"
            propagate_case: true
            word: true
          - trigger: "coxi"
            replace: "cóxi"
            propagate_case: true
            word: true
          - trigger: "cras"
            replace: "crás"
            propagate_case: true
            word: true
          - trigger: "crue"
            replace: "crué"
            propagate_case: true
            word: true
          - trigger: "cruo"
            replace: "cruó"
            propagate_case: true
            word: true
          - trigger: "cube"
            replace: "cubé"
            propagate_case: true
            word: true
          - trigger: "cuiu"
            replace: "cuiú"
            propagate_case: true
            word: true
          - trigger: "cuma"
            replace: "cumã"
            propagate_case: true
            word: true
          - trigger: "cuna"
            replace: "cunã"
            propagate_case: true
            word: true
          - trigger: "cupe"
            replace: "cupé"
            propagate_case: true
            word: true
          - trigger: "curo"
            replace: "curó"
            propagate_case: true
            word: true
          - trigger: "cusa"
            replace: "cusã"
            propagate_case: true
            word: true
          - trigger: "cuxa"
            replace: "cuxá"
            propagate_case: true
            word: true
          - trigger: "daba"
            replace: "dabá"
            propagate_case: true
            word: true
          - trigger: "daca"
            replace: "daça"
            propagate_case: true
            word: true
          - trigger: "dada"
            replace: "dadá"
            propagate_case: true
            word: true
          - trigger: "deao"
            replace: "deão"
            propagate_case: true
            word: true
          - trigger: "dede"
            replace: "dedé"
            propagate_case: true
            word: true
          - trigger: "deli"
            replace: "déli"
            propagate_case: true
            word: true
          - trigger: "diba"
            replace: "dibá"
            propagate_case: true
            word: true
          - trigger: "dida"
            replace: "didá"
            propagate_case: true
            word: true
          - trigger: "dija"
            replace: "dijá"
            propagate_case: true
            word: true
          - trigger: "dili"
            replace: "díli"
            propagate_case: true
            word: true
          - trigger: "dina"
            replace: "diná"
            propagate_case: true
            word: true
          - trigger: "docu"
            replace: "doçu"
            propagate_case: true
            word: true
          - trigger: "dogo"
            replace: "dogô"
            propagate_case: true
            word: true
          - trigger: "dole"
            replace: "dolé"
            propagate_case: true
            word: true
          - trigger: "dori"
            replace: "dóri"
            propagate_case: true
            word: true
          - trigger: "doxu"
            replace: "dóxu"
            propagate_case: true
            word: true
          - trigger: "duba"
            replace: "dubá"
            propagate_case: true
            word: true
          - trigger: "eaco"
            replace: "êaco"
            propagate_case: true
            word: true
          - trigger: "ebia"
            replace: "ébia"
            propagate_case: true
            word: true
          - trigger: "ecai"
            replace: "eçaí"
            propagate_case: true
            word: true
          - trigger: "ecio"
            replace: "écio"
            propagate_case: true
            word: true
          - trigger: "ecra"
            replace: "ecrã"
            propagate_case: true
            word: true
          - trigger: "eden"
            replace: "éden"
            propagate_case: true
            word: true
          - trigger: "eder"
            replace: "éder"
            propagate_case: true
            word: true
          - trigger: "edia"
            replace: "édia"
            propagate_case: true
            word: true
          - trigger: "eduo"
            replace: "éduo"
            propagate_case: true
            word: true
          - trigger: "egba"
            replace: "egbá"
            propagate_case: true
            word: true
          - trigger: "egbe"
            replace: "egbé"
            propagate_case: true
            word: true
          - trigger: "egua"
            replace: "égua"
            propagate_case: true
            word: true
          - trigger: "egue"
            replace: "égue"
            propagate_case: true
            word: true
          - trigger: "eiro"
            replace: "eiró"
            propagate_case: true
            word: true
          - trigger: "elao"
            replace: "elão"
            propagate_case: true
            word: true
          - trigger: "elia"
            replace: "élia"
            propagate_case: true
            word: true
          - trigger: "elio"
            replace: "élio"
            propagate_case: true
            word: true
          - trigger: "eloa"
            replace: "eloá"
            propagate_case: true
            word: true
          - trigger: "eloi"
            replace: "eloí"
            propagate_case: true
            word: true
          - trigger: "eluo"
            replace: "eluô"
            propagate_case: true
            word: true
          - trigger: "embe"
            replace: "embé"
            propagate_case: true
            word: true
          - trigger: "emex"
            replace: "êmex"
            propagate_case: true
            word: true
          - trigger: "emis"
            replace: "êmis"
            propagate_case: true
            word: true
          - trigger: "eneo"
            replace: "éneo"
            propagate_case: true
            word: true
          - trigger: "enio"
            replace: "énio"
            propagate_case: true
            word: true
          - trigger: "enxo"
            replace: "enxó"
            propagate_case: true
            word: true
          - trigger: "eolo"
            replace: "éolo"
            propagate_case: true
            word: true
          - trigger: "eque"
            replace: "equê"
            propagate_case: true
            word: true
          - trigger: "equo"
            replace: "équo"
            propagate_case: true
            word: true
          - trigger: "ereo"
            replace: "éreo"
            propagate_case: true
            word: true
          - trigger: "eria"
            replace: "éria"
            propagate_case: true
            word: true
          - trigger: "eris"
            replace: "éris"
            propagate_case: true
            word: true
          - trigger: "erix"
            replace: "érix"
            propagate_case: true
            word: true
          - trigger: "erno"
            replace: "ernô"
            propagate_case: true
            word: true
          - trigger: "esau"
            replace: "esaú"
            propagate_case: true
            word: true
          - trigger: "esba"
            replace: "esbã"
            propagate_case: true
            word: true
          - trigger: "esio"
            replace: "ésio"
            propagate_case: true
            word: true
          - trigger: "esox"
            replace: "ésox"
            propagate_case: true
            word: true
          - trigger: "etao"
            replace: "etão"
            propagate_case: true
            word: true
          - trigger: "euba"
            replace: "eubá"
            propagate_case: true
            word: true
          - trigger: "evax"
            replace: "évax"
            propagate_case: true
            word: true
          - trigger: "evoe"
            replace: "evoé"
            propagate_case: true
            word: true
          - trigger: "exao"
            replace: "exão"
            propagate_case: true
            word: true
          - trigger: "exon"
            replace: "éxon"
            propagate_case: true
            word: true
          - trigger: "exul"
            replace: "êxul"
            propagate_case: true
            word: true
          - trigger: "ezem"
            replace: "ezém"
            propagate_case: true
            word: true
          - trigger: "ezio"
            replace: "ézio"
            propagate_case: true
            word: true
          - trigger: "fafa"
            replace: "fafá"
            propagate_case: true
            word: true
          - trigger: "faja"
            replace: "fajã"
            propagate_case: true
            word: true
          - trigger: "fare"
            replace: "faré"
            propagate_case: true
            word: true
          - trigger: "feao"
            replace: "feão"
            propagate_case: true
            word: true
          - trigger: "fela"
            replace: "felã"
            propagate_case: true
            word: true
          - trigger: "felo"
            replace: "felô"
            propagate_case: true
            word: true
          - trigger: "fifo"
            replace: "fifó"
            propagate_case: true
            word: true
          - trigger: "fija"
            replace: "fijá"
            propagate_case: true
            word: true
          - trigger: "file"
            replace: "filé"
            propagate_case: true
            word: true
          - trigger: "filo"
            replace: "filó"
            propagate_case: true
            word: true
          - trigger: "fobo"
            replace: "fobó"
            propagate_case: true
            word: true
          - trigger: "fota"
            replace: "fotã"
            propagate_case: true
            word: true
          - trigger: "fuao"
            replace: "fuão"
            propagate_case: true
            word: true
          - trigger: "fula"
            replace: "fulá"
            propagate_case: true
            word: true
          - trigger: "fume"
            replace: "fumê"
            propagate_case: true
            word: true
          - trigger: "fune"
            replace: "funé"
            propagate_case: true
            word: true
          - trigger: "gaga"
            replace: "gagá"
            propagate_case: true
            word: true
          - trigger: "gaje"
            replace: "gajé"
            propagate_case: true
            word: true
          - trigger: "gaji"
            replace: "gáji"
            propagate_case: true
            word: true
          - trigger: "gale"
            replace: "galé"
            propagate_case: true
            word: true
          - trigger: "gapo"
            replace: "gapó"
            propagate_case: true
            word: true
          - trigger: "gara"
            replace: "gará"
            propagate_case: true
            word: true
          - trigger: "gees"
            replace: "geês"
            propagate_case: true
            word: true
          - trigger: "gete"
            replace: "geté"
            propagate_case: true
            word: true
          - trigger: "giao"
            replace: "gião"
            propagate_case: true
            word: true
          - trigger: "gile"
            replace: "gilê"
            propagate_case: true
            word: true
          - trigger: "gize"
            replace: "gizé"
            propagate_case: true
            word: true
          - trigger: "glao"
            replace: "glão"
            propagate_case: true
            word: true
          - trigger: "goes"
            replace: "goês"
            propagate_case: true
            word: true
          - trigger: "gofe"
            replace: "gofé"
            propagate_case: true
            word: true
          - trigger: "goia"
            replace: "goiá"
            propagate_case: true
            word: true
          - trigger: "gola"
            replace: "golã"
            propagate_case: true
            word: true
          - trigger: "goro"
            replace: "goró"
            propagate_case: true
            word: true
          - trigger: "grao"
            replace: "grão"
            propagate_case: true
            word: true
          - trigger: "greu"
            replace: "gréu"
            propagate_case: true
            word: true
          - trigger: "grio"
            replace: "griô"
            propagate_case: true
            word: true
          - trigger: "gute"
            replace: "guté"
            propagate_case: true
            word: true
          - trigger: "hada"
            replace: "hadá"
            propagate_case: true
            word: true
          - trigger: "hana"
            replace: "hanã"
            propagate_case: true
            word: true
          - trigger: "hara"
            replace: "harã"
            propagate_case: true
            word: true
          - trigger: "hema"
            replace: "hemã"
            propagate_case: true
            word: true
          - trigger: "hene"
            replace: "henê"
            propagate_case: true
            word: true
          - trigger: "hile"
            replace: "hilé"
            propagate_case: true
            word: true
          - trigger: "hoao"
            replace: "hoão"
            propagate_case: true
            word: true
          - trigger: "hoba"
            replace: "hobá"
            propagate_case: true
            word: true
          - trigger: "homa"
            replace: "homã"
            propagate_case: true
            word: true
          - trigger: "hose"
            replace: "hosé"
            propagate_case: true
            word: true
          - trigger: "hosi"
            replace: "hósi"
            propagate_case: true
            word: true
          - trigger: "hoya"
            replace: "hóya"
            propagate_case: true
            word: true
          - trigger: "hufa"
            replace: "hufã"
            propagate_case: true
            word: true
          - trigger: "huio"
            replace: "huío"
            propagate_case: true
            word: true
          - trigger: "iaba"
            replace: "iabá"
            propagate_case: true
            word: true
          - trigger: "iace"
            replace: "iacê"
            propagate_case: true
            word: true
          - trigger: "iage"
            replace: "iagê"
            propagate_case: true
            word: true
          - trigger: "iaia"
            replace: "iaiá"
            propagate_case: true
            word: true
          - trigger: "iale"
            replace: "ialê"
            propagate_case: true
            word: true
          - trigger: "iano"
            replace: "ianô"
            propagate_case: true
            word: true
          - trigger: "iata"
            replace: "iatá"
            propagate_case: true
            word: true
          - trigger: "iauo"
            replace: "iauô"
            propagate_case: true
            word: true
          - trigger: "iave"
            replace: "iavé"
            propagate_case: true
            word: true
          - trigger: "ibex"
            replace: "íbex"
            propagate_case: true
            word: true
          - trigger: "ibia"
            replace: "ibiã"
            propagate_case: true
            word: true
          - trigger: "ibis"
            replace: "íbis"
            propagate_case: true
            word: true
          - trigger: "icar"
            replace: "içar"
            propagate_case: true
            word: true
          - trigger: "icau"
            replace: "icaú"
            propagate_case: true
            word: true
          - trigger: "icem"
            replace: "icém"
            propagate_case: true
            word: true
          - trigger: "icho"
            replace: "ichó"
            propagate_case: true
            word: true
          - trigger: "icio"
            replace: "ício"
            propagate_case: true
            word: true
          - trigger: "idia"
            replace: "ídia"
            propagate_case: true
            word: true
          - trigger: "ieba"
            replace: "iebá"
            propagate_case: true
            word: true
          - trigger: "ieie"
            replace: "ieiê"
            propagate_case: true
            word: true
          - trigger: "ieis"
            replace: "íeis"
            propagate_case: true
            word: true
          - trigger: "iepe"
            replace: "iepê"
            propagate_case: true
            word: true
          - trigger: "iere"
            replace: "ieré"
            propagate_case: true
            word: true
          - trigger: "ifis"
            replace: "ífis"
            propagate_case: true
            word: true
          - trigger: "ifta"
            replace: "iftá"
            propagate_case: true
            word: true
          - trigger: "igue"
            replace: "ígue"
            propagate_case: true
            word: true
          - trigger: "ijui"
            replace: "ijuí"
            propagate_case: true
            word: true
          - trigger: "ileo"
            replace: "íleo"
            propagate_case: true
            word: true
          - trigger: "ilex"
            replace: "ílex"
            propagate_case: true
            word: true
          - trigger: "ilho"
            replace: "ilhó"
            propagate_case: true
            word: true
          - trigger: "ilio"
            replace: "ílio"
            propagate_case: true
            word: true
          - trigger: "imbe"
            replace: "imbé"
            propagate_case: true
            word: true
          - trigger: "inae"
            replace: "inaê"
            propagate_case: true
            word: true
          - trigger: "ines"
            replace: "inês"
            propagate_case: true
            word: true
          - trigger: "inhe"
            replace: "inhé"
            propagate_case: true
            word: true
          - trigger: "inio"
            replace: "ínio"
            propagate_case: true
            word: true
          - trigger: "inle"
            replace: "inlé"
            propagate_case: true
            word: true
          - trigger: "inta"
            replace: "intã"
            propagate_case: true
            word: true
          - trigger: "iobe"
            replace: "iobé"
            propagate_case: true
            word: true
          - trigger: "iobo"
            replace: "iobó"
            propagate_case: true
            word: true
          - trigger: "ioca"
            replace: "ioça"
            propagate_case: true
            word: true
          - trigger: "ioio"
            replace: "ioiô"
            propagate_case: true
            word: true
          - trigger: "iona"
            replace: "ioná"
            propagate_case: true
            word: true
          - trigger: "ioni"
            replace: "iôni"
            propagate_case: true
            word: true
          - trigger: "ipua"
            replace: "ipuã"
            propagate_case: true
            word: true
          - trigger: "ique"
            replace: "iquê"
            propagate_case: true
            word: true
          - trigger: "irae"
            replace: "iraê"
            propagate_case: true
            word: true
          - trigger: "irai"
            replace: "iraí"
            propagate_case: true
            word: true
          - trigger: "irao"
            replace: "irão"
            propagate_case: true
            word: true
          - trigger: "irio"
            replace: "írio"
            propagate_case: true
            word: true
          - trigger: "iris"
            replace: "íris"
            propagate_case: true
            word: true
          - trigger: "iroi"
            replace: "irói"
            propagate_case: true
            word: true
          - trigger: "irre"
            replace: "irré"
            propagate_case: true
            word: true
          - trigger: "isis"
            replace: "ísis"
            propagate_case: true
            word: true
          - trigger: "isva"
            replace: "isvá"
            propagate_case: true
            word: true
          - trigger: "itea"
            replace: "ítea"
            propagate_case: true
            word: true
          - trigger: "itna"
            replace: "itnã"
            propagate_case: true
            word: true
          - trigger: "itua"
            replace: "ituá"
            propagate_case: true
            word: true
          - trigger: "itui"
            replace: "ituí"
            propagate_case: true
            word: true
          - trigger: "iuca"
            replace: "iuçá"
            propagate_case: true
            word: true
          - trigger: "iuiu"
            replace: "iuiú"
            propagate_case: true
            word: true
          - trigger: "iula"
            replace: "iulã"
            propagate_case: true
            word: true
          - trigger: "iulo"
            replace: "iúlo"
            propagate_case: true
            word: true
          - trigger: "iuma"
            replace: "iumá"
            propagate_case: true
            word: true
          - trigger: "iuna"
            replace: "iúna"
            propagate_case: true
            word: true
          - trigger: "iura"
            replace: "iurá"
            propagate_case: true
            word: true
          - trigger: "iuro"
            replace: "iúro"
            propagate_case: true
            word: true
          - trigger: "ivai"
            replace: "ivaí"
            propagate_case: true
            word: true
          - trigger: "ixia"
            replace: "íxia"
            propagate_case: true
            word: true
          - trigger: "jaba"
            replace: "jabá"
            propagate_case: true
            word: true
          - trigger: "jabo"
            replace: "jabô"
            propagate_case: true
            word: true
          - trigger: "jaca"
            replace: "jaça"
            propagate_case: true
            word: true
          - trigger: "jace"
            replace: "jacé"
            propagate_case: true
            word: true
          - trigger: "jafe"
            replace: "jafé"
            propagate_case: true
            word: true
          - trigger: "jame"
            replace: "jamé"
            propagate_case: true
            word: true
          - trigger: "jane"
            replace: "jané"
            propagate_case: true
            word: true
          - trigger: "jape"
            replace: "japé"
            propagate_case: true
            word: true
          - trigger: "jara"
            replace: "jará"
            propagate_case: true
            word: true
          - trigger: "jare"
            replace: "jarê"
            propagate_case: true
            word: true
          - trigger: "jata"
            replace: "jatá"
            propagate_case: true
            word: true
          - trigger: "jaua"
            replace: "jauá"
            propagate_case: true
            word: true
          - trigger: "jave"
            replace: "javé"
            propagate_case: true
            word: true
          - trigger: "jeja"
            replace: "jejá"
            propagate_case: true
            word: true
          - trigger: "jera"
            replace: "jerá"
            propagate_case: true
            word: true
          - trigger: "jere"
            replace: "jerê"
            propagate_case: true
            word: true
          - trigger: "jexa"
            replace: "jexá"
            propagate_case: true
            word: true
          - trigger: "jica"
            replace: "jicá"
            propagate_case: true
            word: true
          - trigger: "jilo"
            replace: "jiló"
            propagate_case: true
            word: true
          - trigger: "jita"
            replace: "jitá"
            propagate_case: true
            word: true
          - trigger: "joao"
            replace: "joão"
            propagate_case: true
            word: true
          - trigger: "joda"
            replace: "jodá"
            propagate_case: true
            word: true
          - trigger: "jogo"
            replace: "jogó"
            propagate_case: true
            word: true
          - trigger: "jona"
            replace: "jonã"
            propagate_case: true
            word: true
          - trigger: "jose"
            replace: "josé"
            propagate_case: true
            word: true
          - trigger: "juda"
            replace: "judá"
            propagate_case: true
            word: true
          - trigger: "juja"
            replace: "jujá"
            propagate_case: true
            word: true
          - trigger: "juta"
            replace: "jutá"
            propagate_case: true
            word: true
          - trigger: "kaka"
            replace: "kaká"
            propagate_case: true
            word: true
          - trigger: "laba"
            replace: "labã"
            propagate_case: true
            word: true
          - trigger: "laco"
            replace: "laço"
            propagate_case: true
            word: true
          - trigger: "lais"
            replace: "laís"
            propagate_case: true
            word: true
          - trigger: "lame"
            replace: "lamé"
            propagate_case: true
            word: true
          - trigger: "lapa"
            replace: "lapá"
            propagate_case: true
            word: true
          - trigger: "lare"
            replace: "laré"
            propagate_case: true
            word: true
          - trigger: "laua"
            replace: "lauã"
            propagate_case: true
            word: true
          - trigger: "laue"
            replace: "laué"
            propagate_case: true
            word: true
          - trigger: "leao"
            replace: "leão"
            propagate_case: true
            word: true
          - trigger: "leiu"
            replace: "leiú"
            propagate_case: true
            word: true
          - trigger: "liao"
            replace: "lião"
            propagate_case: true
            word: true
          - trigger: "libo"
            replace: "libó"
            propagate_case: true
            word: true
          - trigger: "lico"
            replace: "liço"
            propagate_case: true
            word: true
          - trigger: "loao"
            replace: "loão"
            propagate_case: true
            word: true
          - trigger: "lobi"
            replace: "lóbi"
            propagate_case: true
            word: true
          - trigger: "loce"
            replace: "locé"
            propagate_case: true
            word: true
          - trigger: "lopi"
            replace: "lópi"
            propagate_case: true
            word: true
          - trigger: "lore"
            replace: "loré"
            propagate_case: true
            word: true
          - trigger: "lori"
            replace: "lóri"
            propagate_case: true
            word: true
          - trigger: "luis"
            replace: "luís"
            propagate_case: true
            word: true
          - trigger: "luue"
            replace: "luué"
            propagate_case: true
            word: true
          - trigger: "maca"
            replace: "macá"
            propagate_case: true
            word: true
          - trigger: "mada"
            replace: "madã"
            propagate_case: true
            word: true
          - trigger: "mage"
            replace: "magé"
            propagate_case: true
            word: true
          - trigger: "maia"
            replace: "maiá"
            propagate_case: true
            word: true
          - trigger: "maio"
            replace: "maiô"
            propagate_case: true
            word: true
          - trigger: "male"
            replace: "malê"
            propagate_case: true
            word: true
          - trigger: "mame"
            replace: "mamé"
            propagate_case: true
            word: true
          - trigger: "mana"
            replace: "maná"
            propagate_case: true
            word: true
          - trigger: "mane"
            replace: "mané"
            propagate_case: true
            word: true
          - trigger: "mape"
            replace: "mapé"
            propagate_case: true
            word: true
          - trigger: "mara"
            replace: "mará"
            propagate_case: true
            word: true
          - trigger: "mare"
            replace: "maré"
            propagate_case: true
            word: true
          - trigger: "mata"
            replace: "matã"
            propagate_case: true
            word: true
          - trigger: "maua"
            replace: "mauá"
            propagate_case: true
            word: true
          - trigger: "maue"
            replace: "maué"
            propagate_case: true
            word: true
          - trigger: "meao"
            replace: "meão"
            propagate_case: true
            word: true
          - trigger: "meda"
            replace: "mêda"
            propagate_case: true
            word: true
          - trigger: "meje"
            replace: "mejê"
            propagate_case: true
            word: true
          - trigger: "mele"
            replace: "melé"
            propagate_case: true
            word: true
          - trigger: "meoa"
            replace: "meoá"
            propagate_case: true
            word: true
          - trigger: "mesi"
            replace: "mési"
            propagate_case: true
            word: true
          - trigger: "meua"
            replace: "meuã"
            propagate_case: true
            word: true
          - trigger: "meuo"
            replace: "meuó"
            propagate_case: true
            word: true
          - trigger: "meze"
            replace: "mezé"
            propagate_case: true
            word: true
          - trigger: "mime"
            replace: "mimê"
            propagate_case: true
            word: true
          - trigger: "misa"
            replace: "misã"
            propagate_case: true
            word: true
          - trigger: "miua"
            replace: "miuá"
            propagate_case: true
            word: true
          - trigger: "moca"
            replace: "mocã"
            propagate_case: true
            word: true
          - trigger: "moco"
            replace: "mocó"
            propagate_case: true
            word: true
          - trigger: "mofe"
            replace: "mofé"
            propagate_case: true
            word: true
          - trigger: "mola"
            replace: "molá"
            propagate_case: true
            word: true
          - trigger: "moli"
            replace: "móli"
            propagate_case: true
            word: true
          - trigger: "more"
            replace: "moré"
            propagate_case: true
            word: true
          - trigger: "mouo"
            replace: "moúo"
            propagate_case: true
            word: true
          - trigger: "muca"
            replace: "muça"
            propagate_case: true
            word: true
          - trigger: "mufe"
            replace: "mufé"
            propagate_case: true
            word: true
          - trigger: "muia"
            replace: "muiá"
            propagate_case: true
            word: true
          - trigger: "mula"
            replace: "mulá"
            propagate_case: true
            word: true
          - trigger: "muna"
            replace: "munã"
            propagate_case: true
            word: true
          - trigger: "muni"
            replace: "múni"
            propagate_case: true
            word: true
          - trigger: "muon"
            replace: "múon"
            propagate_case: true
            word: true
          - trigger: "mura"
            replace: "murá"
            propagate_case: true
            word: true
          - trigger: "muta"
            replace: "mutá"
            propagate_case: true
            word: true
          - trigger: "nafe"
            replace: "nafé"
            propagate_case: true
            word: true
          - trigger: "nage"
            replace: "nagé"
            propagate_case: true
            word: true
          - trigger: "nago"
            replace: "nagô"
            propagate_case: true
            word: true
          - trigger: "naje"
            replace: "najé"
            propagate_case: true
            word: true
          - trigger: "nana"
            replace: "naná"
            propagate_case: true
            word: true
          - trigger: "nano"
            replace: "nanó"
            propagate_case: true
            word: true
          - trigger: "nata"
            replace: "natã"
            propagate_case: true
            word: true
          - trigger: "neao"
            replace: "neão"
            propagate_case: true
            word: true
          - trigger: "neea"
            replace: "néea"
            propagate_case: true
            word: true
          - trigger: "nene"
            replace: "nenê"
            propagate_case: true
            word: true
          - trigger: "nico"
            replace: "nicó"
            propagate_case: true
            word: true
          - trigger: "niro"
            replace: "niró"
            propagate_case: true
            word: true
          - trigger: "noba"
            replace: "nobá"
            propagate_case: true
            word: true
          - trigger: "nuda"
            replace: "nudá"
            propagate_case: true
            word: true
          - trigger: "nugo"
            replace: "nugó"
            propagate_case: true
            word: true
          - trigger: "nupe"
            replace: "nupé"
            propagate_case: true
            word: true
          - trigger: "oaca"
            replace: "oacá"
            propagate_case: true
            word: true
          - trigger: "oboe"
            replace: "oboé"
            propagate_case: true
            word: true
          - trigger: "ocio"
            replace: "ócio"
            propagate_case: true
            word: true
          - trigger: "ocra"
            replace: "ocrã"
            propagate_case: true
            word: true
          - trigger: "octa"
            replace: "octã"
            propagate_case: true
            word: true
          - trigger: "odio"
            replace: "ódio"
            propagate_case: true
            word: true
          - trigger: "ogao"
            replace: "ogão"
            propagate_case: true
            word: true
          - trigger: "oico"
            replace: "oiço"
            propagate_case: true
            word: true
          - trigger: "oleo"
            replace: "óleo"
            propagate_case: true
            word: true
          - trigger: "omer"
            replace: "ômer"
            propagate_case: true
            word: true
          - trigger: "omio"
            replace: "omiô"
            propagate_case: true
            word: true
          - trigger: "omue"
            replace: "omué"
            propagate_case: true
            word: true
          - trigger: "onca"
            replace: "onça"
            propagate_case: true
            word: true
          - trigger: "onha"
            replace: "onhã"
            propagate_case: true
            word: true
          - trigger: "onix"
            replace: "ônix"
            propagate_case: true
            word: true
          - trigger: "onus"
            replace: "ônus"
            propagate_case: true
            word: true
          - trigger: "opio"
            replace: "ópio"
            propagate_case: true
            word: true
          - trigger: "oqua"
            replace: "oquá"
            propagate_case: true
            word: true
          - trigger: "oque"
            replace: "oquê"
            propagate_case: true
            word: true
          - trigger: "oria"
            replace: "oriá"
            propagate_case: true
            word: true
          - trigger: "orio"
            replace: "oriô"
            propagate_case: true
            word: true
          - trigger: "orix"
            replace: "órix"
            propagate_case: true
            word: true
          - trigger: "orua"
            replace: "oruá"
            propagate_case: true
            word: true
          - trigger: "osse"
            replace: "ossé"
            propagate_case: true
            word: true
          - trigger: "otao"
            replace: "otão"
            propagate_case: true
            word: true
          - trigger: "ouco"
            replace: "oúco"
            propagate_case: true
            word: true
          - trigger: "ouga"
            replace: "ougã"
            propagate_case: true
            word: true
          - trigger: "ovem"
            replace: "ovém"
            propagate_case: true
            word: true
          - trigger: "oveo"
            replace: "óveo"
            propagate_case: true
            word: true
          - trigger: "ovni"
            replace: "óvni"
            propagate_case: true
            word: true
          - trigger: "pace"
            replace: "pacé"
            propagate_case: true
            word: true
          - trigger: "pada"
            replace: "padã"
            propagate_case: true
            word: true
          - trigger: "pade"
            replace: "padê"
            propagate_case: true
            word: true
          - trigger: "paia"
            replace: "paiá"
            propagate_case: true
            word: true
          - trigger: "paje"
            replace: "pajé"
            propagate_case: true
            word: true
          - trigger: "pali"
            replace: "páli"
            propagate_case: true
            word: true
          - trigger: "palo"
            replace: "paló"
            propagate_case: true
            word: true
          - trigger: "pana"
            replace: "panã"
            propagate_case: true
            word: true
          - trigger: "pano"
            replace: "panô"
            propagate_case: true
            word: true
          - trigger: "para"
            replace: "pará"
            propagate_case: true
            word: true
          - trigger: "paro"
            replace: "paró"
            propagate_case: true
            word: true
          - trigger: "pata"
            replace: "patã"
            propagate_case: true
            word: true
          - trigger: "pave"
            replace: "pavê"
            propagate_case: true
            word: true
          - trigger: "paxa"
            replace: "paxá"
            propagate_case: true
            word: true
          - trigger: "pean"
            replace: "péan"
            propagate_case: true
            word: true
          - trigger: "peao"
            replace: "peão"
            propagate_case: true
            word: true
          - trigger: "peca"
            replace: "pecã"
            propagate_case: true
            word: true
          - trigger: "peiu"
            replace: "peiú"
            propagate_case: true
            word: true
          - trigger: "pela"
            replace: "pelã"
            propagate_case: true
            word: true
          - trigger: "pele"
            replace: "pelé"
            propagate_case: true
            word: true
          - trigger: "peni"
            replace: "pêni"
            propagate_case: true
            word: true
          - trigger: "peon"
            replace: "péon"
            propagate_case: true
            word: true
          - trigger: "pere"
            replace: "peré"
            propagate_case: true
            word: true
          - trigger: "pete"
            replace: "peté"
            propagate_case: true
            word: true
          - trigger: "pexi"
            replace: "péxi"
            propagate_case: true
            word: true
          - trigger: "piai"
            replace: "piaí"
            propagate_case: true
            word: true
          - trigger: "piao"
            replace: "pião"
            propagate_case: true
            word: true
          - trigger: "pibo"
            replace: "pibó"
            propagate_case: true
            word: true
          - trigger: "pica"
            replace: "piça"
            propagate_case: true
            word: true
          - trigger: "pico"
            replace: "picó"
            propagate_case: true
            word: true
          - trigger: "pido"
            replace: "pidó"
            propagate_case: true
            word: true
          - trigger: "pier"
            replace: "píer"
            propagate_case: true
            word: true
          - trigger: "pile"
            replace: "pilé"
            propagate_case: true
            word: true
          - trigger: "pilo"
            replace: "piló"
            propagate_case: true
            word: true
          - trigger: "pine"
            replace: "piné"
            propagate_case: true
            word: true
          - trigger: "pioe"
            replace: "pioé"
            propagate_case: true
            word: true
          - trigger: "pion"
            replace: "píon"
            propagate_case: true
            word: true
          - trigger: "pira"
            replace: "pirã"
            propagate_case: true
            word: true
          - trigger: "pito"
            replace: "pitó"
            propagate_case: true
            word: true
          - trigger: "pivo"
            replace: "pivô"
            propagate_case: true
            word: true
          - trigger: "pixe"
            replace: "pixé"
            propagate_case: true
            word: true
          - trigger: "poco"
            replace: "poço"
            propagate_case: true
            word: true
          - trigger: "pojo"
            replace: "pojó"
            propagate_case: true
            word: true
          - trigger: "pole"
            replace: "polé"
            propagate_case: true
            word: true
          - trigger: "popo"
            replace: "popó"
            propagate_case: true
            word: true
          - trigger: "pora"
            replace: "porã"
            propagate_case: true
            word: true
          - trigger: "prea"
            replace: "preá"
            propagate_case: true
            word: true
          - trigger: "prua"
            replace: "pruá"
            propagate_case: true
            word: true
          - trigger: "puca"
            replace: "puçá"
            propagate_case: true
            word: true
          - trigger: "pulo"
            replace: "puló"
            propagate_case: true
            word: true
          - trigger: "puna"
            replace: "punã"
            propagate_case: true
            word: true
          - trigger: "pure"
            replace: "puré"
            propagate_case: true
            word: true
          - trigger: "quao"
            replace: "quão"
            propagate_case: true
            word: true
          - trigger: "quia"
            replace: "quiá"
            propagate_case: true
            word: true
          - trigger: "quie"
            replace: "quiê"
            propagate_case: true
            word: true
          - trigger: "rale"
            replace: "ralé"
            propagate_case: true
            word: true
          - trigger: "rape"
            replace: "rapé"
            propagate_case: true
            word: true
          - trigger: "rato"
            replace: "ratô"
            propagate_case: true
            word: true
          - trigger: "reca"
            replace: "reça"
            propagate_case: true
            word: true
          - trigger: "rego"
            replace: "regô"
            propagate_case: true
            word: true
          - trigger: "reis"
            replace: "réis"
            propagate_case: true
            word: true
          - trigger: "rene"
            replace: "renê"
            propagate_case: true
            word: true
          - trigger: "ribo"
            replace: "ribó"
            propagate_case: true
            word: true
          - trigger: "rido"
            replace: "ridô"
            propagate_case: true
            word: true
          - trigger: "robo"
            replace: "robô"
            propagate_case: true
            word: true
          - trigger: "roco"
            replace: "rocó"
            propagate_case: true
            word: true
          - trigger: "role"
            replace: "rolê"
            propagate_case: true
            word: true
          - trigger: "rose"
            replace: "rosê"
            propagate_case: true
            word: true
          - trigger: "ruao"
            replace: "ruão"
            propagate_case: true
            word: true
          - trigger: "ruba"
            replace: "rubá"
            propagate_case: true
            word: true
          - trigger: "rule"
            replace: "rulê"
            propagate_case: true
            word: true
          - trigger: "rume"
            replace: "rumé"
            propagate_case: true
            word: true
          - trigger: "saba"
            replace: "sabá"
            propagate_case: true
            word: true
          - trigger: "saca"
            replace: "sacã"
            propagate_case: true
            word: true
          - trigger: "sala"
            replace: "salá"
            propagate_case: true
            word: true
          - trigger: "sale"
            replace: "salé"
            propagate_case: true
            word: true
          - trigger: "sama"
            replace: "samá"
            propagate_case: true
            word: true
          - trigger: "sana"
            replace: "sanã"
            propagate_case: true
            word: true
          - trigger: "saos"
            replace: "sãos"
            propagate_case: true
            word: true
          - trigger: "sape"
            replace: "sapé"
            propagate_case: true
            word: true
          - trigger: "sara"
            replace: "sarã"
            propagate_case: true
            word: true
          - trigger: "sata"
            replace: "satã"
            propagate_case: true
            word: true
          - trigger: "saua"
            replace: "sauá"
            propagate_case: true
            word: true
          - trigger: "saui"
            replace: "sauí"
            propagate_case: true
            word: true
          - trigger: "save"
            replace: "savé"
            propagate_case: true
            word: true
          - trigger: "saxa"
            replace: "saxã"
            propagate_case: true
            word: true
          - trigger: "seda"
            replace: "sedã"
            propagate_case: true
            word: true
          - trigger: "sepe"
            replace: "sepé"
            propagate_case: true
            word: true
          - trigger: "sero"
            replace: "seró"
            propagate_case: true
            word: true
          - trigger: "siao"
            replace: "sião"
            propagate_case: true
            word: true
          - trigger: "soao"
            replace: "soão"
            propagate_case: true
            word: true
          - trigger: "soco"
            replace: "socó"
            propagate_case: true
            word: true
          - trigger: "sofa"
            replace: "sofá"
            propagate_case: true
            word: true
          - trigger: "sole"
            replace: "solé"
            propagate_case: true
            word: true
          - trigger: "soro"
            replace: "soró"
            propagate_case: true
            word: true
          - trigger: "soua"
            replace: "souá"
            propagate_case: true
            word: true
          - trigger: "suao"
            replace: "suão"
            propagate_case: true
            word: true
          - trigger: "sufa"
            replace: "sufá"
            propagate_case: true
            word: true
          - trigger: "sume"
            replace: "sumé"
            propagate_case: true
            word: true
          - trigger: "sumo"
            replace: "sumô"
            propagate_case: true
            word: true
          - trigger: "sura"
            replace: "surá"
            propagate_case: true
            word: true
          - trigger: "tabo"
            replace: "tabó"
            propagate_case: true
            word: true
          - trigger: "taca"
            replace: "taça"
            propagate_case: true
            word: true
          - trigger: "taia"
            replace: "taiá"
            propagate_case: true
            word: true
          - trigger: "taio"
            replace: "taió"
            propagate_case: true
            word: true
          - trigger: "tais"
            replace: "taís"
            propagate_case: true
            word: true
          - trigger: "taja"
            replace: "tajã"
            propagate_case: true
            word: true
          - trigger: "tama"
            replace: "tamá"
            propagate_case: true
            word: true
          - trigger: "tara"
            replace: "tarã"
            propagate_case: true
            word: true
          - trigger: "tare"
            replace: "taré"
            propagate_case: true
            word: true
          - trigger: "taro"
            replace: "tarô"
            propagate_case: true
            word: true
          - trigger: "tata"
            replace: "tatá"
            propagate_case: true
            word: true
          - trigger: "taua"
            replace: "tauá"
            propagate_case: true
            word: true
          - trigger: "taue"
            replace: "taué"
            propagate_case: true
            word: true
          - trigger: "taxa"
            replace: "taxã"
            propagate_case: true
            word: true
          - trigger: "taxi"
            replace: "táxi"
            propagate_case: true
            word: true
          - trigger: "tcha"
            replace: "tchã"
            propagate_case: true
            word: true
          - trigger: "tche"
            replace: "tchê"
            propagate_case: true
            word: true
          - trigger: "teco"
            replace: "tecó"
            propagate_case: true
            word: true
          - trigger: "teiu"
            replace: "teiú"
            propagate_case: true
            word: true
          - trigger: "tema"
            replace: "temã"
            propagate_case: true
            word: true
          - trigger: "tere"
            replace: "terê"
            propagate_case: true
            word: true
          - trigger: "tete"
            replace: "tête"
            propagate_case: true
            word: true
          - trigger: "teva"
            replace: "tevá"
            propagate_case: true
            word: true
          - trigger: "teve"
            replace: "tevê"
            propagate_case: true
            word: true
          - trigger: "tico"
            replace: "tiço"
            propagate_case: true
            word: true
          - trigger: "tiem"
            replace: "tiém"
            propagate_case: true
            word: true
          - trigger: "tije"
            replace: "tijé"
            propagate_case: true
            word: true
          - trigger: "tine"
            replace: "tiné"
            propagate_case: true
            word: true
          - trigger: "tita"
            replace: "titã"
            propagate_case: true
            word: true
          - trigger: "tobo"
            replace: "tobó"
            propagate_case: true
            word: true
          - trigger: "toca"
            replace: "toça"
            propagate_case: true
            word: true
          - trigger: "toco"
            replace: "tocó"
            propagate_case: true
            word: true
          - trigger: "todi"
            replace: "tódi"
            propagate_case: true
            word: true
          - trigger: "toma"
            replace: "tomã"
            propagate_case: true
            word: true
          - trigger: "tome"
            replace: "tomé"
            propagate_case: true
            word: true
          - trigger: "tore"
            replace: "toré"
            propagate_case: true
            word: true
          - trigger: "toro"
            replace: "toró"
            propagate_case: true
            word: true
          - trigger: "toto"
            replace: "totó"
            propagate_case: true
            word: true
          - trigger: "tras"
            replace: "trás"
            propagate_case: true
            word: true
          - trigger: "tres"
            replace: "três"
            propagate_case: true
            word: true
          - trigger: "tuba"
            replace: "tubã"
            propagate_case: true
            word: true
          - trigger: "tuca"
            replace: "tucá"
            propagate_case: true
            word: true
          - trigger: "tuiu"
            replace: "tuiú"
            propagate_case: true
            word: true
          - trigger: "tuji"
            replace: "túji"
            propagate_case: true
            word: true
          - trigger: "tupa"
            replace: "tupá"
            propagate_case: true
            word: true
          - trigger: "tupe"
            replace: "tupé"
            propagate_case: true
            word: true
          - trigger: "tuxa"
            replace: "tuxá"
            propagate_case: true
            word: true
          - trigger: "uaca"
            replace: "uaçá"
            propagate_case: true
            word: true
          - trigger: "uafe"
            replace: "uafé"
            propagate_case: true
            word: true
          - trigger: "uaia"
            replace: "uaiá"
            propagate_case: true
            word: true
          - trigger: "uaio"
            replace: "uaiô"
            propagate_case: true
            word: true
          - trigger: "uala"
            replace: "ualá"
            propagate_case: true
            word: true
          - trigger: "uali"
            replace: "uáli"
            propagate_case: true
            word: true
          - trigger: "uama"
            replace: "uamá"
            propagate_case: true
            word: true
          - trigger: "uana"
            replace: "uaná"
            propagate_case: true
            word: true
          - trigger: "uapa"
            replace: "uapá"
            propagate_case: true
            word: true
          - trigger: "uape"
            replace: "uapê"
            propagate_case: true
            word: true
          - trigger: "uara"
            replace: "uará"
            propagate_case: true
            word: true
          - trigger: "uaua"
            replace: "uauá"
            propagate_case: true
            word: true
          - trigger: "ubai"
            replace: "ubaí"
            propagate_case: true
            word: true
          - trigger: "ubio"
            replace: "úbio"
            propagate_case: true
            word: true
          - trigger: "ucue"
            replace: "ucué"
            propagate_case: true
            word: true
          - trigger: "ucui"
            replace: "ucuí"
            propagate_case: true
            word: true
          - trigger: "uedi"
            replace: "uédi"
            propagate_case: true
            word: true
          - trigger: "uera"
            replace: "uerá"
            propagate_case: true
            word: true
          - trigger: "ueua"
            replace: "uéua"
            propagate_case: true
            word: true
          - trigger: "ufua"
            replace: "ufuá"
            propagate_case: true
            word: true
          - trigger: "uira"
            replace: "uirá"
            propagate_case: true
            word: true
          - trigger: "ulao"
            replace: "ulão"
            propagate_case: true
            word: true
          - trigger: "ulex"
            replace: "úlex"
            propagate_case: true
            word: true
          - trigger: "umao"
            replace: "umão"
            propagate_case: true
            word: true
          - trigger: "umbe"
            replace: "umbê"
            propagate_case: true
            word: true
          - trigger: "unai"
            replace: "unaí"
            propagate_case: true
            word: true
          - trigger: "unca"
            replace: "unça"
            propagate_case: true
            word: true
          - trigger: "unga"
            replace: "ungá"
            propagate_case: true
            word: true
          - trigger: "unlo"
            replace: "unló"
            propagate_case: true
            word: true
          - trigger: "urai"
            replace: "uraí"
            propagate_case: true
            word: true
          - trigger: "usia"
            replace: "úsia"
            propagate_case: true
            word: true
          - trigger: "util"
            replace: "útil"
            propagate_case: true
            word: true
          - trigger: "uvea"
            replace: "úvea"
            propagate_case: true
            word: true
          - trigger: "uzem"
            replace: "uzém"
            propagate_case: true
            word: true
          - trigger: "vaea"
            replace: "váea"
            propagate_case: true
            word: true
          - trigger: "vaiu"
            replace: "vaiú"
            propagate_case: true
            word: true
          - trigger: "vaje"
            replace: "vajé"
            propagate_case: true
            word: true
          - trigger: "vali"
            replace: "váli"
            propagate_case: true
            word: true
          - trigger: "vaos"
            replace: "vãos"
            propagate_case: true
            word: true
          - trigger: "vere"
            replace: "verê"
            propagate_case: true
            word: true
          - trigger: "vies"
            replace: "viés"
            propagate_case: true
            word: true
          - trigger: "viro"
            replace: "viró"
            propagate_case: true
            word: true
          - trigger: "voce"
            replace: "você"
            propagate_case: true
            word: true
          - trigger: "vora"
            replace: "vorá"
            propagate_case: true
            word: true
          - trigger: "vovo"
            replace: "vovó"
            propagate_case: true
            word: true
          - trigger: "xaja"
            replace: "xajá"
            propagate_case: true
            word: true
          - trigger: "xaua"
            replace: "xauã"
            propagate_case: true
            word: true
          - trigger: "xere"
            replace: "xerê"
            propagate_case: true
            word: true
          - trigger: "xeva"
            replace: "xevá"
            propagate_case: true
            word: true
          - trigger: "xexe"
            replace: "xexé"
            propagate_case: true
            word: true
          - trigger: "xica"
            replace: "xiça"
            propagate_case: true
            word: true
          - trigger: "xiro"
            replace: "xiró"
            propagate_case: true
            word: true
          - trigger: "xixa"
            replace: "xixá"
            propagate_case: true
            word: true
          - trigger: "xoco"
            replace: "xocó"
            propagate_case: true
            word: true
          - trigger: "xodo"
            replace: "xodó"
            propagate_case: true
            word: true
          - trigger: "yoga"
            replace: "yôga"
            propagate_case: true
            word: true
          - trigger: "zare"
            replace: "zaré"
            propagate_case: true
            word: true
          - trigger: "zeba"
            replace: "zebá"
            propagate_case: true
            word: true
          - trigger: "zena"
            replace: "zenã"
            propagate_case: true
            word: true
          - trigger: "zere"
            replace: "zerê"
            propagate_case: true
            word: true
          - trigger: "zeze"
            replace: "zezé"
            propagate_case: true
            word: true
          - trigger: "zila"
            replace: "zilá"
            propagate_case: true
            word: true
          - trigger: "zoba"
            replace: "zobá"
            propagate_case: true
            word: true
          - trigger: "zora"
            replace: "zorá"
            propagate_case: true
            word: true
          - trigger: "aaiun"
            replace: "aaiún"
            propagate_case: true
            word: true
          - trigger: "aarao"
            replace: "aarão"
            propagate_case: true
            word: true
          - trigger: "ababe"
            replace: "ababé"
            propagate_case: true
            word: true
          - trigger: "abaca"
            replace: "abacá"
            propagate_case: true
            word: true
          - trigger: "abaco"
            replace: "ábaco"
            propagate_case: true
            word: true
          - trigger: "abada"
            replace: "abadá"
            propagate_case: true
            word: true
          - trigger: "abado"
            replace: "abadô"
            propagate_case: true
            word: true
          - trigger: "abaio"
            replace: "abaiô"
            propagate_case: true
            word: true
          - trigger: "abais"
            replace: "abaís"
            propagate_case: true
            word: true
          - trigger: "abaja"
            replace: "abajá"
            propagate_case: true
            word: true
          - trigger: "abalo"
            replace: "ábalo"
            propagate_case: true
            word: true
          - trigger: "abana"
            replace: "abaná"
            propagate_case: true
            word: true
          - trigger: "abare"
            replace: "ábare"
            propagate_case: true
            word: true
          - trigger: "abaro"
            replace: "ábaro"
            propagate_case: true
            word: true
          - trigger: "abato"
            replace: "ábato"
            propagate_case: true
            word: true
          - trigger: "abavo"
            replace: "ábavo"
            propagate_case: true
            word: true
          - trigger: "abdao"
            replace: "abdão"
            propagate_case: true
            word: true
          - trigger: "abeca"
            replace: "àbeça"
            propagate_case: true
            word: true
          - trigger: "abece"
            replace: "ábêcê"
            propagate_case: true
            word: true
          - trigger: "abede"
            replace: "abedê"
            propagate_case: true
            word: true
          - trigger: "abiao"
            replace: "abião"
            propagate_case: true
            word: true
          - trigger: "abico"
            replace: "abicô"
            propagate_case: true
            word: true
          - trigger: "abies"
            replace: "ábies"
            propagate_case: true
            word: true
          - trigger: "abiga"
            replace: "ábiga"
            propagate_case: true
            word: true
          - trigger: "abrao"
            replace: "abrão"
            propagate_case: true
            word: true
          - trigger: "absis"
            replace: "ábsis"
            propagate_case: true
            word: true
          - trigger: "absus"
            replace: "ábsus"
            propagate_case: true
            word: true
          - trigger: "abuxo"
            replace: "abuxó"
            propagate_case: true
            word: true
          - trigger: "acaba"
            replace: "ácaba"
            propagate_case: true
            word: true
          - trigger: "acaca"
            replace: "acaçá"
            propagate_case: true
            word: true
          - trigger: "acacu"
            replace: "açacu"
            propagate_case: true
            word: true
          - trigger: "acade"
            replace: "ácade"
            propagate_case: true
            word: true
          - trigger: "acaem"
            replace: "acaém"
            propagate_case: true
            word: true
          - trigger: "acaia"
            replace: "acaiá"
            propagate_case: true
            word: true
          - trigger: "acala"
            replace: "açalá"
            propagate_case: true
            word: true
          - trigger: "acano"
            replace: "ácano"
            propagate_case: true
            word: true
          - trigger: "acare"
            replace: "ácare"
            propagate_case: true
            word: true
          - trigger: "acari"
            replace: "ácari"
            propagate_case: true
            word: true
          - trigger: "acaro"
            replace: "ácaro"
            propagate_case: true
            word: true
          - trigger: "acato"
            replace: "ácato"
            propagate_case: true
            word: true
          - trigger: "acave"
            replace: "ácave"
            propagate_case: true
            word: true
          - trigger: "acavo"
            replace: "ácavo"
            propagate_case: true
            word: true
          - trigger: "accio"
            replace: "áccio"
            propagate_case: true
            word: true
          - trigger: "acero"
            replace: "ácero"
            propagate_case: true
            word: true
          - trigger: "achem"
            replace: "achém"
            propagate_case: true
            word: true
          - trigger: "achoa"
            replace: "achôa"
            propagate_case: true
            word: true
          - trigger: "acido"
            replace: "ácido"
            propagate_case: true
            word: true
          - trigger: "acino"
            replace: "ácino"
            propagate_case: true
            word: true
          - trigger: "acipe"
            replace: "ácipe"
            propagate_case: true
            word: true
          - trigger: "aclis"
            replace: "áclis"
            propagate_case: true
            word: true
          - trigger: "acmao"
            replace: "acmão"
            propagate_case: true
            word: true
          - trigger: "acnea"
            replace: "ácnea"
            propagate_case: true
            word: true
          - trigger: "acnua"
            replace: "ácnua"
            propagate_case: true
            word: true
          - trigger: "acoba"
            replace: "açobá"
            propagate_case: true
            word: true
          - trigger: "acoca"
            replace: "açoca"
            propagate_case: true
            word: true
          - trigger: "acola"
            replace: "acolá"
            propagate_case: true
            word: true
          - trigger: "acome"
            replace: "ácome"
            propagate_case: true
            word: true
          - trigger: "acona"
            replace: "aconá"
            propagate_case: true
            word: true
          - trigger: "acope"
            replace: "ácope"
            propagate_case: true
            word: true
          - trigger: "acopo"
            replace: "ácopo"
            propagate_case: true
            word: true
          - trigger: "acore"
            replace: "ácore"
            propagate_case: true
            word: true
          - trigger: "acoro"
            replace: "ácoro"
            propagate_case: true
            word: true
          - trigger: "acreu"
            replace: "acréu"
            propagate_case: true
            word: true
          - trigger: "acron"
            replace: "ácron"
            propagate_case: true
            word: true
          - trigger: "actio"
            replace: "áctio"
            propagate_case: true
            word: true
          - trigger: "acuba"
            replace: "açubá"
            propagate_case: true
            word: true
          - trigger: "acude"
            replace: "açude"
            propagate_case: true
            word: true
          - trigger: "acuem"
            replace: "acuém"
            propagate_case: true
            word: true
          - trigger: "acume"
            replace: "acumé"
            propagate_case: true
            word: true
          - trigger: "acumi"
            replace: "açumi"
            propagate_case: true
            word: true
          - trigger: "acure"
            replace: "acuré"
            propagate_case: true
            word: true
          - trigger: "adeba"
            replace: "adebá"
            propagate_case: true
            word: true
          - trigger: "adiao"
            replace: "adião"
            propagate_case: true
            word: true
          - trigger: "adila"
            replace: "ádila"
            propagate_case: true
            word: true
          - trigger: "adine"
            replace: "ádine"
            propagate_case: true
            word: true
          - trigger: "adioe"
            replace: "adioé"
            propagate_case: true
            word: true
          - trigger: "adion"
            replace: "adíon"
            propagate_case: true
            word: true
          - trigger: "adipe"
            replace: "ádipe"
            propagate_case: true
            word: true
          - trigger: "adipo"
            replace: "ádipo"
            propagate_case: true
            word: true
          - trigger: "adito"
            replace: "ádito"
            propagate_case: true
            word: true
          - trigger: "adixa"
            replace: "adixá"
            propagate_case: true
            word: true
          - trigger: "adoga"
            replace: "adogã"
            propagate_case: true
            word: true
          - trigger: "aecio"
            replace: "aécio"
            propagate_case: true
            word: true
          - trigger: "aelia"
            replace: "aélia"
            propagate_case: true
            word: true
          - trigger: "aeneo"
            replace: "aêneo"
            propagate_case: true
            word: true
          - trigger: "aereo"
            replace: "aéreo"
            propagate_case: true
            word: true
          - trigger: "afaca"
            replace: "áfaca"
            propagate_case: true
            word: true
          - trigger: "afefe"
            replace: "afefé"
            propagate_case: true
            word: true
          - trigger: "afilo"
            replace: "áfilo"
            propagate_case: true
            word: true
          - trigger: "afodo"
            replace: "áfodo"
            propagate_case: true
            word: true
          - trigger: "afono"
            replace: "áfono"
            propagate_case: true
            word: true
          - trigger: "afoxe"
            replace: "afoxé"
            propagate_case: true
            word: true
          - trigger: "afura"
            replace: "afurá"
            propagate_case: true
            word: true
          - trigger: "agabo"
            replace: "ágabo"
            propagate_case: true
            word: true
          - trigger: "agace"
            replace: "agacé"
            propagate_case: true
            word: true
          - trigger: "agada"
            replace: "agadá"
            propagate_case: true
            word: true
          - trigger: "agamo"
            replace: "ágamo"
            propagate_case: true
            word: true
          - trigger: "agape"
            replace: "ágape"
            propagate_case: true
            word: true
          - trigger: "agare"
            replace: "agaré"
            propagate_case: true
            word: true
          - trigger: "agaro"
            replace: "ágaro"
            propagate_case: true
            word: true
          - trigger: "agate"
            replace: "ágate"
            propagate_case: true
            word: true
          - trigger: "ageno"
            replace: "ágeno"
            propagate_case: true
            word: true
          - trigger: "agida"
            replace: "ágida"
            propagate_case: true
            word: true
          - trigger: "agino"
            replace: "ágino"
            propagate_case: true
            word: true
          - trigger: "aglae"
            replace: "aglaê"
            propagate_case: true
            word: true
          - trigger: "aglia"
            replace: "áglia"
            propagate_case: true
            word: true
          - trigger: "agmen"
            replace: "ágmen"
            propagate_case: true
            word: true
          - trigger: "agnes"
            replace: "agnês"
            propagate_case: true
            word: true
          - trigger: "agolo"
            replace: "ágolo"
            propagate_case: true
            word: true
          - trigger: "agoma"
            replace: "agomã"
            propagate_case: true
            word: true
          - trigger: "agono"
            replace: "ágono"
            propagate_case: true
            word: true
          - trigger: "agrao"
            replace: "agrão"
            propagate_case: true
            word: true
          - trigger: "agrem"
            replace: "agrém"
            propagate_case: true
            word: true
          - trigger: "agrio"
            replace: "ágrio"
            propagate_case: true
            word: true
          - trigger: "aguai"
            replace: "aguaí"
            propagate_case: true
            word: true
          - trigger: "aguam"
            replace: "águam"
            propagate_case: true
            word: true
          - trigger: "aguia"
            replace: "águia"
            propagate_case: true
            word: true
          - trigger: "aiaca"
            replace: "aiacá"
            propagate_case: true
            word: true
          - trigger: "aiapa"
            replace: "aiapá"
            propagate_case: true
            word: true
          - trigger: "aiape"
            replace: "aiapé"
            propagate_case: true
            word: true
          - trigger: "aicar"
            replace: "aiçar"
            propagate_case: true
            word: true
          - trigger: "aimao"
            replace: "aimão"
            propagate_case: true
            word: true
          - trigger: "aimas"
            replace: "aimás"
            propagate_case: true
            word: true
          - trigger: "aimee"
            replace: "aimeé"
            propagate_case: true
            word: true
          - trigger: "ainoa"
            replace: "ainoã"
            propagate_case: true
            word: true
          - trigger: "aioca"
            replace: "aiocá"
            propagate_case: true
            word: true
          - trigger: "airao"
            replace: "airão"
            propagate_case: true
            word: true
          - trigger: "airua"
            replace: "airuã"
            propagate_case: true
            word: true
          - trigger: "aitao"
            replace: "aitão"
            propagate_case: true
            word: true
          - trigger: "aiuca"
            replace: "aiucá"
            propagate_case: true
            word: true
          - trigger: "aivao"
            replace: "aivão"
            propagate_case: true
            word: true
          - trigger: "ajabo"
            replace: "ajabó"
            propagate_case: true
            word: true
          - trigger: "ajobo"
            replace: "ajobó"
            propagate_case: true
            word: true
          - trigger: "ajupa"
            replace: "ajupá"
            propagate_case: true
            word: true
          - trigger: "alabe"
            replace: "alabê"
            propagate_case: true
            word: true
          - trigger: "alacr"
            replace: "álacr"
            propagate_case: true
            word: true
          - trigger: "alafe"
            replace: "alafé"
            propagate_case: true
            word: true
          - trigger: "alalo"
            replace: "álalo"
            propagate_case: true
            word: true
          - trigger: "alamo"
            replace: "álamo"
            propagate_case: true
            word: true
          - trigger: "alavo"
            replace: "alavó"
            propagate_case: true
            word: true
          - trigger: "alboi"
            replace: "albói"
            propagate_case: true
            word: true
          - trigger: "album"
            replace: "álbum"
            propagate_case: true
            word: true
          - trigger: "alcao"
            replace: "alção"
            propagate_case: true
            word: true
          - trigger: "alcea"
            replace: "álcea"
            propagate_case: true
            word: true
          - trigger: "alemo"
            replace: "álemo"
            propagate_case: true
            word: true
          - trigger: "aleva"
            replace: "alevá"
            propagate_case: true
            word: true
          - trigger: "alfio"
            replace: "álfio"
            propagate_case: true
            word: true
          - trigger: "alges"
            replace: "algés"
            propagate_case: true
            word: true
          - trigger: "alhia"
            replace: "álhia"
            propagate_case: true
            word: true
          - trigger: "alias"
            replace: "aliás"
            propagate_case: true
            word: true
          - trigger: "aliba"
            replace: "áliba"
            propagate_case: true
            word: true
          - trigger: "alibi"
            replace: "álibi"
            propagate_case: true
            word: true
          - trigger: "alica"
            replace: "álica"
            propagate_case: true
            word: true
          - trigger: "alico"
            replace: "álico"
            propagate_case: true
            word: true
          - trigger: "alida"
            replace: "álida"
            propagate_case: true
            word: true
          - trigger: "alife"
            replace: "álife"
            propagate_case: true
            word: true
          - trigger: "alijo"
            replace: "alijó"
            propagate_case: true
            word: true
          - trigger: "alime"
            replace: "álime"
            propagate_case: true
            word: true
          - trigger: "almao"
            replace: "almão"
            propagate_case: true
            word: true
          - trigger: "alode"
            replace: "alodê"
            propagate_case: true
            word: true
          - trigger: "alofo"
            replace: "álofo"
            propagate_case: true
            word: true
          - trigger: "alogo"
            replace: "álogo"
            propagate_case: true
            word: true
          - trigger: "alpao"
            replace: "alpão"
            propagate_case: true
            word: true
          - trigger: "alpea"
            replace: "álpea"
            propagate_case: true
            word: true
          - trigger: "alqua"
            replace: "álqua"
            propagate_case: true
            word: true
          - trigger: "alufa"
            replace: "alufá"
            propagate_case: true
            word: true
          - trigger: "aluja"
            replace: "alujá"
            propagate_case: true
            word: true
          - trigger: "alula"
            replace: "álula"
            propagate_case: true
            word: true
          - trigger: "alvao"
            replace: "alvão"
            propagate_case: true
            word: true
          - trigger: "alveo"
            replace: "álveo"
            propagate_case: true
            word: true
          - trigger: "amago"
            replace: "âmago"
            propagate_case: true
            word: true
          - trigger: "amala"
            replace: "amalá"
            propagate_case: true
            word: true
          - trigger: "amale"
            replace: "amalé"
            propagate_case: true
            word: true
          - trigger: "amapa"
            replace: "amapá"
            propagate_case: true
            word: true
          - trigger: "ambao"
            replace: "ambão"
            propagate_case: true
            word: true
          - trigger: "ambar"
            replace: "âmbar"
            propagate_case: true
            word: true
          - trigger: "amboa"
            replace: "amboá"
            propagate_case: true
            word: true
          - trigger: "ambua"
            replace: "ambuá"
            propagate_case: true
            word: true
          - trigger: "ambui"
            replace: "ambuí"
            propagate_case: true
            word: true
          - trigger: "ameca"
            replace: "ameça"
            propagate_case: true
            word: true
          - trigger: "amico"
            replace: "ámico"
            propagate_case: true
            word: true
          - trigger: "amnio"
            replace: "âmnio"
            propagate_case: true
            word: true
          - trigger: "amrao"
            replace: "amrão"
            propagate_case: true
            word: true
          - trigger: "amure"
            replace: "amuré"
            propagate_case: true
            word: true
          - trigger: "amuxa"
            replace: "amuxã"
            propagate_case: true
            word: true
          - trigger: "anabo"
            replace: "anabó"
            propagate_case: true
            word: true
          - trigger: "anaca"
            replace: "anacá"
            propagate_case: true
            word: true
          - trigger: "anace"
            replace: "anacé"
            propagate_case: true
            word: true
          - trigger: "anage"
            replace: "anagé"
            propagate_case: true
            word: true
          - trigger: "anais"
            replace: "anaïs"
            propagate_case: true
            word: true
          - trigger: "anama"
            replace: "anamã"
            propagate_case: true
            word: true
          - trigger: "anana"
            replace: "ananã"
            propagate_case: true
            word: true
          - trigger: "anaua"
            replace: "anauá"
            propagate_case: true
            word: true
          - trigger: "anaue"
            replace: "anauê"
            propagate_case: true
            word: true
          - trigger: "andre"
            replace: "andré"
            propagate_case: true
            word: true
          - trigger: "angaa"
            replace: "angaá"
            propagate_case: true
            word: true
          - trigger: "angau"
            replace: "angaú"
            propagate_case: true
            word: true
          - trigger: "aniao"
            replace: "anião"
            propagate_case: true
            word: true
          - trigger: "animo"
            replace: "ânimo"
            propagate_case: true
            word: true
          - trigger: "anjao"
            replace: "anjão"
            propagate_case: true
            word: true
          - trigger: "anrao"
            replace: "anrão"
            propagate_case: true
            word: true
          - trigger: "ansia"
            replace: "ânsia"
            propagate_case: true
            word: true
          - trigger: "antao"
            replace: "antão"
            propagate_case: true
            word: true
          - trigger: "antia"
            replace: "ântia"
            propagate_case: true
            word: true
          - trigger: "anuai"
            replace: "anuaí"
            propagate_case: true
            word: true
          - trigger: "anuia"
            replace: "anuiá"
            propagate_case: true
            word: true
          - trigger: "anuja"
            replace: "anujá"
            propagate_case: true
            word: true
          - trigger: "anulo"
            replace: "ânulo"
            propagate_case: true
            word: true
          - trigger: "aoita"
            replace: "aoíta"
            propagate_case: true
            word: true
          - trigger: "aonio"
            replace: "aônio"
            propagate_case: true
            word: true
          - trigger: "apage"
            replace: "ápage"
            propagate_case: true
            word: true
          - trigger: "apama"
            replace: "apamá"
            propagate_case: true
            word: true
          - trigger: "apapa"
            replace: "apapá"
            propagate_case: true
            word: true
          - trigger: "apara"
            replace: "apará"
            propagate_case: true
            word: true
          - trigger: "apeja"
            replace: "apejá"
            propagate_case: true
            word: true
          - trigger: "apeto"
            replace: "ápeto"
            propagate_case: true
            word: true
          - trigger: "apiaa"
            replace: "apiaá"
            propagate_case: true
            word: true
          - trigger: "apiai"
            replace: "apiaí"
            propagate_case: true
            word: true
          - trigger: "apice"
            replace: "ápice"
            propagate_case: true
            word: true
          - trigger: "apida"
            replace: "ápida"
            propagate_case: true
            word: true
          - trigger: "apiro"
            replace: "ápiro"
            propagate_case: true
            word: true
          - trigger: "apita"
            replace: "apitã"
            propagate_case: true
            word: true
          - trigger: "apoca"
            replace: "apocã"
            propagate_case: true
            word: true
          - trigger: "apode"
            replace: "ápode"
            propagate_case: true
            word: true
          - trigger: "apone"
            replace: "ápone"
            propagate_case: true
            word: true
          - trigger: "apono"
            replace: "ápono"
            propagate_case: true
            word: true
          - trigger: "apore"
            replace: "aporé"
            propagate_case: true
            word: true
          - trigger: "aporo"
            replace: "áporo"
            propagate_case: true
            word: true
          - trigger: "apoto"
            replace: "ápoto"
            propagate_case: true
            word: true
          - trigger: "aprea"
            replace: "apreá"
            propagate_case: true
            word: true
          - trigger: "apuie"
            replace: "apuié"
            propagate_case: true
            word: true
          - trigger: "apulo"
            replace: "ápulo"
            propagate_case: true
            word: true
          - trigger: "aquem"
            replace: "aquém"
            propagate_case: true
            word: true
          - trigger: "aqueo"
            replace: "áqueo"
            propagate_case: true
            word: true
          - trigger: "araao"
            replace: "araão"
            propagate_case: true
            word: true
          - trigger: "araba"
            replace: "arabá"
            propagate_case: true
            word: true
          - trigger: "arabe"
            replace: "árabe"
            propagate_case: true
            word: true
          - trigger: "arabo"
            replace: "árabo"
            propagate_case: true
            word: true
          - trigger: "araca"
            replace: "araçá"
            propagate_case: true
            word: true
          - trigger: "arace"
            replace: "aracê"
            propagate_case: true
            word: true
          - trigger: "araia"
            replace: "araiá"
            propagate_case: true
            word: true
          - trigger: "araio"
            replace: "araió"
            propagate_case: true
            word: true
          - trigger: "araiu"
            replace: "araiú"
            propagate_case: true
            word: true
          - trigger: "arama"
            replace: "aramã"
            propagate_case: true
            word: true
          - trigger: "arana"
            replace: "aranã"
            propagate_case: true
            word: true
          - trigger: "arare"
            replace: "ararê"
            propagate_case: true
            word: true
          - trigger: "arata"
            replace: "aratá"
            propagate_case: true
            word: true
          - trigger: "araua"
            replace: "arauá"
            propagate_case: true
            word: true
          - trigger: "araue"
            replace: "araué"
            propagate_case: true
            word: true
          - trigger: "araxa"
            replace: "araxá"
            propagate_case: true
            word: true
          - trigger: "arbio"
            replace: "árbio"
            propagate_case: true
            word: true
          - trigger: "arcao"
            replace: "arção"
            propagate_case: true
            word: true
          - trigger: "arcio"
            replace: "árcio"
            propagate_case: true
            word: true
          - trigger: "ardea"
            replace: "árdea"
            propagate_case: true
            word: true
          - trigger: "arduo"
            replace: "árduo"
            propagate_case: true
            word: true
          - trigger: "areao"
            replace: "areão"
            propagate_case: true
            word: true
          - trigger: "arede"
            replace: "aredê"
            propagate_case: true
            word: true
          - trigger: "arere"
            replace: "arerê"
            propagate_case: true
            word: true
          - trigger: "argao"
            replace: "argão"
            propagate_case: true
            word: true
          - trigger: "argem"
            replace: "argém"
            propagate_case: true
            word: true
          - trigger: "argio"
            replace: "árgio"
            propagate_case: true
            word: true
          - trigger: "ariao"
            replace: "arião"
            propagate_case: true
            word: true
          - trigger: "aribe"
            replace: "aribé"
            propagate_case: true
            word: true
          - trigger: "arica"
            replace: "aricá"
            propagate_case: true
            word: true
          - trigger: "arico"
            replace: "árico"
            propagate_case: true
            word: true
          - trigger: "arido"
            replace: "árido"
            propagate_case: true
            word: true
          - trigger: "aries"
            replace: "áries"
            propagate_case: true
            word: true
          - trigger: "arigo"
            replace: "arigó"
            propagate_case: true
            word: true
          - trigger: "arima"
            replace: "arimã"
            propagate_case: true
            word: true
          - trigger: "arita"
            replace: "aritá"
            propagate_case: true
            word: true
          - trigger: "arjao"
            replace: "arjão"
            propagate_case: true
            word: true
          - trigger: "armao"
            replace: "armão"
            propagate_case: true
            word: true
          - trigger: "armeu"
            replace: "arméu"
            propagate_case: true
            word: true
          - trigger: "arnes"
            replace: "arnês"
            propagate_case: true
            word: true
          - trigger: "arpao"
            replace: "arpão"
            propagate_case: true
            word: true
          - trigger: "arpeu"
            replace: "arpéu"
            propagate_case: true
            word: true
          - trigger: "arras"
            replace: "arrás"
            propagate_case: true
            word: true
          - trigger: "arrio"
            replace: "arrió"
            propagate_case: true
            word: true
          - trigger: "arsio"
            replace: "arsío"
            propagate_case: true
            word: true
          - trigger: "arsis"
            replace: "ársis"
            propagate_case: true
            word: true
          - trigger: "aruai"
            replace: "aruaí"
            propagate_case: true
            word: true
          - trigger: "aruau"
            replace: "aruaú"
            propagate_case: true
            word: true
          - trigger: "arube"
            replace: "arubé"
            propagate_case: true
            word: true
          - trigger: "aruja"
            replace: "arujá"
            propagate_case: true
            word: true
          - trigger: "arula"
            replace: "árula"
            propagate_case: true
            word: true
          - trigger: "arura"
            replace: "arurá"
            propagate_case: true
            word: true
          - trigger: "asaro"
            replace: "ásaro"
            propagate_case: true
            word: true
          - trigger: "ascio"
            replace: "áscio"
            propagate_case: true
            word: true
          - trigger: "ascon"
            replace: "áscon"
            propagate_case: true
            word: true
          - trigger: "ascua"
            replace: "áscua"
            propagate_case: true
            word: true
          - trigger: "aspis"
            replace: "áspis"
            propagate_case: true
            word: true
          - trigger: "assai"
            replace: "assaí"
            propagate_case: true
            word: true
          - trigger: "assos"
            replace: "assôs"
            propagate_case: true
            word: true
          - trigger: "assua"
            replace: "assuã"
            propagate_case: true
            word: true
          - trigger: "aster"
            replace: "áster"
            propagate_case: true
            word: true
          - trigger: "astur"
            replace: "ástur"
            propagate_case: true
            word: true
          - trigger: "ataca"
            replace: "atacã"
            propagate_case: true
            word: true
          - trigger: "ataco"
            replace: "átaco"
            propagate_case: true
            word: true
          - trigger: "ataga"
            replace: "atagã"
            propagate_case: true
            word: true
          - trigger: "atala"
            replace: "atalá"
            propagate_case: true
            word: true
          - trigger: "atalo"
            replace: "átalo"
            propagate_case: true
            word: true
          - trigger: "atama"
            replace: "atamã"
            propagate_case: true
            word: true
          - trigger: "atare"
            replace: "atarê"
            propagate_case: true
            word: true
          - trigger: "atavo"
            replace: "átavo"
            propagate_case: true
            word: true
          - trigger: "atele"
            replace: "átele"
            propagate_case: true
            word: true
          - trigger: "atico"
            replace: "ático"
            propagate_case: true
            word: true
          - trigger: "aticu"
            replace: "atiçu"
            propagate_case: true
            word: true
          - trigger: "atila"
            replace: "átila"
            propagate_case: true
            word: true
          - trigger: "atimo"
            replace: "átimo"
            propagate_case: true
            word: true
          - trigger: "atipo"
            replace: "átipo"
            propagate_case: true
            word: true
          - trigger: "atofa"
            replace: "atofã"
            propagate_case: true
            word: true
          - trigger: "atomo"
            replace: "átomo"
            propagate_case: true
            word: true
          - trigger: "atono"
            replace: "átono"
            propagate_case: true
            word: true
          - trigger: "atoto"
            replace: "atotô"
            propagate_case: true
            word: true
          - trigger: "atrio"
            replace: "átrio"
            propagate_case: true
            word: true
          - trigger: "ature"
            replace: "aturé"
            propagate_case: true
            word: true
          - trigger: "auacu"
            replace: "auaçu"
            propagate_case: true
            word: true
          - trigger: "auaiu"
            replace: "auaiú"
            propagate_case: true
            word: true
          - trigger: "audio"
            replace: "áudio"
            propagate_case: true
            word: true
          - trigger: "auete"
            replace: "aueté"
            propagate_case: true
            word: true
          - trigger: "aufue"
            replace: "aufué"
            propagate_case: true
            word: true
          - trigger: "aulax"
            replace: "áulax"
            propagate_case: true
            word: true
          - trigger: "aureo"
            replace: "áureo"
            propagate_case: true
            word: true
          - trigger: "ausao"
            replace: "ausão"
            propagate_case: true
            word: true
          - trigger: "auste"
            replace: "aúste"
            propagate_case: true
            word: true
          - trigger: "auzao"
            replace: "auzão"
            propagate_case: true
            word: true
          - trigger: "avaca"
            replace: "avacá"
            propagate_case: true
            word: true
          - trigger: "avara"
            replace: "avará"
            propagate_case: true
            word: true
          - trigger: "avare"
            replace: "avaré"
            propagate_case: true
            word: true
          - trigger: "aveao"
            replace: "aveão"
            propagate_case: true
            word: true
          - trigger: "avela"
            replace: "avelã"
            propagate_case: true
            word: true
          - trigger: "aviao"
            replace: "avião"
            propagate_case: true
            word: true
          - trigger: "avido"
            replace: "ávido"
            propagate_case: true
            word: true
          - trigger: "avila"
            replace: "ávila"
            propagate_case: true
            word: true
          - trigger: "avoao"
            replace: "avoão"
            propagate_case: true
            word: true
          - trigger: "axexe"
            replace: "axexê"
            propagate_case: true
            word: true
          - trigger: "axico"
            replace: "áxico"
            propagate_case: true
            word: true
          - trigger: "axilo"
            replace: "áxilo"
            propagate_case: true
            word: true
          - trigger: "axixa"
            replace: "axixá"
            propagate_case: true
            word: true
          - trigger: "axone"
            replace: "áxone"
            propagate_case: true
            word: true
          - trigger: "axoxo"
            replace: "axoxô"
            propagate_case: true
            word: true
          - trigger: "azava"
            replace: "azavá"
            propagate_case: true
            word: true
          - trigger: "azeva"
            replace: "azevá"
            propagate_case: true
            word: true
          - trigger: "azibo"
            replace: "azibó"
            propagate_case: true
            word: true
          - trigger: "azigo"
            replace: "ázigo"
            propagate_case: true
            word: true
          - trigger: "azimo"
            replace: "ázimo"
            propagate_case: true
            word: true
          - trigger: "babao"
            replace: "babão"
            propagate_case: true
            word: true
          - trigger: "babia"
            replace: "babiá"
            propagate_case: true
            word: true
          - trigger: "babla"
            replace: "bablá"
            propagate_case: true
            word: true
          - trigger: "babui"
            replace: "babuí"
            propagate_case: true
            word: true
          - trigger: "bacao"
            replace: "bacão"
            propagate_case: true
            word: true
          - trigger: "bacis"
            replace: "bácis"
            propagate_case: true
            word: true
          - trigger: "badem"
            replace: "badém"
            propagate_case: true
            word: true
          - trigger: "badui"
            replace: "bádui"
            propagate_case: true
            word: true
          - trigger: "badur"
            replace: "bádur"
            propagate_case: true
            word: true
          - trigger: "baele"
            replace: "baelé"
            propagate_case: true
            word: true
          - trigger: "baena"
            replace: "baenã"
            propagate_case: true
            word: true
          - trigger: "bafer"
            replace: "báfer"
            propagate_case: true
            word: true
          - trigger: "bafia"
            replace: "báfia"
            propagate_case: true
            word: true
          - trigger: "bagda"
            replace: "bagdá"
            propagate_case: true
            word: true
          - trigger: "bagoa"
            replace: "bágoa"
            propagate_case: true
            word: true
          - trigger: "bagua"
            replace: "baguá"
            propagate_case: true
            word: true
          - trigger: "baiao"
            replace: "baião"
            propagate_case: true
            word: true
          - trigger: "baiau"
            replace: "baiaú"
            propagate_case: true
            word: true
          - trigger: "baira"
            replace: "baíra"
            propagate_case: true
            word: true
          - trigger: "balao"
            replace: "balão"
            propagate_case: true
            word: true
          - trigger: "balco"
            replace: "balço"
            propagate_case: true
            word: true
          - trigger: "balea"
            replace: "baleã"
            propagate_case: true
            word: true
          - trigger: "balia"
            replace: "bália"
            propagate_case: true
            word: true
          - trigger: "bambe"
            replace: "bambê"
            propagate_case: true
            word: true
          - trigger: "bamia"
            replace: "bâmia"
            propagate_case: true
            word: true
          - trigger: "banca"
            replace: "bançá"
            propagate_case: true
            word: true
          - trigger: "bando"
            replace: "bandó"
            propagate_case: true
            word: true
          - trigger: "bania"
            replace: "bânia"
            propagate_case: true
            word: true
          - trigger: "bansa"
            replace: "bansá"
            propagate_case: true
            word: true
          - trigger: "banta"
            replace: "bantã"
            propagate_case: true
            word: true
          - trigger: "bante"
            replace: "banté"
            propagate_case: true
            word: true
          - trigger: "banua"
            replace: "bânua"
            propagate_case: true
            word: true
          - trigger: "banze"
            replace: "banzé"
            propagate_case: true
            word: true
          - trigger: "baoba"
            replace: "baobá"
            propagate_case: true
            word: true
          - trigger: "barao"
            replace: "barão"
            propagate_case: true
            word: true
          - trigger: "barau"
            replace: "baraú"
            propagate_case: true
            word: true
          - trigger: "barca"
            replace: "barça"
            propagate_case: true
            word: true
          - trigger: "barea"
            replace: "bárea"
            propagate_case: true
            word: true
          - trigger: "barem"
            replace: "barém"
            propagate_case: true
            word: true
          - trigger: "bario"
            replace: "bário"
            propagate_case: true
            word: true
          - trigger: "barre"
            replace: "barré"
            propagate_case: true
            word: true
          - trigger: "barso"
            replace: "barsó"
            propagate_case: true
            word: true
          - trigger: "basio"
            replace: "básio"
            propagate_case: true
            word: true
          - trigger: "basis"
            replace: "básis"
            propagate_case: true
            word: true
          - trigger: "basse"
            replace: "bassê"
            propagate_case: true
            word: true
          - trigger: "batao"
            replace: "batão"
            propagate_case: true
            word: true
          - trigger: "batea"
            replace: "bátea"
            propagate_case: true
            word: true
          - trigger: "batia"
            replace: "batiá"
            propagate_case: true
            word: true
          - trigger: "batis"
            replace: "bátis"
            propagate_case: true
            word: true
          - trigger: "baule"
            replace: "baúle"
            propagate_case: true
            word: true
          - trigger: "baume"
            replace: "baumé"
            propagate_case: true
            word: true
          - trigger: "bauna"
            replace: "baúna"
            propagate_case: true
            word: true
          - trigger: "bavio"
            replace: "bávio"
            propagate_case: true
            word: true
          - trigger: "beaba"
            replace: "beabá"
            propagate_case: true
            word: true
          - trigger: "bebia"
            replace: "bébia"
            propagate_case: true
            word: true
          - trigger: "becua"
            replace: "bécua"
            propagate_case: true
            word: true
          - trigger: "bedao"
            replace: "bedão"
            propagate_case: true
            word: true
          - trigger: "bedem"
            replace: "bedém"
            propagate_case: true
            word: true
          - trigger: "bedui"
            replace: "beduí"
            propagate_case: true
            word: true
          - trigger: "begbe"
            replace: "begbê"
            propagate_case: true
            word: true
          - trigger: "begua"
            replace: "bégua"
            propagate_case: true
            word: true
          - trigger: "beico"
            replace: "beiçó"
            propagate_case: true
            word: true
          - trigger: "belao"
            replace: "belão"
            propagate_case: true
            word: true
          - trigger: "belem"
            replace: "belém"
            propagate_case: true
            word: true
          - trigger: "belio"
            replace: "bélio"
            propagate_case: true
            word: true
          - trigger: "belis"
            replace: "bélis"
            propagate_case: true
            word: true
          - trigger: "belua"
            replace: "bélua"
            propagate_case: true
            word: true
          - trigger: "belus"
            replace: "bélus"
            propagate_case: true
            word: true
          - trigger: "benca"
            replace: "bença"
            propagate_case: true
            word: true
          - trigger: "bende"
            replace: "bendé"
            propagate_case: true
            word: true
          - trigger: "bendo"
            replace: "bendó"
            propagate_case: true
            word: true
          - trigger: "benha"
            replace: "benhã"
            propagate_case: true
            word: true
          - trigger: "benia"
            replace: "bênia"
            propagate_case: true
            word: true
          - trigger: "berco"
            replace: "berço"
            propagate_case: true
            word: true
          - trigger: "bereu"
            replace: "beréu"
            propagate_case: true
            word: true
          - trigger: "beril"
            replace: "bêril"
            propagate_case: true
            word: true
          - trigger: "beris"
            replace: "béris"
            propagate_case: true
            word: true
          - trigger: "berix"
            replace: "bérix"
            propagate_case: true
            word: true
          - trigger: "beroe"
            replace: "beroé"
            propagate_case: true
            word: true
          - trigger: "betao"
            replace: "betão"
            propagate_case: true
            word: true
          - trigger: "betel"
            replace: "bétel"
            propagate_case: true
            word: true
          - trigger: "betis"
            replace: "bétis"
            propagate_case: true
            word: true
          - trigger: "betoi"
            replace: "betói"
            propagate_case: true
            word: true
          - trigger: "bibia"
            replace: "bibiá"
            propagate_case: true
            word: true
          - trigger: "bibio"
            replace: "bibió"
            propagate_case: true
            word: true
          - trigger: "bibla"
            replace: "biblá"
            propagate_case: true
            word: true
          - trigger: "biboi"
            replace: "bibói"
            propagate_case: true
            word: true
          - trigger: "bicao"
            replace: "bicão"
            propagate_case: true
            word: true
          - trigger: "bicia"
            replace: "bícia"
            propagate_case: true
            word: true
          - trigger: "bidao"
            replace: "bidão"
            propagate_case: true
            word: true
          - trigger: "biduo"
            replace: "bíduo"
            propagate_case: true
            word: true
          - trigger: "bigua"
            replace: "bígua"
            propagate_case: true
            word: true
          - trigger: "bijui"
            replace: "bijuí"
            propagate_case: true
            word: true
          - trigger: "bilho"
            replace: "bilhó"
            propagate_case: true
            word: true
          - trigger: "bilia"
            replace: "bília"
            propagate_case: true
            word: true
          - trigger: "bilis"
            replace: "bílis"
            propagate_case: true
            word: true
          - trigger: "bilmo"
            replace: "bilmó"
            propagate_case: true
            word: true
          - trigger: "bilsa"
            replace: "bilsã"
            propagate_case: true
            word: true
          - trigger: "bimao"
            replace: "bimão"
            propagate_case: true
            word: true
          - trigger: "binea"
            replace: "bineá"
            propagate_case: true
            word: true
          - trigger: "biniu"
            replace: "biniú"
            propagate_case: true
            word: true
          - trigger: "birco"
            replace: "birço"
            propagate_case: true
            word: true
          - trigger: "birma"
            replace: "birmã"
            propagate_case: true
            word: true
          - trigger: "bisao"
            replace: "bisão"
            propagate_case: true
            word: true
          - trigger: "biter"
            replace: "bíter"
            propagate_case: true
            word: true
          - trigger: "bitio"
            replace: "bítio"
            propagate_case: true
            word: true
          - trigger: "bitis"
            replace: "bítis"
            propagate_case: true
            word: true
          - trigger: "biura"
            replace: "biurá"
            propagate_case: true
            word: true
          - trigger: "bivio"
            replace: "bívio"
            propagate_case: true
            word: true
          - trigger: "blase"
            replace: "blasé"
            propagate_case: true
            word: true
          - trigger: "boaco"
            replace: "boaço"
            propagate_case: true
            word: true
          - trigger: "bobai"
            replace: "bobaí"
            propagate_case: true
            word: true
          - trigger: "bobao"
            replace: "bobão"
            propagate_case: true
            word: true
          - trigger: "bocao"
            replace: "bocão"
            propagate_case: true
            word: true
          - trigger: "bocio"
            replace: "bócio"
            propagate_case: true
            word: true
          - trigger: "bocue"
            replace: "bocué"
            propagate_case: true
            word: true
          - trigger: "boelo"
            replace: "boêlo"
            propagate_case: true
            word: true
          - trigger: "boers"
            replace: "bôers"
            propagate_case: true
            word: true
          - trigger: "bofia"
            replace: "bófia"
            propagate_case: true
            word: true
          - trigger: "boiao"
            replace: "boião"
            propagate_case: true
            word: true
          - trigger: "boicu"
            replace: "boiçu"
            propagate_case: true
            word: true
          - trigger: "boime"
            replace: "boimé"
            propagate_case: true
            word: true
          - trigger: "bojao"
            replace: "bojão"
            propagate_case: true
            word: true
          - trigger: "bojui"
            replace: "bojuí"
            propagate_case: true
            word: true
          - trigger: "bolao"
            replace: "bolão"
            propagate_case: true
            word: true
          - trigger: "boleu"
            replace: "boléu"
            propagate_case: true
            word: true
          - trigger: "bolho"
            replace: "bolhó"
            propagate_case: true
            word: true
          - trigger: "bongo"
            replace: "bongô"
            propagate_case: true
            word: true
          - trigger: "bonus"
            replace: "bônus"
            propagate_case: true
            word: true
          - trigger: "boora"
            replace: "boorá"
            propagate_case: true
            word: true
          - trigger: "borax"
            replace: "bórax"
            propagate_case: true
            word: true
          - trigger: "bordo"
            replace: "bordô"
            propagate_case: true
            word: true
          - trigger: "boris"
            replace: "bóris"
            propagate_case: true
            word: true
          - trigger: "bosao"
            replace: "bosão"
            propagate_case: true
            word: true
          - trigger: "boson"
            replace: "bóson"
            propagate_case: true
            word: true
          - trigger: "botao"
            replace: "botão"
            propagate_case: true
            word: true
          - trigger: "botio"
            replace: "botió"
            propagate_case: true
            word: true
          - trigger: "braja"
            replace: "brajá"
            propagate_case: true
            word: true
          - trigger: "briea"
            replace: "bríea"
            propagate_case: true
            word: true
          - trigger: "brion"
            replace: "bríon"
            propagate_case: true
            word: true
          - trigger: "broca"
            replace: "broça"
            propagate_case: true
            word: true
          - trigger: "bruaa"
            replace: "bruaá"
            propagate_case: true
            word: true
          - trigger: "brueu"
            replace: "bruéu"
            propagate_case: true
            word: true
          - trigger: "buacu"
            replace: "buaçu"
            propagate_case: true
            word: true
          - trigger: "bubao"
            replace: "bubão"
            propagate_case: true
            word: true
          - trigger: "bucue"
            replace: "bucué"
            propagate_case: true
            word: true
          - trigger: "bucui"
            replace: "bucuí"
            propagate_case: true
            word: true
          - trigger: "bufao"
            replace: "bufão"
            propagate_case: true
            word: true
          - trigger: "bufri"
            replace: "búfri"
            propagate_case: true
            word: true
          - trigger: "buige"
            replace: "buíge"
            propagate_case: true
            word: true
          - trigger: "builo"
            replace: "buílo"
            propagate_case: true
            word: true
          - trigger: "bujao"
            replace: "bujão"
            propagate_case: true
            word: true
          - trigger: "burao"
            replace: "burão"
            propagate_case: true
            word: true
          - trigger: "burco"
            replace: "burço"
            propagate_case: true
            word: true
          - trigger: "burgo"
            replace: "burgó"
            propagate_case: true
            word: true
          - trigger: "burno"
            replace: "burnó"
            propagate_case: true
            word: true
          - trigger: "burue"
            replace: "burué"
            propagate_case: true
            word: true
          - trigger: "butao"
            replace: "butão"
            propagate_case: true
            word: true
          - trigger: "buteo"
            replace: "búteo"
            propagate_case: true
            word: true
          - trigger: "butia"
            replace: "butiá"
            propagate_case: true
            word: true
          - trigger: "butio"
            replace: "bútio"
            propagate_case: true
            word: true
          - trigger: "buzio"
            replace: "búzio"
            propagate_case: true
            word: true
          - trigger: "caaco"
            replace: "caacó"
            propagate_case: true
            word: true
          - trigger: "caacu"
            replace: "caaçu"
            propagate_case: true
            word: true
          - trigger: "caaee"
            replace: "caaeé"
            propagate_case: true
            word: true
          - trigger: "cabau"
            replace: "cabaú"
            propagate_case: true
            word: true
          - trigger: "cabiu"
            replace: "cabiú"
            propagate_case: true
            word: true
          - trigger: "cabui"
            replace: "cabuí"
            propagate_case: true
            word: true
          - trigger: "cacao"
            replace: "cação"
            propagate_case: true
            word: true
          - trigger: "cacar"
            replace: "caçar"
            propagate_case: true
            word: true
          - trigger: "cacem"
            replace: "cacém"
            propagate_case: true
            word: true
          - trigger: "cache"
            replace: "cachê"
            propagate_case: true
            word: true
          - trigger: "cacua"
            replace: "caçuá"
            propagate_case: true
            word: true
          - trigger: "cadea"
            replace: "cadeá"
            propagate_case: true
            word: true
          - trigger: "cadue"
            replace: "caduê"
            propagate_case: true
            word: true
          - trigger: "caete"
            replace: "caetê"
            propagate_case: true
            word: true
          - trigger: "cagao"
            replace: "cagão"
            propagate_case: true
            word: true
          - trigger: "cagoa"
            replace: "cagoã"
            propagate_case: true
            word: true
          - trigger: "caiba"
            replace: "caíba"
            propagate_case: true
            word: true
          - trigger: "caibo"
            replace: "cãibo"
            propagate_case: true
            word: true
          - trigger: "caica"
            replace: "caiçá"
            propagate_case: true
            word: true
          - trigger: "caicu"
            replace: "caiçu"
            propagate_case: true
            word: true
          - trigger: "caina"
            replace: "cainã"
            propagate_case: true
            word: true
          - trigger: "caire"
            replace: "cairé"
            propagate_case: true
            word: true
          - trigger: "caite"
            replace: "caité"
            propagate_case: true
            word: true
          - trigger: "caito"
            replace: "caitó"
            propagate_case: true
            word: true
          - trigger: "caiua"
            replace: "caiuá"
            propagate_case: true
            word: true
          - trigger: "caiue"
            replace: "caiué"
            propagate_case: true
            word: true
          - trigger: "cajua"
            replace: "cajuá"
            propagate_case: true
            word: true
          - trigger: "cajui"
            replace: "cajuí"
            propagate_case: true
            word: true
          - trigger: "calao"
            replace: "calão"
            propagate_case: true
            word: true
          - trigger: "calix"
            replace: "cálix"
            propagate_case: true
            word: true
          - trigger: "calma"
            replace: "calmã"
            propagate_case: true
            word: true
          - trigger: "camaa"
            replace: "camaá"
            propagate_case: true
            word: true
          - trigger: "camao"
            replace: "camão"
            propagate_case: true
            word: true
          - trigger: "cambe"
            replace: "cambé"
            propagate_case: true
            word: true
          - trigger: "campe"
            replace: "campé"
            propagate_case: true
            word: true
          - trigger: "camua"
            replace: "camuá"
            propagate_case: true
            word: true
          - trigger: "canaa"
            replace: "canaã"
            propagate_case: true
            word: true
          - trigger: "candi"
            replace: "cândi"
            propagate_case: true
            word: true
          - trigger: "canga"
            replace: "cangá"
            propagate_case: true
            word: true
          - trigger: "canha"
            replace: "canhá"
            propagate_case: true
            word: true
          - trigger: "canoe"
            replace: "canoé"
            propagate_case: true
            word: true
          - trigger: "canon"
            replace: "cânon"
            propagate_case: true
            word: true
          - trigger: "cante"
            replace: "canté"
            propagate_case: true
            word: true
          - trigger: "canza"
            replace: "canzá"
            propagate_case: true
            word: true
          - trigger: "capao"
            replace: "capão"
            propagate_case: true
            word: true
          - trigger: "capea"
            replace: "cápea"
            propagate_case: true
            word: true
          - trigger: "capia"
            replace: "capiá"
            propagate_case: true
            word: true
          - trigger: "capua"
            replace: "cápua"
            propagate_case: true
            word: true
          - trigger: "caraa"
            replace: "caraá"
            propagate_case: true
            word: true
          - trigger: "carai"
            replace: "caraí"
            propagate_case: true
            word: true
          - trigger: "carao"
            replace: "carão"
            propagate_case: true
            word: true
          - trigger: "careu"
            replace: "caréu"
            propagate_case: true
            word: true
          - trigger: "carie"
            replace: "cárie"
            propagate_case: true
            word: true
          - trigger: "carii"
            replace: "carií"
            propagate_case: true
            word: true
          - trigger: "cario"
            replace: "carió"
            propagate_case: true
            word: true
          - trigger: "carne"
            replace: "carnê"
            propagate_case: true
            word: true
          - trigger: "caroa"
            replace: "caroá"
            propagate_case: true
            word: true
          - trigger: "caroe"
            replace: "caroé"
            propagate_case: true
            word: true
          - trigger: "carre"
            replace: "carrê"
            propagate_case: true
            word: true
          - trigger: "carua"
            replace: "caruá"
            propagate_case: true
            word: true
          - trigger: "carus"
            replace: "cárus"
            propagate_case: true
            word: true
          - trigger: "casao"
            replace: "casão"
            propagate_case: true
            word: true
          - trigger: "casba"
            replace: "casbá"
            propagate_case: true
            word: true
          - trigger: "casco"
            replace: "cascó"
            propagate_case: true
            word: true
          - trigger: "catao"
            replace: "catão"
            propagate_case: true
            word: true
          - trigger: "catia"
            replace: "cátia"
            propagate_case: true
            word: true
          - trigger: "catua"
            replace: "catuá"
            propagate_case: true
            word: true
          - trigger: "cauba"
            replace: "caúba"
            propagate_case: true
            word: true
          - trigger: "caulo"
            replace: "cauló"
            propagate_case: true
            word: true
          - trigger: "cauma"
            replace: "caumã"
            propagate_case: true
            word: true
          - trigger: "cauno"
            replace: "caúno"
            propagate_case: true
            word: true
          - trigger: "caure"
            replace: "cauré"
            propagate_case: true
            word: true
          - trigger: "cavao"
            replace: "cavão"
            propagate_case: true
            word: true
          - trigger: "cavea"
            replace: "cávea"
            propagate_case: true
            word: true
          - trigger: "cavia"
            replace: "cávia"
            propagate_case: true
            word: true
          - trigger: "caxao"
            replace: "caxão"
            propagate_case: true
            word: true
          - trigger: "caxua"
            replace: "caxuá"
            propagate_case: true
            word: true
          - trigger: "cebio"
            replace: "cébio"
            propagate_case: true
            word: true
          - trigger: "cebus"
            replace: "cébus"
            propagate_case: true
            word: true
          - trigger: "cecao"
            replace: "ceção"
            propagate_case: true
            word: true
          - trigger: "cecem"
            replace: "cecém"
            propagate_case: true
            word: true
          - trigger: "cecil"
            replace: "cécil"
            propagate_case: true
            word: true
          - trigger: "cecum"
            replace: "cécum"
            propagate_case: true
            word: true
          - trigger: "cedem"
            replace: "cedém"
            propagate_case: true
            word: true
          - trigger: "celao"
            replace: "celão"
            propagate_case: true
            word: true
          - trigger: "celeo"
            replace: "céleo"
            propagate_case: true
            word: true
          - trigger: "celio"
            replace: "célio"
            propagate_case: true
            word: true
          - trigger: "cenio"
            replace: "cênio"
            propagate_case: true
            word: true
          - trigger: "cenis"
            replace: "cênis"
            propagate_case: true
            word: true
          - trigger: "cereo"
            replace: "céreo"
            propagate_case: true
            word: true
          - trigger: "cerio"
            replace: "cério"
            propagate_case: true
            word: true
          - trigger: "ceris"
            replace: "céris"
            propagate_case: true
            word: true
          - trigger: "cesar"
            replace: "césar"
            propagate_case: true
            word: true
          - trigger: "cesio"
            replace: "césio"
            propagate_case: true
            word: true
          - trigger: "cevao"
            replace: "cevão"
            propagate_case: true
            word: true
          - trigger: "chabo"
            replace: "chabó"
            propagate_case: true
            word: true
          - trigger: "chaem"
            replace: "chaém"
            propagate_case: true
            word: true
          - trigger: "chaia"
            replace: "chaiá"
            propagate_case: true
            word: true
          - trigger: "chaja"
            replace: "chajá"
            propagate_case: true
            word: true
          - trigger: "chate"
            replace: "chaté"
            propagate_case: true
            word: true
          - trigger: "chaua"
            replace: "chauá"
            propagate_case: true
            word: true
          - trigger: "chaui"
            replace: "chauí"
            propagate_case: true
            word: true
          - trigger: "chebe"
            replace: "chebê"
            propagate_case: true
            word: true
          - trigger: "chiao"
            replace: "chião"
            propagate_case: true
            word: true
          - trigger: "chibe"
            replace: "chibé"
            propagate_case: true
            word: true
          - trigger: "chino"
            replace: "chinó"
            propagate_case: true
            word: true
          - trigger: "chiuo"
            replace: "chiuô"
            propagate_case: true
            word: true
          - trigger: "choco"
            replace: "choço"
            propagate_case: true
            word: true
          - trigger: "choes"
            replace: "chões"
            propagate_case: true
            word: true
          - trigger: "chogo"
            replace: "chogó"
            propagate_case: true
            word: true
          - trigger: "chone"
            replace: "choné"
            propagate_case: true
            word: true
          - trigger: "choro"
            replace: "choró"
            propagate_case: true
            word: true
          - trigger: "chule"
            replace: "chulé"
            propagate_case: true
            word: true
          - trigger: "cidro"
            replace: "cidró"
            propagate_case: true
            word: true
          - trigger: "cilio"
            replace: "cílio"
            propagate_case: true
            word: true
          - trigger: "cimbo"
            replace: "cimbó"
            propagate_case: true
            word: true
          - trigger: "cirao"
            replace: "cirão"
            propagate_case: true
            word: true
          - trigger: "cirio"
            replace: "círio"
            propagate_case: true
            word: true
          - trigger: "cisao"
            replace: "cisão"
            propagate_case: true
            word: true
          - trigger: "ciume"
            replace: "ciúme"
            propagate_case: true
            word: true
          - trigger: "ciuro"
            replace: "ciúro"
            propagate_case: true
            word: true
          - trigger: "civel"
            replace: "cível"
            propagate_case: true
            word: true
          - trigger: "coano"
            replace: "cóano"
            propagate_case: true
            word: true
          - trigger: "cobio"
            replace: "cóbio"
            propagate_case: true
            word: true
          - trigger: "coboi"
            replace: "cobói"
            propagate_case: true
            word: true
          - trigger: "cobua"
            replace: "cóbua"
            propagate_case: true
            word: true
          - trigger: "cobus"
            replace: "cóbus"
            propagate_case: true
            word: true
          - trigger: "cocao"
            replace: "cocão"
            propagate_case: true
            word: true
          - trigger: "cochi"
            replace: "cóchi"
            propagate_case: true
            word: true
          - trigger: "codao"
            replace: "códão"
            propagate_case: true
            word: true
          - trigger: "codea"
            replace: "côdea"
            propagate_case: true
            word: true
          - trigger: "codeo"
            replace: "códeo"
            propagate_case: true
            word: true
          - trigger: "codex"
            replace: "códex"
            propagate_case: true
            word: true
          - trigger: "codio"
            replace: "códio"
            propagate_case: true
            word: true
          - trigger: "codon"
            replace: "códon"
            propagate_case: true
            word: true
          - trigger: "codra"
            replace: "codrá"
            propagate_case: true
            word: true
          - trigger: "cofea"
            replace: "cófea"
            propagate_case: true
            word: true
          - trigger: "cofia"
            replace: "cófia"
            propagate_case: true
            word: true
          - trigger: "cofio"
            replace: "cofió"
            propagate_case: true
            word: true
          - trigger: "cogia"
            replace: "cógia"
            propagate_case: true
            word: true
          - trigger: "coisa"
            replace: "coisã"
            propagate_case: true
            word: true
          - trigger: "coite"
            replace: "coité"
            propagate_case: true
            word: true
          - trigger: "colas"
            replace: "colãs"
            propagate_case: true
            word: true
          - trigger: "coleo"
            replace: "cóleo"
            propagate_case: true
            word: true
          - trigger: "colia"
            replace: "cólia"
            propagate_case: true
            word: true
          - trigger: "colon"
            replace: "cólon"
            propagate_case: true
            word: true
          - trigger: "colua"
            replace: "cólua"
            propagate_case: true
            word: true
          - trigger: "colva"
            replace: "colvá"
            propagate_case: true
            word: true
          - trigger: "comao"
            replace: "comão"
            propagate_case: true
            word: true
          - trigger: "comea"
            replace: "cômea"
            propagate_case: true
            word: true
          - trigger: "comio"
            replace: "cômio"
            propagate_case: true
            word: true
          - trigger: "conia"
            replace: "coniã"
            propagate_case: true
            word: true
          - trigger: "copia"
            replace: "cópia"
            propagate_case: true
            word: true
          - trigger: "corao"
            replace: "corão"
            propagate_case: true
            word: true
          - trigger: "corco"
            replace: "corço"
            propagate_case: true
            word: true
          - trigger: "corio"
            replace: "cório"
            propagate_case: true
            word: true
          - trigger: "coris"
            replace: "córis"
            propagate_case: true
            word: true
          - trigger: "corra"
            replace: "corrá"
            propagate_case: true
            word: true
          - trigger: "corre"
            replace: "corré"
            propagate_case: true
            word: true
          - trigger: "corro"
            replace: "corró"
            propagate_case: true
            word: true
          - trigger: "cotao"
            replace: "cotão"
            propagate_case: true
            word: true
          - trigger: "couca"
            replace: "couça"
            propagate_case: true
            word: true
          - trigger: "coupe"
            replace: "coupé"
            propagate_case: true
            word: true
          - trigger: "covao"
            replace: "covão"
            propagate_case: true
            word: true
          - trigger: "covoa"
            replace: "covoá"
            propagate_case: true
            word: true
          - trigger: "coxao"
            replace: "coxão"
            propagate_case: true
            word: true
          - trigger: "crapo"
            replace: "crapô"
            propagate_case: true
            word: true
          - trigger: "craua"
            replace: "crauá"
            propagate_case: true
            word: true
          - trigger: "crede"
            replace: "credé"
            propagate_case: true
            word: true
          - trigger: "creie"
            replace: "creié"
            propagate_case: true
            word: true
          - trigger: "cuara"
            replace: "cuará"
            propagate_case: true
            word: true
          - trigger: "cuata"
            replace: "cuatá"
            propagate_case: true
            word: true
          - trigger: "cubie"
            replace: "cubié"
            propagate_case: true
            word: true
          - trigger: "cubio"
            replace: "cúbio"
            propagate_case: true
            word: true
          - trigger: "cubiu"
            replace: "cubiú"
            propagate_case: true
            word: true
          - trigger: "cuche"
            replace: "cuchê"
            propagate_case: true
            word: true
          - trigger: "cucio"
            replace: "cúcio"
            propagate_case: true
            word: true
          - trigger: "cudia"
            replace: "cúdia"
            propagate_case: true
            word: true
          - trigger: "cufea"
            replace: "cúfea"
            propagate_case: true
            word: true
          - trigger: "cufia"
            replace: "cúfia"
            propagate_case: true
            word: true
          - trigger: "cuiao"
            replace: "cuião"
            propagate_case: true
            word: true
          - trigger: "cuice"
            replace: "cuíce"
            propagate_case: true
            word: true
          - trigger: "cuine"
            replace: "cuíne"
            propagate_case: true
            word: true
          - trigger: "cuipe"
            replace: "cuipé"
            propagate_case: true
            word: true
          - trigger: "cuira"
            replace: "cuíra"
            propagate_case: true
            word: true
          - trigger: "cuita"
            replace: "cuitá"
            propagate_case: true
            word: true
          - trigger: "cuite"
            replace: "cuité"
            propagate_case: true
            word: true
          - trigger: "cuito"
            replace: "cuitó"
            propagate_case: true
            word: true
          - trigger: "culeo"
            replace: "cúleo"
            propagate_case: true
            word: true
          - trigger: "culex"
            replace: "cúlex"
            propagate_case: true
            word: true
          - trigger: "cumai"
            replace: "cumaí"
            propagate_case: true
            word: true
          - trigger: "cumba"
            replace: "cumbá"
            propagate_case: true
            word: true
          - trigger: "cumel"
            replace: "cúmel"
            propagate_case: true
            word: true
          - trigger: "cumis"
            replace: "cúmis"
            propagate_case: true
            word: true
          - trigger: "cumpo"
            replace: "cumpô"
            propagate_case: true
            word: true
          - trigger: "cuneo"
            replace: "cúneo"
            propagate_case: true
            word: true
          - trigger: "cunha"
            replace: "cunhã"
            propagate_case: true
            word: true
          - trigger: "cunia"
            replace: "cúnia"
            propagate_case: true
            word: true
          - trigger: "cupai"
            replace: "cupaí"
            propagate_case: true
            word: true
          - trigger: "cupao"
            replace: "cupão"
            propagate_case: true
            word: true
          - trigger: "curao"
            replace: "curão"
            propagate_case: true
            word: true
          - trigger: "curia"
            replace: "cúria"
            propagate_case: true
            word: true
          - trigger: "curio"
            replace: "curió"
            propagate_case: true
            word: true
          - trigger: "curua"
            replace: "curuá"
            propagate_case: true
            word: true
          - trigger: "cutao"
            replace: "cutão"
            propagate_case: true
            word: true
          - trigger: "cuter"
            replace: "cúter"
            propagate_case: true
            word: true
          - trigger: "cutis"
            replace: "cútis"
            propagate_case: true
            word: true
          - trigger: "cuxiu"
            replace: "cuxiú"
            propagate_case: true
            word: true
          - trigger: "dacao"
            replace: "dação"
            propagate_case: true
            word: true
          - trigger: "dacia"
            replace: "dácia"
            propagate_case: true
            word: true
          - trigger: "dacio"
            replace: "dácio"
            propagate_case: true
            word: true
          - trigger: "dadra"
            replace: "dadrá"
            propagate_case: true
            word: true
          - trigger: "daiza"
            replace: "daíza"
            propagate_case: true
            word: true
          - trigger: "dalem"
            replace: "dalém"
            propagate_case: true
            word: true
          - trigger: "damao"
            replace: "damão"
            propagate_case: true
            word: true
          - trigger: "damar"
            replace: "dâmar"
            propagate_case: true
            word: true
          - trigger: "dandi"
            replace: "dândi"
            propagate_case: true
            word: true
          - trigger: "danes"
            replace: "danês"
            propagate_case: true
            word: true
          - trigger: "daome"
            replace: "daomê"
            propagate_case: true
            word: true
          - trigger: "datil"
            replace: "dátil"
            propagate_case: true
            word: true
          - trigger: "debil"
            replace: "débil"
            propagate_case: true
            word: true
          - trigger: "decio"
            replace: "décio"
            propagate_case: true
            word: true
          - trigger: "dedao"
            replace: "dedão"
            propagate_case: true
            word: true
          - trigger: "delio"
            replace: "délio"
            propagate_case: true
            word: true
          - trigger: "demao"
            replace: "demão"
            propagate_case: true
            word: true
          - trigger: "demia"
            replace: "dêmia"
            propagate_case: true
            word: true
          - trigger: "demos"
            replace: "dêmos"
            propagate_case: true
            word: true
          - trigger: "dende"
            replace: "dendê"
            propagate_case: true
            word: true
          - trigger: "derbi"
            replace: "dérbi"
            propagate_case: true
            word: true
          - trigger: "devio"
            replace: "dévio"
            propagate_case: true
            word: true
          - trigger: "dexia"
            replace: "déxia"
            propagate_case: true
            word: true
          - trigger: "diade"
            replace: "díade"
            propagate_case: true
            word: true
          - trigger: "dicao"
            replace: "dição"
            propagate_case: true
            word: true
          - trigger: "didea"
            replace: "dídea"
            propagate_case: true
            word: true
          - trigger: "didio"
            replace: "dídio"
            propagate_case: true
            word: true
          - trigger: "difia"
            replace: "dífia"
            propagate_case: true
            word: true
          - trigger: "dinie"
            replace: "dinié"
            propagate_case: true
            word: true
          - trigger: "dinio"
            replace: "dínio"
            propagate_case: true
            word: true
          - trigger: "dinis"
            replace: "dinís"
            propagate_case: true
            word: true
          - trigger: "diope"
            replace: "díope"
            propagate_case: true
            word: true
          - trigger: "direm"
            replace: "dirém"
            propagate_case: true
            word: true
          - trigger: "dirra"
            replace: "dirrã"
            propagate_case: true
            word: true
          - trigger: "disel"
            replace: "dísel"
            propagate_case: true
            word: true
          - trigger: "disse"
            replace: "dissê"
            propagate_case: true
            word: true
          - trigger: "disue"
            replace: "disué"
            propagate_case: true
            word: true
          - trigger: "diula"
            replace: "diúla"
            propagate_case: true
            word: true
          - trigger: "diuso"
            replace: "diúso"
            propagate_case: true
            word: true
          - trigger: "diuta"
            replace: "diúta"
            propagate_case: true
            word: true
          - trigger: "divao"
            replace: "divão"
            propagate_case: true
            word: true
          - trigger: "dixis"
            replace: "díxis"
            propagate_case: true
            word: true
          - trigger: "docal"
            replace: "doçal"
            propagate_case: true
            word: true
          - trigger: "docar"
            replace: "doçar"
            propagate_case: true
            word: true
          - trigger: "docem"
            replace: "docém"
            propagate_case: true
            word: true
          - trigger: "docil"
            replace: "dócil"
            propagate_case: true
            word: true
          - trigger: "dodoi"
            replace: "dodói"
            propagate_case: true
            word: true
          - trigger: "dolar"
            replace: "dólar"
            propagate_case: true
            word: true
          - trigger: "dolio"
            replace: "dólio"
            propagate_case: true
            word: true
          - trigger: "dolma"
            replace: "dólmã"
            propagate_case: true
            word: true
          - trigger: "donax"
            replace: "dônax"
            propagate_case: true
            word: true
          - trigger: "donia"
            replace: "dônia"
            propagate_case: true
            word: true
          - trigger: "dorea"
            replace: "dórea"
            propagate_case: true
            word: true
          - trigger: "doria"
            replace: "doriá"
            propagate_case: true
            word: true
          - trigger: "dorio"
            replace: "dório"
            propagate_case: true
            word: true
          - trigger: "doulo"
            replace: "douló"
            propagate_case: true
            word: true
          - trigger: "dozao"
            replace: "dozão"
            propagate_case: true
            word: true
          - trigger: "drica"
            replace: "driça"
            propagate_case: true
            word: true
          - trigger: "dualo"
            replace: "dualó"
            propagate_case: true
            word: true
          - trigger: "dubio"
            replace: "dúbio"
            propagate_case: true
            word: true
          - trigger: "duble"
            replace: "dublê"
            propagate_case: true
            word: true
          - trigger: "ducra"
            replace: "ducrá"
            propagate_case: true
            word: true
          - trigger: "dueca"
            replace: "dueça"
            propagate_case: true
            word: true
          - trigger: "duere"
            replace: "dueré"
            propagate_case: true
            word: true
          - trigger: "dugao"
            replace: "dugão"
            propagate_case: true
            word: true
          - trigger: "duila"
            replace: "duíla"
            propagate_case: true
            word: true
          - trigger: "duita"
            replace: "duíta"
            propagate_case: true
            word: true
          - trigger: "dungo"
            replace: "dungô"
            propagate_case: true
            word: true
          - trigger: "durao"
            replace: "durão"
            propagate_case: true
            word: true
          - trigger: "durga"
            replace: "durgá"
            propagate_case: true
            word: true
          - trigger: "durio"
            replace: "dúrio"
            propagate_case: true
            word: true
          - trigger: "dutis"
            replace: "dútis"
            propagate_case: true
            word: true
          - trigger: "dutro"
            replace: "dutró"
            propagate_case: true
            word: true
          - trigger: "duzia"
            replace: "dúzia"
            propagate_case: true
            word: true
          - trigger: "earia"
            replace: "eária"
            propagate_case: true
            word: true
          - trigger: "ebano"
            replace: "ébano"
            propagate_case: true
            word: true
          - trigger: "ebeno"
            replace: "ébeno"
            propagate_case: true
            word: true
          - trigger: "eblis"
            replace: "éblis"
            propagate_case: true
            word: true
          - trigger: "ebrio"
            replace: "ébrio"
            propagate_case: true
            word: true
          - trigger: "ebulo"
            replace: "ébulo"
            propagate_case: true
            word: true
          - trigger: "ecano"
            replace: "écano"
            propagate_case: true
            word: true
          - trigger: "ecico"
            replace: "écico"
            propagate_case: true
            word: true
          - trigger: "ecope"
            replace: "écope"
            propagate_case: true
            word: true
          - trigger: "eculo"
            replace: "éculo"
            propagate_case: true
            word: true
          - trigger: "edalo"
            replace: "édalo"
            propagate_case: true
            word: true
          - trigger: "edere"
            replace: "ederé"
            propagate_case: true
            word: true
          - trigger: "edico"
            replace: "édico"
            propagate_case: true
            word: true
          - trigger: "edina"
            replace: "édina"
            propagate_case: true
            word: true
          - trigger: "edipo"
            replace: "édipo"
            propagate_case: true
            word: true
          - trigger: "edito"
            replace: "édito"
            propagate_case: true
            word: true
          - trigger: "ednie"
            replace: "édnie"
            propagate_case: true
            word: true
          - trigger: "efata"
            replace: "efatá"
            propagate_case: true
            word: true
          - trigger: "efeso"
            replace: "éfeso"
            propagate_case: true
            word: true
          - trigger: "efeta"
            replace: "éfeta"
            propagate_case: true
            word: true
          - trigger: "efiro"
            replace: "éfiro"
            propagate_case: true
            word: true
          - trigger: "efode"
            replace: "éfode"
            propagate_case: true
            word: true
          - trigger: "efodo"
            replace: "éfodo"
            propagate_case: true
            word: true
          - trigger: "eforo"
            replace: "éforo"
            propagate_case: true
            word: true
          - trigger: "egeao"
            replace: "egeão"
            propagate_case: true
            word: true
          - trigger: "egide"
            replace: "égide"
            propagate_case: true
            word: true
          - trigger: "egipa"
            replace: "egipã"
            propagate_case: true
            word: true
          - trigger: "egrio"
            replace: "égrio"
            propagate_case: true
            word: true
          - trigger: "eguem"
            replace: "éguem"
            propagate_case: true
            word: true
          - trigger: "eicar"
            replace: "eiçar"
            propagate_case: true
            word: true
          - trigger: "eicho"
            replace: "eichó"
            propagate_case: true
            word: true
          - trigger: "eider"
            replace: "êider"
            propagate_case: true
            word: true
          - trigger: "eivao"
            replace: "eivão"
            propagate_case: true
            word: true
          - trigger: "elafa"
            replace: "elafá"
            propagate_case: true
            word: true
          - trigger: "elafo"
            replace: "élafo"
            propagate_case: true
            word: true
          - trigger: "elbio"
            replace: "élbio"
            propagate_case: true
            word: true
          - trigger: "elcio"
            replace: "élcio"
            propagate_case: true
            word: true
          - trigger: "elder"
            replace: "élder"
            propagate_case: true
            word: true
          - trigger: "elebo"
            replace: "elebó"
            propagate_case: true
            word: true
          - trigger: "eleda"
            replace: "eledá"
            propagate_case: true
            word: true
          - trigger: "elede"
            replace: "eledê"
            propagate_case: true
            word: true
          - trigger: "elege"
            replace: "élege"
            propagate_case: true
            word: true
          - trigger: "eleis"
            replace: "eléis"
            propagate_case: true
            word: true
          - trigger: "elepe"
            replace: "elepê"
            propagate_case: true
            word: true
          - trigger: "elico"
            replace: "élico"
            propagate_case: true
            word: true
          - trigger: "elimo"
            replace: "élimo"
            propagate_case: true
            word: true
          - trigger: "elmer"
            replace: "élmer"
            propagate_case: true
            word: true
          - trigger: "elson"
            replace: "élson"
            propagate_case: true
            word: true
          - trigger: "elton"
            replace: "élton"
            propagate_case: true
            word: true
          - trigger: "elvia"
            replace: "élvia"
            propagate_case: true
            word: true
          - trigger: "elvis"
            replace: "élvis"
            propagate_case: true
            word: true
          - trigger: "embia"
            replace: "embiá"
            propagate_case: true
            word: true
          - trigger: "embiu"
            replace: "embiú"
            propagate_case: true
            word: true
          - trigger: "emboa"
            replace: "emboá"
            propagate_case: true
            word: true
          - trigger: "embua"
            replace: "embuá"
            propagate_case: true
            word: true
          - trigger: "embui"
            replace: "embuí"
            propagate_case: true
            word: true
          - trigger: "emebe"
            replace: "emebé"
            propagate_case: true
            word: true
          - trigger: "emero"
            replace: "êmero"
            propagate_case: true
            word: true
          - trigger: "emese"
            replace: "êmese"
            propagate_case: true
            word: true
          - trigger: "emico"
            replace: "êmico"
            propagate_case: true
            word: true
          - trigger: "emide"
            replace: "êmide"
            propagate_case: true
            word: true
          - trigger: "emile"
            replace: "émile"
            propagate_case: true
            word: true
          - trigger: "empos"
            replace: "empós"
            propagate_case: true
            word: true
          - trigger: "emulo"
            replace: "émulo"
            propagate_case: true
            word: true
          - trigger: "encho"
            replace: "enchó"
            propagate_case: true
            word: true
          - trigger: "eneas"
            replace: "enéas"
            propagate_case: true
            word: true
          - trigger: "eneus"
            replace: "enéus"
            propagate_case: true
            word: true
          - trigger: "enico"
            replace: "ênico"
            propagate_case: true
            word: true
          - trigger: "ensis"
            replace: "ênsis"
            propagate_case: true
            word: true
          - trigger: "entao"
            replace: "então"
            propagate_case: true
            word: true
          - trigger: "enula"
            replace: "énula"
            propagate_case: true
            word: true
          - trigger: "enves"
            replace: "envés"
            propagate_case: true
            word: true
          - trigger: "enxui"
            replace: "enxuí"
            propagate_case: true
            word: true
          - trigger: "eoipo"
            replace: "eoípo"
            propagate_case: true
            word: true
          - trigger: "eolio"
            replace: "eólio"
            propagate_case: true
            word: true
          - trigger: "epico"
            replace: "épico"
            propagate_case: true
            word: true
          - trigger: "epiro"
            replace: "épiro"
            propagate_case: true
            word: true
          - trigger: "epoca"
            replace: "época"
            propagate_case: true
            word: true
          - trigger: "epoxi"
            replace: "epóxi"
            propagate_case: true
            word: true
          - trigger: "epula"
            replace: "épula"
            propagate_case: true
            word: true
          - trigger: "epura"
            replace: "épura"
            propagate_case: true
            word: true
          - trigger: "equio"
            replace: "équio"
            propagate_case: true
            word: true
          - trigger: "equis"
            replace: "équis"
            propagate_case: true
            word: true
          - trigger: "erano"
            replace: "érano"
            propagate_case: true
            word: true
          - trigger: "erbio"
            replace: "érbio"
            propagate_case: true
            word: true
          - trigger: "erebo"
            replace: "érebo"
            propagate_case: true
            word: true
          - trigger: "ereis"
            replace: "éreis"
            propagate_case: true
            word: true
          - trigger: "erere"
            replace: "ererê"
            propagate_case: true
            word: true
          - trigger: "ergio"
            replace: "érgio"
            propagate_case: true
            word: true
          - trigger: "erice"
            replace: "érice"
            propagate_case: true
            word: true
          - trigger: "erico"
            replace: "érico"
            propagate_case: true
            word: true
          - trigger: "erina"
            replace: "érina"
            propagate_case: true
            word: true
          - trigger: "erion"
            replace: "érion"
            propagate_case: true
            word: true
          - trigger: "erone"
            replace: "érone"
            propagate_case: true
            word: true
          - trigger: "esere"
            replace: "eserê"
            propagate_case: true
            word: true
          - trigger: "esimo"
            replace: "ésimo"
            propagate_case: true
            word: true
          - trigger: "esipo"
            replace: "ésipo"
            propagate_case: true
            word: true
          - trigger: "esoce"
            replace: "ésoce"
            propagate_case: true
            word: true
          - trigger: "essuo"
            replace: "éssuo"
            propagate_case: true
            word: true
          - trigger: "esula"
            replace: "ésula"
            propagate_case: true
            word: true
          - trigger: "esvao"
            replace: "esvão"
            propagate_case: true
            word: true
          - trigger: "etego"
            replace: "étego"
            propagate_case: true
            word: true
          - trigger: "etico"
            replace: "ético"
            propagate_case: true
            word: true
          - trigger: "etigo"
            replace: "étigo"
            propagate_case: true
            word: true
          - trigger: "etimo"
            replace: "étimo"
            propagate_case: true
            word: true
          - trigger: "etipe"
            replace: "etípe"
            propagate_case: true
            word: true
          - trigger: "eubio"
            replace: "êubio"
            propagate_case: true
            word: true
          - trigger: "eudia"
            replace: "êudia"
            propagate_case: true
            word: true
          - trigger: "euria"
            replace: "êuria"
            propagate_case: true
            word: true
          - trigger: "evano"
            replace: "évano"
            propagate_case: true
            word: true
          - trigger: "evase"
            replace: "evasé"
            propagate_case: true
            word: true
          - trigger: "evodo"
            replace: "évodo"
            propagate_case: true
            word: true
          - trigger: "evora"
            replace: "évora"
            propagate_case: true
            word: true
          - trigger: "exaco"
            replace: "êxaco"
            propagate_case: true
            word: true
          - trigger: "exito"
            replace: "êxito"
            propagate_case: true
            word: true
          - trigger: "exodo"
            replace: "êxodo"
            propagate_case: true
            word: true
          - trigger: "exule"
            replace: "êxule"
            propagate_case: true
            word: true
          - trigger: "faber"
            replace: "fáber"
            propagate_case: true
            word: true
          - trigger: "fabio"
            replace: "fábio"
            propagate_case: true
            word: true
          - trigger: "facao"
            replace: "fação"
            propagate_case: true
            word: true
          - trigger: "facil"
            replace: "fácil"
            propagate_case: true
            word: true
          - trigger: "fadia"
            replace: "fadiá"
            propagate_case: true
            word: true
          - trigger: "fagea"
            replace: "fágea"
            propagate_case: true
            word: true
          - trigger: "faiao"
            replace: "faião"
            propagate_case: true
            word: true
          - trigger: "fajea"
            replace: "fájea"
            propagate_case: true
            word: true
          - trigger: "falum"
            replace: "fálum"
            propagate_case: true
            word: true
          - trigger: "falus"
            replace: "fálus"
            propagate_case: true
            word: true
          - trigger: "fanao"
            replace: "fanão"
            propagate_case: true
            word: true
          - trigger: "fanfa"
            replace: "fanfã"
            propagate_case: true
            word: true
          - trigger: "fanio"
            replace: "fânio"
            propagate_case: true
            word: true
          - trigger: "fanta"
            replace: "fantã"
            propagate_case: true
            word: true
          - trigger: "fanti"
            replace: "fânti"
            propagate_case: true
            word: true
          - trigger: "farao"
            replace: "faraó"
            propagate_case: true
            word: true
          - trigger: "farfa"
            replace: "farfã"
            propagate_case: true
            word: true
          - trigger: "fario"
            replace: "fário"
            propagate_case: true
            word: true
          - trigger: "fasia"
            replace: "fásia"
            propagate_case: true
            word: true
          - trigger: "fatao"
            replace: "fatão"
            propagate_case: true
            word: true
          - trigger: "fatuo"
            replace: "fátuo"
            propagate_case: true
            word: true
          - trigger: "faula"
            replace: "faúla"
            propagate_case: true
            word: true
          - trigger: "favao"
            replace: "favão"
            propagate_case: true
            word: true
          - trigger: "favio"
            replace: "fávio"
            propagate_case: true
            word: true
          - trigger: "feiao"
            replace: "feião"
            propagate_case: true
            word: true
          - trigger: "feijo"
            replace: "feijó"
            propagate_case: true
            word: true
          - trigger: "feleo"
            replace: "féleo"
            propagate_case: true
            word: true
          - trigger: "feleu"
            replace: "feléu"
            propagate_case: true
            word: true
          - trigger: "felix"
            replace: "félix"
            propagate_case: true
            word: true
          - trigger: "femeo"
            replace: "fêmeo"
            propagate_case: true
            word: true
          - trigger: "femur"
            replace: "fêmur"
            propagate_case: true
            word: true
          - trigger: "fenix"
            replace: "fênix"
            propagate_case: true
            word: true
          - trigger: "feofo"
            replace: "feofó"
            propagate_case: true
            word: true
          - trigger: "feria"
            replace: "féria"
            propagate_case: true
            word: true
          - trigger: "fetao"
            replace: "fêtão"
            propagate_case: true
            word: true
          - trigger: "fiaco"
            replace: "fiaço"
            propagate_case: true
            word: true
          - trigger: "fiala"
            replace: "fíala"
            propagate_case: true
            word: true
          - trigger: "fiber"
            replace: "fíber"
            propagate_case: true
            word: true
          - trigger: "ficao"
            replace: "ficão"
            propagate_case: true
            word: true
          - trigger: "ficeo"
            replace: "fíceo"
            propagate_case: true
            word: true
          - trigger: "ficis"
            replace: "fícis"
            propagate_case: true
            word: true
          - trigger: "ficus"
            replace: "fícus"
            propagate_case: true
            word: true
          - trigger: "fideu"
            replace: "fidéu"
            propagate_case: true
            word: true
          - trigger: "fidia"
            replace: "fídia"
            propagate_case: true
            word: true
          - trigger: "fifia"
            replace: "fífia"
            propagate_case: true
            word: true
          - trigger: "filao"
            replace: "filão"
            propagate_case: true
            word: true
          - trigger: "fileo"
            replace: "fíleo"
            propagate_case: true
            word: true
          - trigger: "filer"
            replace: "fíler"
            propagate_case: true
            word: true
          - trigger: "filho"
            replace: "filhó"
            propagate_case: true
            word: true
          - trigger: "fines"
            replace: "finês"
            propagate_case: true
            word: true
          - trigger: "fiofo"
            replace: "fiofó"
            propagate_case: true
            word: true
          - trigger: "firma"
            replace: "firmã"
            propagate_case: true
            word: true
          - trigger: "fitao"
            replace: "fitão"
            propagate_case: true
            word: true
          - trigger: "fiusa"
            replace: "fiúsa"
            propagate_case: true
            word: true
          - trigger: "fiuzo"
            replace: "fiúzo"
            propagate_case: true
            word: true
          - trigger: "flozo"
            replace: "flozô"
            propagate_case: true
            word: true
          - trigger: "fluor"
            replace: "flúor"
            propagate_case: true
            word: true
          - trigger: "focao"
            replace: "foção"
            propagate_case: true
            word: true
          - trigger: "focio"
            replace: "fócio"
            propagate_case: true
            word: true
          - trigger: "fodia"
            replace: "fódia"
            propagate_case: true
            word: true
          - trigger: "fogao"
            replace: "fogão"
            propagate_case: true
            word: true
          - trigger: "folao"
            replace: "folão"
            propagate_case: true
            word: true
          - trigger: "folio"
            replace: "fólio"
            propagate_case: true
            word: true
          - trigger: "folis"
            replace: "fólis"
            propagate_case: true
            word: true
          - trigger: "foloe"
            replace: "fóloe"
            propagate_case: true
            word: true
          - trigger: "fonao"
            replace: "fonão"
            propagate_case: true
            word: true
          - trigger: "fonix"
            replace: "fônix"
            propagate_case: true
            word: true
          - trigger: "fonon"
            replace: "fônon"
            propagate_case: true
            word: true
          - trigger: "forro"
            replace: "forró"
            propagate_case: true
            word: true
          - trigger: "forum"
            replace: "fórum"
            propagate_case: true
            word: true
          - trigger: "fotao"
            replace: "fotão"
            propagate_case: true
            word: true
          - trigger: "foton"
            replace: "fóton"
            propagate_case: true
            word: true
          - trigger: "fovea"
            replace: "fóvea"
            propagate_case: true
            word: true
          - trigger: "frape"
            replace: "frapê"
            propagate_case: true
            word: true
          - trigger: "frois"
            replace: "fróis"
            propagate_case: true
            word: true
          - trigger: "frozo"
            replace: "frozô"
            propagate_case: true
            word: true
          - trigger: "fucar"
            replace: "fuçar"
            propagate_case: true
            word: true
          - trigger: "fucea"
            replace: "fúcea"
            propagate_case: true
            word: true
          - trigger: "fucia"
            replace: "fúcia"
            propagate_case: true
            word: true
          - trigger: "fufio"
            replace: "fúfio"
            propagate_case: true
            word: true
          - trigger: "fugao"
            replace: "fugão"
            propagate_case: true
            word: true
          - trigger: "fujao"
            replace: "fujão"
            propagate_case: true
            word: true
          - trigger: "fulao"
            replace: "fulão"
            propagate_case: true
            word: true
          - trigger: "fuler"
            replace: "fúler"
            propagate_case: true
            word: true
          - trigger: "fulix"
            replace: "fúlix"
            propagate_case: true
            word: true
          - trigger: "fumao"
            replace: "fumão"
            propagate_case: true
            word: true
          - trigger: "fumeo"
            replace: "fúmeo"
            propagate_case: true
            word: true
          - trigger: "funeu"
            replace: "funéu"
            propagate_case: true
            word: true
          - trigger: "furao"
            replace: "furão"
            propagate_case: true
            word: true
          - trigger: "furia"
            replace: "fúria"
            propagate_case: true
            word: true
          - trigger: "fusao"
            replace: "fusão"
            propagate_case: true
            word: true
          - trigger: "fusel"
            replace: "fúsel"
            propagate_case: true
            word: true
          - trigger: "fusil"
            replace: "fúsil"
            propagate_case: true
            word: true
          - trigger: "futil"
            replace: "fútil"
            propagate_case: true
            word: true
          - trigger: "fuzue"
            replace: "fuzuê"
            propagate_case: true
            word: true
          - trigger: "gabao"
            replace: "gabão"
            propagate_case: true
            word: true
          - trigger: "gabeu"
            replace: "gabéu"
            propagate_case: true
            word: true
          - trigger: "gabio"
            replace: "gábio"
            propagate_case: true
            word: true
          - trigger: "gadao"
            replace: "gadão"
            propagate_case: true
            word: true
          - trigger: "gafem"
            replace: "gafém"
            propagate_case: true
            word: true
          - trigger: "gafio"
            replace: "gáfio"
            propagate_case: true
            word: true
          - trigger: "gagao"
            replace: "gagão"
            propagate_case: true
            word: true
          - trigger: "gajao"
            replace: "gajão"
            propagate_case: true
            word: true
          - trigger: "galao"
            replace: "galão"
            propagate_case: true
            word: true
          - trigger: "galax"
            replace: "gálax"
            propagate_case: true
            word: true
          - trigger: "galeo"
            replace: "gáleo"
            propagate_case: true
            word: true
          - trigger: "gales"
            replace: "galês"
            propagate_case: true
            word: true
          - trigger: "galio"
            replace: "gálio"
            propagate_case: true
            word: true
          - trigger: "gamao"
            replace: "gamão"
            propagate_case: true
            word: true
          - trigger: "gamba"
            replace: "gambá"
            propagate_case: true
            word: true
          - trigger: "gamia"
            replace: "gâmia"
            propagate_case: true
            word: true
          - trigger: "ganes"
            replace: "ganês"
            propagate_case: true
            word: true
          - trigger: "gania"
            replace: "gânia"
            propagate_case: true
            word: true
          - trigger: "ganto"
            replace: "gantó"
            propagate_case: true
            word: true
          - trigger: "ganze"
            replace: "ganzé"
            propagate_case: true
            word: true
          - trigger: "garao"
            replace: "garão"
            propagate_case: true
            word: true
          - trigger: "garco"
            replace: "garço"
            propagate_case: true
            word: true
          - trigger: "gargo"
            replace: "gargó"
            propagate_case: true
            word: true
          - trigger: "garoa"
            replace: "garôa"
            propagate_case: true
            word: true
          - trigger: "gaseo"
            replace: "gáseo"
            propagate_case: true
            word: true
          - trigger: "gatao"
            replace: "gatão"
            propagate_case: true
            word: true
          - trigger: "gaudo"
            replace: "gaudó"
            propagate_case: true
            word: true
          - trigger: "gavao"
            replace: "gavão"
            propagate_case: true
            word: true
          - trigger: "gavea"
            replace: "gávea"
            propagate_case: true
            word: true
          - trigger: "gazao"
            replace: "gazão"
            propagate_case: true
            word: true
          - trigger: "gazeo"
            replace: "gázeo"
            propagate_case: true
            word: true
          - trigger: "gazio"
            replace: "gázio"
            propagate_case: true
            word: true
          - trigger: "gebia"
            replace: "gébia"
            propagate_case: true
            word: true
          - trigger: "geina"
            replace: "geína"
            propagate_case: true
            word: true
          - trigger: "gelio"
            replace: "gélio"
            propagate_case: true
            word: true
          - trigger: "gelis"
            replace: "gélis"
            propagate_case: true
            word: true
          - trigger: "gemeo"
            replace: "gêmeo"
            propagate_case: true
            word: true
          - trigger: "genio"
            replace: "gênio"
            propagate_case: true
            word: true
          - trigger: "gerem"
            replace: "gerém"
            propagate_case: true
            word: true
          - trigger: "geres"
            replace: "gerês"
            propagate_case: true
            word: true
          - trigger: "gesio"
            replace: "gésio"
            propagate_case: true
            word: true
          - trigger: "gibao"
            replace: "gibão"
            propagate_case: true
            word: true
          - trigger: "gibea"
            replace: "gibeá"
            propagate_case: true
            word: true
          - trigger: "gibio"
            replace: "gíbio"
            propagate_case: true
            word: true
          - trigger: "gicle"
            replace: "giclê"
            propagate_case: true
            word: true
          - trigger: "giclo"
            replace: "gicló"
            propagate_case: true
            word: true
          - trigger: "gidio"
            replace: "gídio"
            propagate_case: true
            word: true
          - trigger: "gigia"
            replace: "gígia"
            propagate_case: true
            word: true
          - trigger: "gigis"
            replace: "gígis"
            propagate_case: true
            word: true
          - trigger: "gigle"
            replace: "giglê"
            propagate_case: true
            word: true
          - trigger: "gilia"
            replace: "gília"
            propagate_case: true
            word: true
          - trigger: "gimao"
            replace: "gimão"
            propagate_case: true
            word: true
          - trigger: "girao"
            replace: "girão"
            propagate_case: true
            word: true
          - trigger: "girio"
            replace: "gírio"
            propagate_case: true
            word: true
          - trigger: "girua"
            replace: "giruá"
            propagate_case: true
            word: true
          - trigger: "glace"
            replace: "glacé"
            propagate_case: true
            word: true
          - trigger: "gluao"
            replace: "gluão"
            propagate_case: true
            word: true
          - trigger: "gluon"
            replace: "glúon"
            propagate_case: true
            word: true
          - trigger: "gobio"
            replace: "góbio"
            propagate_case: true
            word: true
          - trigger: "godao"
            replace: "godão"
            propagate_case: true
            word: true
          - trigger: "godel"
            replace: "gödel"
            propagate_case: true
            word: true
          - trigger: "godia"
            replace: "gódia"
            propagate_case: true
            word: true
          - trigger: "godoi"
            replace: "godói"
            propagate_case: true
            word: true
          - trigger: "gombo"
            replace: "gombô"
            propagate_case: true
            word: true
          - trigger: "gongo"
            replace: "gongó"
            propagate_case: true
            word: true
          - trigger: "gonio"
            replace: "gônio"
            propagate_case: true
            word: true
          - trigger: "gonis"
            replace: "gônis"
            propagate_case: true
            word: true
          - trigger: "gorao"
            replace: "gorão"
            propagate_case: true
            word: true
          - trigger: "gotao"
            replace: "gotão"
            propagate_case: true
            word: true
          - trigger: "gozao"
            replace: "gozão"
            propagate_case: true
            word: true
          - trigger: "graca"
            replace: "graça"
            propagate_case: true
            word: true
          - trigger: "grena"
            replace: "grená"
            propagate_case: true
            word: true
          - trigger: "grise"
            replace: "grisê"
            propagate_case: true
            word: true
          - trigger: "grolo"
            replace: "groló"
            propagate_case: true
            word: true
          - trigger: "guaca"
            replace: "guacá"
            propagate_case: true
            word: true
          - trigger: "guacu"
            replace: "guaçu"
            propagate_case: true
            word: true
          - trigger: "guaio"
            replace: "guaió"
            propagate_case: true
            word: true
          - trigger: "guaiu"
            replace: "guaiú"
            propagate_case: true
            word: true
          - trigger: "guaja"
            replace: "guajá"
            propagate_case: true
            word: true
          - trigger: "guama"
            replace: "guamá"
            propagate_case: true
            word: true
          - trigger: "guana"
            replace: "guaná"
            propagate_case: true
            word: true
          - trigger: "guape"
            replace: "guapé"
            propagate_case: true
            word: true
          - trigger: "guara"
            replace: "guará"
            propagate_case: true
            word: true
          - trigger: "guato"
            replace: "guató"
            propagate_case: true
            word: true
          - trigger: "guiao"
            replace: "guião"
            propagate_case: true
            word: true
          - trigger: "guiba"
            replace: "guibá"
            propagate_case: true
            word: true
          - trigger: "guine"
            replace: "guiné"
            propagate_case: true
            word: true
          - trigger: "guipa"
            replace: "guipá"
            propagate_case: true
            word: true
          - trigger: "gulue"
            replace: "gúlue"
            propagate_case: true
            word: true
          - trigger: "gumbe"
            replace: "gumbé"
            propagate_case: true
            word: true
          - trigger: "gunto"
            replace: "guntó"
            propagate_case: true
            word: true
          - trigger: "habia"
            replace: "hábia"
            propagate_case: true
            word: true
          - trigger: "habil"
            replace: "hábil"
            propagate_case: true
            word: true
          - trigger: "haden"
            replace: "háden"
            propagate_case: true
            word: true
          - trigger: "haide"
            replace: "haidê"
            propagate_case: true
            word: true
          - trigger: "halex"
            replace: "hálex"
            propagate_case: true
            word: true
          - trigger: "halia"
            replace: "hália"
            propagate_case: true
            word: true
          - trigger: "halis"
            replace: "hális"
            propagate_case: true
            word: true
          - trigger: "halux"
            replace: "hálux"
            propagate_case: true
            word: true
          - trigger: "halva"
            replace: "halvá"
            propagate_case: true
            word: true
          - trigger: "hanio"
            replace: "hânio"
            propagate_case: true
            word: true
          - trigger: "hanoi"
            replace: "hanói"
            propagate_case: true
            word: true
          - trigger: "hapax"
            replace: "hápax"
            propagate_case: true
            word: true
          - trigger: "harao"
            replace: "harão"
            propagate_case: true
            word: true
          - trigger: "harem"
            replace: "harém"
            propagate_case: true
            word: true
          - trigger: "haroe"
            replace: "haroé"
            propagate_case: true
            word: true
          - trigger: "hauca"
            replace: "hauçá"
            propagate_case: true
            word: true
          - trigger: "haura"
            replace: "haurã"
            propagate_case: true
            word: true
          - trigger: "havai"
            replace: "havaí"
            propagate_case: true
            word: true
          - trigger: "heber"
            replace: "hêber"
            propagate_case: true
            word: true
          - trigger: "hedia"
            replace: "hédia"
            propagate_case: true
            word: true
          - trigger: "heduo"
            replace: "héduo"
            propagate_case: true
            word: true
          - trigger: "helem"
            replace: "helém"
            propagate_case: true
            word: true
          - trigger: "helio"
            replace: "hélio"
            propagate_case: true
            word: true
          - trigger: "helix"
            replace: "hélix"
            propagate_case: true
            word: true
          - trigger: "henda"
            replace: "hendã"
            propagate_case: true
            word: true
          - trigger: "henos"
            replace: "henós"
            propagate_case: true
            word: true
          - trigger: "hepia"
            replace: "hépia"
            propagate_case: true
            word: true
          - trigger: "hereu"
            replace: "heréu"
            propagate_case: true
            word: true
          - trigger: "heroi"
            replace: "herói"
            propagate_case: true
            word: true
          - trigger: "hetma"
            replace: "hetmã"
            propagate_case: true
            word: true
          - trigger: "hevea"
            replace: "hévea"
            propagate_case: true
            word: true
          - trigger: "hiala"
            replace: "híala"
            propagate_case: true
            word: true
          - trigger: "hifen"
            replace: "hífen"
            propagate_case: true
            word: true
          - trigger: "hilem"
            replace: "hilém"
            propagate_case: true
            word: true
          - trigger: "hilia"
            replace: "hília"
            propagate_case: true
            word: true
          - trigger: "himen"
            replace: "hímen"
            propagate_case: true
            word: true
          - trigger: "hirao"
            replace: "hirão"
            propagate_case: true
            word: true
          - trigger: "hirax"
            replace: "hírax"
            propagate_case: true
            word: true
          - trigger: "hiria"
            replace: "híria"
            propagate_case: true
            word: true
          - trigger: "holao"
            replace: "holão"
            propagate_case: true
            word: true
          - trigger: "homao"
            replace: "homão"
            propagate_case: true
            word: true
          - trigger: "hopea"
            replace: "hópea"
            propagate_case: true
            word: true
          - trigger: "hopia"
            replace: "hópia"
            propagate_case: true
            word: true
          - trigger: "horao"
            replace: "horão"
            propagate_case: true
            word: true
          - trigger: "horem"
            replace: "horém"
            propagate_case: true
            word: true
          - trigger: "horma"
            replace: "hormá"
            propagate_case: true
            word: true
          - trigger: "horra"
            replace: "horrá"
            propagate_case: true
            word: true
          - trigger: "hossi"
            replace: "hóssi"
            propagate_case: true
            word: true
          - trigger: "hotao"
            replace: "hotão"
            propagate_case: true
            word: true
          - trigger: "hovea"
            replace: "hóvea"
            propagate_case: true
            word: true
          - trigger: "huama"
            replace: "huamã"
            propagate_case: true
            word: true
          - trigger: "huila"
            replace: "huíla"
            propagate_case: true
            word: true
          - trigger: "humea"
            replace: "húmea"
            propagate_case: true
            word: true
          - trigger: "humil"
            replace: "húmil"
            propagate_case: true
            word: true
          - trigger: "humus"
            replace: "húmus"
            propagate_case: true
            word: true
          - trigger: "hurao"
            replace: "hurão"
            propagate_case: true
            word: true
          - trigger: "husao"
            replace: "husão"
            propagate_case: true
            word: true
          - trigger: "iacio"
            replace: "iácio"
            propagate_case: true
            word: true
          - trigger: "iagua"
            replace: "iaguá"
            propagate_case: true
            word: true
          - trigger: "iamem"
            replace: "iamém"
            propagate_case: true
            word: true
          - trigger: "iameu"
            replace: "iaméu"
            propagate_case: true
            word: true
          - trigger: "iamos"
            replace: "íamos"
            propagate_case: true
            word: true
          - trigger: "iansa"
            replace: "iansã"
            propagate_case: true
            word: true
          - trigger: "iasio"
            replace: "iásio"
            propagate_case: true
            word: true
          - trigger: "iasis"
            replace: "iásis"
            propagate_case: true
            word: true
          - trigger: "iatai"
            replace: "iataí"
            propagate_case: true
            word: true
          - trigger: "iatio"
            replace: "iátio"
            propagate_case: true
            word: true
          - trigger: "iauvo"
            replace: "iaúvo"
            propagate_case: true
            word: true
          - trigger: "ibale"
            replace: "ibalé"
            propagate_case: true
            word: true
          - trigger: "ibaro"
            replace: "ibaró"
            propagate_case: true
            word: true
          - trigger: "ibate"
            replace: "ibaté"
            propagate_case: true
            word: true
          - trigger: "ibiai"
            replace: "ibiaí"
            propagate_case: true
            word: true
          - trigger: "ibice"
            replace: "íbice"
            propagate_case: true
            word: true
          - trigger: "ibiro"
            replace: "ibiró"
            propagate_case: true
            word: true
          - trigger: "iblea"
            replace: "ibleã"
            propagate_case: true
            word: true
          - trigger: "ibsao"
            replace: "ibsão"
            propagate_case: true
            word: true
          - trigger: "icacu"
            replace: "icaçu"
            propagate_case: true
            word: true
          - trigger: "icaro"
            replace: "ícaro"
            propagate_case: true
            word: true
          - trigger: "ichao"
            replace: "ichão"
            propagate_case: true
            word: true
          - trigger: "icipo"
            replace: "icipó"
            propagate_case: true
            word: true
          - trigger: "icone"
            replace: "ícone"
            propagate_case: true
            word: true
          - trigger: "icono"
            replace: "ícono"
            propagate_case: true
            word: true
          - trigger: "icore"
            replace: "ícore"
            propagate_case: true
            word: true
          - trigger: "ictis"
            replace: "íctis"
            propagate_case: true
            word: true
          - trigger: "ictus"
            replace: "íctus"
            propagate_case: true
            word: true
          - trigger: "icure"
            replace: "icurê"
            propagate_case: true
            word: true
          - trigger: "idolo"
            replace: "ídolo"
            propagate_case: true
            word: true
          - trigger: "iemen"
            replace: "iêmen"
            propagate_case: true
            word: true
          - trigger: "igape"
            replace: "igapé"
            propagate_case: true
            word: true
          - trigger: "igapo"
            replace: "igapó"
            propagate_case: true
            word: true
          - trigger: "igneo"
            replace: "ígneo"
            propagate_case: true
            word: true
          - trigger: "iguai"
            replace: "iguaí"
            propagate_case: true
            word: true
          - trigger: "iguem"
            replace: "íguem"
            propagate_case: true
            word: true
          - trigger: "igupa"
            replace: "igupá"
            propagate_case: true
            word: true
          - trigger: "iiaba"
            replace: "iiabá"
            propagate_case: true
            word: true
          - trigger: "iicai"
            replace: "iicaí"
            propagate_case: true
            word: true
          - trigger: "iinxe"
            replace: "iinxé"
            propagate_case: true
            word: true
          - trigger: "ijexa"
            replace: "ijexá"
            propagate_case: true
            word: true
          - trigger: "ilais"
            replace: "ilaís"
            propagate_case: true
            word: true
          - trigger: "ileon"
            replace: "íleon"
            propagate_case: true
            word: true
          - trigger: "ileus"
            replace: "íleus"
            propagate_case: true
            word: true
          - trigger: "ilheu"
            replace: "ilhéu"
            propagate_case: true
            word: true
          - trigger: "ilice"
            replace: "ílice"
            propagate_case: true
            word: true
          - trigger: "ilion"
            replace: "ílion"
            propagate_case: true
            word: true
          - trigger: "ilipe"
            replace: "ilipé"
            propagate_case: true
            word: true
          - trigger: "ilson"
            replace: "ílson"
            propagate_case: true
            word: true
          - trigger: "ilton"
            replace: "ílton"
            propagate_case: true
            word: true
          - trigger: "imbau"
            replace: "imbaú"
            propagate_case: true
            word: true
          - trigger: "imboa"
            replace: "imboá"
            propagate_case: true
            word: true
          - trigger: "inaco"
            replace: "ínaco"
            propagate_case: true
            word: true
          - trigger: "inare"
            replace: "inaré"
            propagate_case: true
            word: true
          - trigger: "incar"
            replace: "inçar"
            propagate_case: true
            word: true
          - trigger: "incho"
            replace: "inchó"
            propagate_case: true
            word: true
          - trigger: "index"
            replace: "índex"
            propagate_case: true
            word: true
          - trigger: "india"
            replace: "índia"
            propagate_case: true
            word: true
          - trigger: "indio"
            replace: "índio"
            propagate_case: true
            word: true
          - trigger: "indri"
            replace: "índri"
            propagate_case: true
            word: true
          - trigger: "indua"
            replace: "índua"
            propagate_case: true
            word: true
          - trigger: "ingai"
            replace: "ingaí"
            propagate_case: true
            word: true
          - trigger: "ingea"
            replace: "íngea"
            propagate_case: true
            word: true
          - trigger: "ingua"
            replace: "íngua"
            propagate_case: true
            word: true
          - trigger: "ingue"
            replace: "ingué"
            propagate_case: true
            word: true
          - trigger: "inhua"
            replace: "inhuã"
            propagate_case: true
            word: true
          - trigger: "inion"
            replace: "ínion"
            propagate_case: true
            word: true
          - trigger: "inope"
            replace: "ínope"
            propagate_case: true
            word: true
          - trigger: "insua"
            replace: "ínsua"
            propagate_case: true
            word: true
          - trigger: "inubo"
            replace: "ínubo"
            propagate_case: true
            word: true
          - trigger: "inula"
            replace: "ínula"
            propagate_case: true
            word: true
          - trigger: "inves"
            replace: "invés"
            propagate_case: true
            word: true
          - trigger: "invio"
            replace: "ínvio"
            propagate_case: true
            word: true
          - trigger: "iodis"
            replace: "iódis"
            propagate_case: true
            word: true
          - trigger: "ionio"
            replace: "iônio"
            propagate_case: true
            word: true
          - trigger: "iotio"
            replace: "iótio"
            propagate_case: true
            word: true
          - trigger: "ipacu"
            replace: "ipaçu"
            propagate_case: true
            word: true
          - trigger: "ipero"
            replace: "iperó"
            propagate_case: true
            word: true
          - trigger: "ipete"
            replace: "ipetê"
            propagate_case: true
            word: true
          - trigger: "ipeui"
            replace: "ipeuí"
            propagate_case: true
            word: true
          - trigger: "ipiau"
            replace: "ipiaú"
            propagate_case: true
            word: true
          - trigger: "ipida"
            replace: "ípida"
            propagate_case: true
            word: true
          - trigger: "ipora"
            replace: "iporã"
            propagate_case: true
            word: true
          - trigger: "iracu"
            replace: "iraçu"
            propagate_case: true
            word: true
          - trigger: "iraja"
            replace: "irajá"
            propagate_case: true
            word: true
          - trigger: "irece"
            replace: "irecê"
            propagate_case: true
            word: true
          - trigger: "irere"
            replace: "irerê"
            propagate_case: true
            word: true
          - trigger: "irira"
            replace: "irirá"
            propagate_case: true
            word: true
          - trigger: "irmao"
            replace: "irmão"
            propagate_case: true
            word: true
          - trigger: "irpex"
            replace: "írpex"
            propagate_case: true
            word: true
          - trigger: "irucu"
            replace: "iruçu"
            propagate_case: true
            word: true
          - trigger: "isate"
            replace: "ísate"
            propagate_case: true
            word: true
          - trigger: "islao"
            replace: "islão"
            propagate_case: true
            word: true
          - trigger: "isops"
            replace: "ísops"
            propagate_case: true
            word: true
          - trigger: "itaco"
            replace: "ítaco"
            propagate_case: true
            word: true
          - trigger: "itaja"
            replace: "itajá"
            propagate_case: true
            word: true
          - trigger: "itala"
            replace: "ítala"
            propagate_case: true
            word: true
          - trigger: "italo"
            replace: "ítalo"
            propagate_case: true
            word: true
          - trigger: "itame"
            replace: "ítame"
            propagate_case: true
            word: true
          - trigger: "itamo"
            replace: "ítamo"
            propagate_case: true
            word: true
          - trigger: "itape"
            replace: "itapé"
            propagate_case: true
            word: true
          - trigger: "itaua"
            replace: "itauá"
            propagate_case: true
            word: true
          - trigger: "itrio"
            replace: "ítrio"
            propagate_case: true
            word: true
          - trigger: "iucea"
            replace: "iúcea"
            propagate_case: true
            word: true
          - trigger: "iupua"
            replace: "iupuá"
            propagate_case: true
            word: true
          - trigger: "iuque"
            replace: "iúque"
            propagate_case: true
            word: true
          - trigger: "ivate"
            replace: "ivaté"
            propagate_case: true
            word: true
          - trigger: "ivira"
            replace: "ivirá"
            propagate_case: true
            word: true
          - trigger: "iviro"
            replace: "iviró"
            propagate_case: true
            word: true
          - trigger: "ivora"
            replace: "ivorá"
            propagate_case: true
            word: true
          - trigger: "ixalo"
            replace: "íxalo"
            propagate_case: true
            word: true
          - trigger: "ixiao"
            replace: "ixião"
            propagate_case: true
            word: true
          - trigger: "ixiea"
            replace: "ixíea"
            propagate_case: true
            word: true
          - trigger: "jaaca"
            replace: "jaacã"
            propagate_case: true
            word: true
          - trigger: "jaala"
            replace: "jaalá"
            propagate_case: true
            word: true
          - trigger: "jaare"
            replace: "jaaré"
            propagate_case: true
            word: true
          - trigger: "jabao"
            replace: "jabão"
            propagate_case: true
            word: true
          - trigger: "jacai"
            replace: "jaçaí"
            propagate_case: true
            word: true
          - trigger: "jacea"
            replace: "jácea"
            propagate_case: true
            word: true
          - trigger: "jacio"
            replace: "jácio"
            propagate_case: true
            word: true
          - trigger: "jacua"
            replace: "jacuá"
            propagate_case: true
            word: true
          - trigger: "jacui"
            replace: "jacuí"
            propagate_case: true
            word: true
          - trigger: "jadao"
            replace: "jadão"
            propagate_case: true
            word: true
          - trigger: "jaera"
            replace: "jaerá"
            propagate_case: true
            word: true
          - trigger: "jaffe"
            replace: "jaffé"
            propagate_case: true
            word: true
          - trigger: "jaiba"
            replace: "jaíba"
            propagate_case: true
            word: true
          - trigger: "jaico"
            replace: "jaicó"
            propagate_case: true
            word: true
          - trigger: "jalao"
            replace: "jalão"
            propagate_case: true
            word: true
          - trigger: "jaleo"
            replace: "jáleo"
            propagate_case: true
            word: true
          - trigger: "jaleu"
            replace: "jaléu"
            propagate_case: true
            word: true
          - trigger: "jambe"
            replace: "jambé"
            propagate_case: true
            word: true
          - trigger: "janau"
            replace: "janaú"
            propagate_case: true
            word: true
          - trigger: "janga"
            replace: "jangá"
            propagate_case: true
            word: true
          - trigger: "janie"
            replace: "jânie"
            propagate_case: true
            word: true
          - trigger: "janio"
            replace: "jânio"
            propagate_case: true
            word: true
          - trigger: "janta"
            replace: "jantá"
            propagate_case: true
            word: true
          - trigger: "janua"
            replace: "jânua"
            propagate_case: true
            word: true
          - trigger: "japao"
            replace: "japão"
            propagate_case: true
            word: true
          - trigger: "japiu"
            replace: "japiú"
            propagate_case: true
            word: true
          - trigger: "japix"
            replace: "jápix"
            propagate_case: true
            word: true
          - trigger: "japue"
            replace: "japuê"
            propagate_case: true
            word: true
          - trigger: "japui"
            replace: "japuí"
            propagate_case: true
            word: true
          - trigger: "jaqua"
            replace: "jaquá"
            propagate_case: true
            word: true
          - trigger: "jario"
            replace: "jário"
            propagate_case: true
            word: true
          - trigger: "jarra"
            replace: "jarrá"
            propagate_case: true
            word: true
          - trigger: "jasao"
            replace: "jasão"
            propagate_case: true
            word: true
          - trigger: "jasen"
            replace: "jásen"
            propagate_case: true
            word: true
          - trigger: "jatai"
            replace: "jataí"
            propagate_case: true
            word: true
          - trigger: "jatei"
            replace: "jateí"
            propagate_case: true
            word: true
          - trigger: "javae"
            replace: "javaé"
            propagate_case: true
            word: true
          - trigger: "jeico"
            replace: "jeicó"
            propagate_case: true
            word: true
          - trigger: "jembe"
            replace: "jembé"
            propagate_case: true
            word: true
          - trigger: "jemia"
            replace: "jemiá"
            propagate_case: true
            word: true
          - trigger: "jenia"
            replace: "jênia"
            propagate_case: true
            word: true
          - trigger: "jeova"
            replace: "jeová"
            propagate_case: true
            word: true
          - trigger: "jepia"
            replace: "jepiá"
            propagate_case: true
            word: true
          - trigger: "jepio"
            replace: "jepió"
            propagate_case: true
            word: true
          - trigger: "jesse"
            replace: "jessé"
            propagate_case: true
            word: true
          - trigger: "jesua"
            replace: "jesuá"
            propagate_case: true
            word: true
          - trigger: "jetai"
            replace: "jetaí"
            propagate_case: true
            word: true
          - trigger: "jeuba"
            replace: "jeubá"
            propagate_case: true
            word: true
          - trigger: "jeude"
            replace: "jeúde"
            propagate_case: true
            word: true
          - trigger: "jicao"
            replace: "jicão"
            propagate_case: true
            word: true
          - trigger: "jicui"
            replace: "jiçui"
            propagate_case: true
            word: true
          - trigger: "jipao"
            replace: "jipão"
            propagate_case: true
            word: true
          - trigger: "jiroe"
            replace: "jiroé"
            propagate_case: true
            word: true
          - trigger: "jitai"
            replace: "jitaí"
            propagate_case: true
            word: true
          - trigger: "joada"
            replace: "joadã"
            propagate_case: true
            word: true
          - trigger: "joana"
            replace: "joanã"
            propagate_case: true
            word: true
          - trigger: "jocal"
            replace: "joçal"
            propagate_case: true
            word: true
          - trigger: "jocsa"
            replace: "jocsã"
            propagate_case: true
            word: true
          - trigger: "jocta"
            replace: "joctã"
            propagate_case: true
            word: true
          - trigger: "jogao"
            replace: "jogão"
            propagate_case: true
            word: true
          - trigger: "jogui"
            replace: "jógui"
            propagate_case: true
            word: true
          - trigger: "joiba"
            replace: "joíba"
            propagate_case: true
            word: true
          - trigger: "joica"
            replace: "joiça"
            propagate_case: true
            word: true
          - trigger: "jonao"
            replace: "jonão"
            propagate_case: true
            word: true
          - trigger: "joncu"
            replace: "jonçu"
            propagate_case: true
            word: true
          - trigger: "jonio"
            replace: "jônio"
            propagate_case: true
            word: true
          - trigger: "jorao"
            replace: "jorão"
            propagate_case: true
            word: true
          - trigger: "josia"
            replace: "jósia"
            propagate_case: true
            word: true
          - trigger: "josue"
            replace: "josué"
            propagate_case: true
            word: true
          - trigger: "jotao"
            replace: "jotão"
            propagate_case: true
            word: true
          - trigger: "jotba"
            replace: "jotbá"
            propagate_case: true
            word: true
          - trigger: "jouca"
            replace: "jouça"
            propagate_case: true
            word: true
          - trigger: "jubai"
            replace: "jubaí"
            propagate_case: true
            word: true
          - trigger: "juizo"
            replace: "juízo"
            propagate_case: true
            word: true
          - trigger: "julio"
            replace: "júlio"
            propagate_case: true
            word: true
          - trigger: "junco"
            replace: "junço"
            propagate_case: true
            word: true
          - trigger: "junia"
            replace: "júnia"
            propagate_case: true
            word: true
          - trigger: "jupao"
            replace: "jupão"
            propagate_case: true
            word: true
          - trigger: "jupia"
            replace: "jupiá"
            propagate_case: true
            word: true
          - trigger: "jupua"
            replace: "jupuá"
            propagate_case: true
            word: true
          - trigger: "jurao"
            replace: "jurão"
            propagate_case: true
            word: true
          - trigger: "jurua"
            replace: "juruá"
            propagate_case: true
            word: true
          - trigger: "jusao"
            replace: "jusão"
            propagate_case: true
            word: true
          - trigger: "jutai"
            replace: "jutaí"
            propagate_case: true
            word: true
          - trigger: "juvia"
            replace: "júvia"
            propagate_case: true
            word: true
          - trigger: "labao"
            replace: "labão"
            propagate_case: true
            word: true
          - trigger: "labeu"
            replace: "labéu"
            propagate_case: true
            word: true
          - trigger: "labil"
            replace: "lábil"
            propagate_case: true
            word: true
          - trigger: "labio"
            replace: "lábio"
            propagate_case: true
            word: true
          - trigger: "lacao"
            replace: "lação"
            propagate_case: true
            word: true
          - trigger: "lacio"
            replace: "lácio"
            propagate_case: true
            word: true
          - trigger: "lacon"
            replace: "lácon"
            propagate_case: true
            word: true
          - trigger: "ladao"
            replace: "ladão"
            propagate_case: true
            word: true
          - trigger: "lagao"
            replace: "lagão"
            propagate_case: true
            word: true
          - trigger: "lagis"
            replace: "lágis"
            propagate_case: true
            word: true
          - trigger: "laisa"
            replace: "laísa"
            propagate_case: true
            word: true
          - trigger: "lajao"
            replace: "lajão"
            propagate_case: true
            word: true
          - trigger: "lajea"
            replace: "lájea"
            propagate_case: true
            word: true
          - trigger: "lamio"
            replace: "lâmio"
            propagate_case: true
            word: true
          - trigger: "lanco"
            replace: "lançó"
            propagate_case: true
            word: true
          - trigger: "lando"
            replace: "landó"
            propagate_case: true
            word: true
          - trigger: "laneo"
            replace: "lâneo"
            propagate_case: true
            word: true
          - trigger: "lanio"
            replace: "lânio"
            propagate_case: true
            word: true
          - trigger: "lapao"
            replace: "lapão"
            propagate_case: true
            word: true
          - trigger: "lapia"
            replace: "lapiá"
            propagate_case: true
            word: true
          - trigger: "lapis"
            replace: "lápis"
            propagate_case: true
            word: true
          - trigger: "lareu"
            replace: "laréu"
            propagate_case: true
            word: true
          - trigger: "laria"
            replace: "lária"
            propagate_case: true
            word: true
          - trigger: "larix"
            replace: "lárix"
            propagate_case: true
            word: true
          - trigger: "lasio"
            replace: "lásio"
            propagate_case: true
            word: true
          - trigger: "lasmo"
            replace: "lasmó"
            propagate_case: true
            word: true
          - trigger: "latao"
            replace: "latão"
            propagate_case: true
            word: true
          - trigger: "lateo"
            replace: "láteo"
            propagate_case: true
            word: true
          - trigger: "latex"
            replace: "látex"
            propagate_case: true
            word: true
          - trigger: "latia"
            replace: "látia"
            propagate_case: true
            word: true
          - trigger: "lauie"
            replace: "lauié"
            propagate_case: true
            word: true
          - trigger: "laule"
            replace: "laulé"
            propagate_case: true
            word: true
          - trigger: "lauza"
            replace: "laúza"
            propagate_case: true
            word: true
          - trigger: "lazao"
            replace: "lazão"
            propagate_case: true
            word: true
          - trigger: "lebia"
            replace: "lébia"
            propagate_case: true
            word: true
          - trigger: "lecia"
            replace: "lécia"
            propagate_case: true
            word: true
          - trigger: "ledea"
            replace: "lédea"
            propagate_case: true
            word: true
          - trigger: "legao"
            replace: "legão"
            propagate_case: true
            word: true
          - trigger: "legua"
            replace: "légua"
            propagate_case: true
            word: true
          - trigger: "lelia"
            replace: "lélia"
            propagate_case: true
            word: true
          - trigger: "lelio"
            replace: "lélio"
            propagate_case: true
            word: true
          - trigger: "lelis"
            replace: "lélis"
            propagate_case: true
            word: true
          - trigger: "lemea"
            replace: "lêmea"
            propagate_case: true
            word: true
          - trigger: "lemur"
            replace: "lêmur"
            propagate_case: true
            word: true
          - trigger: "lenao"
            replace: "lenão"
            propagate_case: true
            word: true
          - trigger: "lenco"
            replace: "lenço"
            propagate_case: true
            word: true
          - trigger: "leneo"
            replace: "lêneo"
            propagate_case: true
            word: true
          - trigger: "lenio"
            replace: "lênio"
            propagate_case: true
            word: true
          - trigger: "lenis"
            replace: "lênis"
            propagate_case: true
            word: true
          - trigger: "lenoa"
            replace: "lênoa"
            propagate_case: true
            word: true
          - trigger: "leops"
            replace: "léops"
            propagate_case: true
            word: true
          - trigger: "lepis"
            replace: "lépis"
            propagate_case: true
            word: true
          - trigger: "lepus"
            replace: "lépus"
            propagate_case: true
            word: true
          - trigger: "leria"
            replace: "léria"
            propagate_case: true
            word: true
          - trigger: "lerio"
            replace: "lério"
            propagate_case: true
            word: true
          - trigger: "lesao"
            replace: "lesão"
            propagate_case: true
            word: true
          - trigger: "lesem"
            replace: "lesém"
            propagate_case: true
            word: true
          - trigger: "letao"
            replace: "letão"
            propagate_case: true
            word: true
          - trigger: "lexis"
            replace: "léxis"
            propagate_case: true
            word: true
          - trigger: "liaca"
            replace: "liaça"
            propagate_case: true
            word: true
          - trigger: "libia"
            replace: "líbia"
            propagate_case: true
            word: true
          - trigger: "libio"
            replace: "líbio"
            propagate_case: true
            word: true
          - trigger: "libre"
            replace: "libré"
            propagate_case: true
            word: true
          - trigger: "libuo"
            replace: "líbuo"
            propagate_case: true
            word: true
          - trigger: "licao"
            replace: "lição"
            propagate_case: true
            word: true
          - trigger: "licea"
            replace: "lícea"
            propagate_case: true
            word: true
          - trigger: "licio"
            replace: "lício"
            propagate_case: true
            word: true
          - trigger: "lider"
            replace: "líder"
            propagate_case: true
            word: true
          - trigger: "lidia"
            replace: "lídia"
            propagate_case: true
            word: true
          - trigger: "lidio"
            replace: "lídio"
            propagate_case: true
            word: true
          - trigger: "ligeo"
            replace: "lígeo"
            propagate_case: true
            word: true
          - trigger: "ligio"
            replace: "lígio"
            propagate_case: true
            word: true
          - trigger: "lilia"
            replace: "lília"
            propagate_case: true
            word: true
          - trigger: "limao"
            replace: "limão"
            propagate_case: true
            word: true
          - trigger: "limeo"
            replace: "límeo"
            propagate_case: true
            word: true
          - trigger: "lineo"
            replace: "líneo"
            propagate_case: true
            word: true
          - trigger: "lipia"
            replace: "lípia"
            propagate_case: true
            word: true
          - trigger: "lipoa"
            replace: "lípoa"
            propagate_case: true
            word: true
          - trigger: "lirao"
            replace: "lirão"
            propagate_case: true
            word: true
          - trigger: "lisio"
            replace: "lísio"
            propagate_case: true
            word: true
          - trigger: "lista"
            replace: "listã"
            propagate_case: true
            word: true
          - trigger: "litao"
            replace: "litão"
            propagate_case: true
            word: true
          - trigger: "litio"
            replace: "lítio"
            propagate_case: true
            word: true
          - trigger: "lituo"
            replace: "lítuo"
            propagate_case: true
            word: true
          - trigger: "livia"
            replace: "lívia"
            propagate_case: true
            word: true
          - trigger: "livio"
            replace: "lívio"
            propagate_case: true
            word: true
          - trigger: "lixao"
            replace: "lixão"
            propagate_case: true
            word: true
          - trigger: "lizia"
            replace: "lízia"
            propagate_case: true
            word: true
          - trigger: "lobao"
            replace: "lobão"
            propagate_case: true
            word: true
          - trigger: "locao"
            replace: "loção"
            propagate_case: true
            word: true
          - trigger: "locus"
            replace: "lócus"
            propagate_case: true
            word: true
          - trigger: "lodao"
            replace: "lódão"
            propagate_case: true
            word: true
          - trigger: "lofio"
            replace: "lófio"
            propagate_case: true
            word: true
          - trigger: "logea"
            replace: "lógea"
            propagate_case: true
            word: true
          - trigger: "loibe"
            replace: "loibé"
            propagate_case: true
            word: true
          - trigger: "loica"
            replace: "loiça"
            propagate_case: true
            word: true
          - trigger: "lojia"
            replace: "lójia"
            propagate_case: true
            word: true
          - trigger: "lolio"
            replace: "lólio"
            propagate_case: true
            word: true
          - trigger: "lomis"
            replace: "lômis"
            propagate_case: true
            word: true
          - trigger: "lomue"
            replace: "lomué"
            propagate_case: true
            word: true
          - trigger: "longa"
            replace: "longá"
            propagate_case: true
            word: true
          - trigger: "loqui"
            replace: "lóqui"
            propagate_case: true
            word: true
          - trigger: "lorio"
            replace: "lório"
            propagate_case: true
            word: true
          - trigger: "losia"
            replace: "lósia"
            propagate_case: true
            word: true
          - trigger: "loteo"
            replace: "lóteo"
            propagate_case: true
            word: true
          - trigger: "lotur"
            replace: "lótur"
            propagate_case: true
            word: true
          - trigger: "lotus"
            replace: "lótus"
            propagate_case: true
            word: true
          - trigger: "louca"
            replace: "louça"
            propagate_case: true
            word: true
          - trigger: "lovia"
            replace: "lóvia"
            propagate_case: true
            word: true
          - trigger: "loxia"
            replace: "lóxia"
            propagate_case: true
            word: true
          - trigger: "lucao"
            replace: "lucão"
            propagate_case: true
            word: true
          - trigger: "lucha"
            replace: "luchã"
            propagate_case: true
            word: true
          - trigger: "lucia"
            replace: "lúcia"
            propagate_case: true
            word: true
          - trigger: "lucio"
            replace: "lúcio"
            propagate_case: true
            word: true
          - trigger: "ludio"
            replace: "lúdio"
            propagate_case: true
            word: true
          - trigger: "lueea"
            replace: "luéea"
            propagate_case: true
            word: true
          - trigger: "lufia"
            replace: "lúfia"
            propagate_case: true
            word: true
          - trigger: "luila"
            replace: "luíla"
            propagate_case: true
            word: true
          - trigger: "luime"
            replace: "luíme"
            propagate_case: true
            word: true
          - trigger: "luina"
            replace: "luína"
            propagate_case: true
            word: true
          - trigger: "luisa"
            replace: "luísa"
            propagate_case: true
            word: true
          - trigger: "luiza"
            replace: "luíza"
            propagate_case: true
            word: true
          - trigger: "lulao"
            replace: "lulão"
            propagate_case: true
            word: true
          - trigger: "lumia"
            replace: "lúmia"
            propagate_case: true
            word: true
          - trigger: "lupae"
            replace: "lupaé"
            propagate_case: true
            word: true
          - trigger: "lupia"
            replace: "lúpia"
            propagate_case: true
            word: true
          - trigger: "lupus"
            replace: "lúpus"
            propagate_case: true
            word: true
          - trigger: "luria"
            replace: "lúria"
            propagate_case: true
            word: true
          - trigger: "luteo"
            replace: "lúteo"
            propagate_case: true
            word: true
          - trigger: "lutse"
            replace: "lutsé"
            propagate_case: true
            word: true
          - trigger: "luzie"
            replace: "luziê"
            propagate_case: true
            word: true
          - trigger: "mabiu"
            replace: "mabiú"
            propagate_case: true
            word: true
          - trigger: "mabre"
            replace: "mabré"
            propagate_case: true
            word: true
          - trigger: "macaa"
            replace: "macaá"
            propagate_case: true
            word: true
          - trigger: "macae"
            replace: "macaé"
            propagate_case: true
            word: true
          - trigger: "macar"
            replace: "maçar"
            propagate_case: true
            word: true
          - trigger: "macea"
            replace: "mácea"
            propagate_case: true
            word: true
          - trigger: "mache"
            replace: "machê"
            propagate_case: true
            word: true
          - trigger: "macie"
            replace: "macié"
            propagate_case: true
            word: true
          - trigger: "macom"
            replace: "maçom"
            propagate_case: true
            word: true
          - trigger: "macos"
            replace: "maços"
            propagate_case: true
            word: true
          - trigger: "madia"
            replace: "mádia"
            propagate_case: true
            word: true
          - trigger: "mafau"
            replace: "mafaú"
            propagate_case: true
            word: true
          - trigger: "mafia"
            replace: "máfia"
            propagate_case: true
            word: true
          - trigger: "magai"
            replace: "magaí"
            propagate_case: true
            word: true
          - trigger: "magis"
            replace: "mágis"
            propagate_case: true
            word: true
          - trigger: "magne"
            replace: "magné"
            propagate_case: true
            word: true
          - trigger: "magoa"
            replace: "mágoa"
            propagate_case: true
            word: true
          - trigger: "maiao"
            replace: "maião"
            propagate_case: true
            word: true
          - trigger: "maina"
            replace: "mainá"
            propagate_case: true
            word: true
          - trigger: "maira"
            replace: "maíra"
            propagate_case: true
            word: true
          - trigger: "maisa"
            replace: "maísa"
            propagate_case: true
            word: true
          - trigger: "maite"
            replace: "maitê"
            propagate_case: true
            word: true
          - trigger: "malho"
            replace: "malhó"
            propagate_case: true
            word: true
          - trigger: "malus"
            replace: "málus"
            propagate_case: true
            word: true
          - trigger: "mamae"
            replace: "mamãe"
            propagate_case: true
            word: true
          - trigger: "mamao"
            replace: "mamão"
            propagate_case: true
            word: true
          - trigger: "mambe"
            replace: "mambê"
            propagate_case: true
            word: true
          - trigger: "manai"
            replace: "manaí"
            propagate_case: true
            word: true
          - trigger: "mande"
            replace: "mandé"
            propagate_case: true
            word: true
          - trigger: "mando"
            replace: "mandó"
            propagate_case: true
            word: true
          - trigger: "manes"
            replace: "manês"
            propagate_case: true
            word: true
          - trigger: "manga"
            replace: "mangá"
            propagate_case: true
            word: true
          - trigger: "manha"
            replace: "manhã"
            propagate_case: true
            word: true
          - trigger: "maniu"
            replace: "maniú"
            propagate_case: true
            word: true
          - trigger: "manue"
            replace: "manuê"
            propagate_case: true
            word: true
          - trigger: "maome"
            replace: "maomé"
            propagate_case: true
            word: true
          - trigger: "mapao"
            replace: "mapão"
            propagate_case: true
            word: true
          - trigger: "mapua"
            replace: "mapuá"
            propagate_case: true
            word: true
          - trigger: "maraa"
            replace: "maraã"
            propagate_case: true
            word: true
          - trigger: "marao"
            replace: "marão"
            propagate_case: true
            word: true
          - trigger: "marca"
            replace: "marcá"
            propagate_case: true
            word: true
          - trigger: "marco"
            replace: "março"
            propagate_case: true
            word: true
          - trigger: "mareu"
            replace: "maréu"
            propagate_case: true
            word: true
          - trigger: "marga"
            replace: "margã"
            propagate_case: true
            word: true
          - trigger: "margo"
            replace: "margô"
            propagate_case: true
            word: true
          - trigger: "marii"
            replace: "marií"
            propagate_case: true
            word: true
          - trigger: "marra"
            replace: "marrã"
            propagate_case: true
            word: true
          - trigger: "marua"
            replace: "maruá"
            propagate_case: true
            word: true
          - trigger: "marui"
            replace: "maruí"
            propagate_case: true
            word: true
          - trigger: "maseo"
            replace: "máseo"
            propagate_case: true
            word: true
          - trigger: "maser"
            replace: "máser"
            propagate_case: true
            word: true
          - trigger: "masio"
            replace: "másio"
            propagate_case: true
            word: true
          - trigger: "masue"
            replace: "masué"
            propagate_case: true
            word: true
          - trigger: "matao"
            replace: "matão"
            propagate_case: true
            word: true
          - trigger: "mateu"
            replace: "matéu"
            propagate_case: true
            word: true
          - trigger: "matri"
            replace: "mátri"
            propagate_case: true
            word: true
          - trigger: "matue"
            replace: "matué"
            propagate_case: true
            word: true
          - trigger: "mauba"
            replace: "maúba"
            propagate_case: true
            word: true
          - trigger: "mauca"
            replace: "maúca"
            propagate_case: true
            word: true
          - trigger: "maujo"
            replace: "maújo"
            propagate_case: true
            word: true
          - trigger: "maulo"
            replace: "maúlo"
            propagate_case: true
            word: true
          - trigger: "maune"
            replace: "mauné"
            propagate_case: true
            word: true
          - trigger: "maura"
            replace: "maurá"
            propagate_case: true
            word: true
          - trigger: "mavia"
            replace: "maviá"
            propagate_case: true
            word: true
          - trigger: "mebia"
            replace: "mébia"
            propagate_case: true
            word: true
          - trigger: "mecia"
            replace: "mécia"
            propagate_case: true
            word: true
          - trigger: "medao"
            replace: "medão"
            propagate_case: true
            word: true
          - trigger: "medio"
            replace: "médio"
            propagate_case: true
            word: true
          - trigger: "medon"
            replace: "médon"
            propagate_case: true
            word: true
          - trigger: "meiao"
            replace: "meião"
            propagate_case: true
            word: true
          - trigger: "meier"
            replace: "méier"
            propagate_case: true
            word: true
          - trigger: "melao"
            replace: "melão"
            propagate_case: true
            word: true
          - trigger: "melea"
            replace: "meleá"
            propagate_case: true
            word: true
          - trigger: "meleo"
            replace: "méleo"
            propagate_case: true
            word: true
          - trigger: "melha"
            replace: "melhã"
            propagate_case: true
            word: true
          - trigger: "meloe"
            replace: "méloe"
            propagate_case: true
            word: true
          - trigger: "membe"
            replace: "membé"
            propagate_case: true
            word: true
          - trigger: "menes"
            replace: "menês"
            propagate_case: true
            word: true
          - trigger: "meola"
            replace: "meolá"
            propagate_case: true
            word: true
          - trigger: "meone"
            replace: "méone"
            propagate_case: true
            word: true
          - trigger: "meono"
            replace: "méono"
            propagate_case: true
            word: true
          - trigger: "merem"
            replace: "merém"
            propagate_case: true
            word: true
          - trigger: "merio"
            replace: "merió"
            propagate_case: true
            word: true
          - trigger: "meroe"
            replace: "méroe"
            propagate_case: true
            word: true
          - trigger: "merui"
            replace: "meruí"
            propagate_case: true
            word: true
          - trigger: "mesao"
            replace: "mesão"
            propagate_case: true
            word: true
          - trigger: "mesio"
            replace: "mésio"
            propagate_case: true
            word: true
          - trigger: "meson"
            replace: "méson"
            propagate_case: true
            word: true
          - trigger: "messu"
            replace: "méssu"
            propagate_case: true
            word: true
          - trigger: "mesua"
            replace: "mésua"
            propagate_case: true
            word: true
          - trigger: "metie"
            replace: "metiê"
            propagate_case: true
            word: true
          - trigger: "meuco"
            replace: "meúco"
            propagate_case: true
            word: true
          - trigger: "meule"
            replace: "meúle"
            propagate_case: true
            word: true
          - trigger: "mevia"
            replace: "mévia"
            propagate_case: true
            word: true
          - trigger: "mevio"
            replace: "mévio"
            propagate_case: true
            word: true
          - trigger: "mexao"
            replace: "mexão"
            propagate_case: true
            word: true
          - trigger: "mezio"
            replace: "mézio"
            propagate_case: true
            word: true
          - trigger: "miche"
            replace: "michê"
            propagate_case: true
            word: true
          - trigger: "micio"
            replace: "mício"
            propagate_case: true
            word: true
          - trigger: "midia"
            replace: "mídia"
            propagate_case: true
            word: true
          - trigger: "mijao"
            replace: "mijão"
            propagate_case: true
            word: true
          - trigger: "mijui"
            replace: "mijuí"
            propagate_case: true
            word: true
          - trigger: "milao"
            replace: "milão"
            propagate_case: true
            word: true
          - trigger: "mileo"
            replace: "míleo"
            propagate_case: true
            word: true
          - trigger: "milha"
            replace: "milhã"
            propagate_case: true
            word: true
          - trigger: "milio"
            replace: "mílio"
            propagate_case: true
            word: true
          - trigger: "mimon"
            replace: "mímon"
            propagate_case: true
            word: true
          - trigger: "minda"
            replace: "mindá"
            propagate_case: true
            word: true
          - trigger: "minio"
            replace: "mínio"
            propagate_case: true
            word: true
          - trigger: "miope"
            replace: "míope"
            propagate_case: true
            word: true
          - trigger: "mirai"
            replace: "miraí"
            propagate_case: true
            word: true
          - trigger: "mirao"
            replace: "mirão"
            propagate_case: true
            word: true
          - trigger: "miras"
            replace: "mirás"
            propagate_case: true
            word: true
          - trigger: "mirga"
            replace: "mirgã"
            propagate_case: true
            word: true
          - trigger: "miria"
            replace: "míria"
            propagate_case: true
            word: true
          - trigger: "mirio"
            replace: "mirió"
            propagate_case: true
            word: true
          - trigger: "miris"
            replace: "míris"
            propagate_case: true
            word: true
          - trigger: "miroe"
            replace: "miroé"
            propagate_case: true
            word: true
          - trigger: "mirui"
            replace: "miruí"
            propagate_case: true
            word: true
          - trigger: "mirza"
            replace: "mirzá"
            propagate_case: true
            word: true
          - trigger: "misio"
            replace: "mísio"
            propagate_case: true
            word: true
          - trigger: "misis"
            replace: "mísis"
            propagate_case: true
            word: true
          - trigger: "misna"
            replace: "misná"
            propagate_case: true
            word: true
          - trigger: "mispa"
            replace: "mispá"
            propagate_case: true
            word: true
          - trigger: "misso"
            replace: "missô"
            propagate_case: true
            word: true
          - trigger: "mitim"
            replace: "mítim"
            propagate_case: true
            word: true
          - trigger: "miuca"
            replace: "miúça"
            propagate_case: true
            word: true
          - trigger: "miude"
            replace: "miúde"
            propagate_case: true
            word: true
          - trigger: "miudo"
            replace: "miúdo"
            propagate_case: true
            word: true
          - trigger: "miufa"
            replace: "miúfa"
            propagate_case: true
            word: true
          - trigger: "miulo"
            replace: "miúlo"
            propagate_case: true
            word: true
          - trigger: "miuro"
            replace: "miúro"
            propagate_case: true
            word: true
          - trigger: "miuva"
            replace: "miúva"
            propagate_case: true
            word: true
          - trigger: "moaca"
            replace: "moacã"
            propagate_case: true
            word: true
          - trigger: "moadi"
            replace: "moádi"
            propagate_case: true
            word: true
          - trigger: "moali"
            replace: "moáli"
            propagate_case: true
            word: true
          - trigger: "mobil"
            replace: "móbil"
            propagate_case: true
            word: true
          - trigger: "mocao"
            replace: "moção"
            propagate_case: true
            word: true
          - trigger: "mocis"
            replace: "mócis"
            propagate_case: true
            word: true
          - trigger: "mocos"
            replace: "moços"
            propagate_case: true
            word: true
          - trigger: "mocui"
            replace: "mocuí"
            propagate_case: true
            word: true
          - trigger: "modio"
            replace: "módio"
            propagate_case: true
            word: true
          - trigger: "mogao"
            replace: "mogão"
            propagate_case: true
            word: true
          - trigger: "mogue"
            replace: "mogué"
            propagate_case: true
            word: true
          - trigger: "moiao"
            replace: "moião"
            propagate_case: true
            word: true
          - trigger: "moire"
            replace: "moiré"
            propagate_case: true
            word: true
          - trigger: "mojui"
            replace: "mojuí"
            propagate_case: true
            word: true
          - trigger: "molia"
            replace: "mólia"
            propagate_case: true
            word: true
          - trigger: "molio"
            replace: "mólio"
            propagate_case: true
            word: true
          - trigger: "mompe"
            replace: "mompé"
            propagate_case: true
            word: true
          - trigger: "monco"
            replace: "moncó"
            propagate_case: true
            word: true
          - trigger: "monde"
            replace: "mondé"
            propagate_case: true
            word: true
          - trigger: "monhe"
            replace: "monhé"
            propagate_case: true
            word: true
          - trigger: "mooca"
            replace: "moóca"
            propagate_case: true
            word: true
          - trigger: "moqua"
            replace: "móqua"
            propagate_case: true
            word: true
          - trigger: "morai"
            replace: "moraí"
            propagate_case: true
            word: true
          - trigger: "morao"
            replace: "morão"
            propagate_case: true
            word: true
          - trigger: "morea"
            replace: "mórea"
            propagate_case: true
            word: true
          - trigger: "moria"
            replace: "moriá"
            propagate_case: true
            word: true
          - trigger: "morio"
            replace: "mório"
            propagate_case: true
            word: true
          - trigger: "mosba"
            replace: "mosbá"
            propagate_case: true
            word: true
          - trigger: "movel"
            replace: "móvel"
            propagate_case: true
            word: true
          - trigger: "muadi"
            replace: "muádi"
            propagate_case: true
            word: true
          - trigger: "muana"
            replace: "muaná"
            propagate_case: true
            word: true
          - trigger: "muani"
            replace: "muâni"
            propagate_case: true
            word: true
          - trigger: "muari"
            replace: "muári"
            propagate_case: true
            word: true
          - trigger: "mucao"
            replace: "mução"
            propagate_case: true
            word: true
          - trigger: "muchi"
            replace: "múchi"
            propagate_case: true
            word: true
          - trigger: "mucio"
            replace: "múcio"
            propagate_case: true
            word: true
          - trigger: "mucua"
            replace: "múcua"
            propagate_case: true
            word: true
          - trigger: "mucue"
            replace: "mucué"
            propagate_case: true
            word: true
          - trigger: "mucui"
            replace: "mucuí"
            propagate_case: true
            word: true
          - trigger: "mufui"
            replace: "mufuí"
            propagate_case: true
            word: true
          - trigger: "mugil"
            replace: "múgil"
            propagate_case: true
            word: true
          - trigger: "mugue"
            replace: "mugué"
            propagate_case: true
            word: true
          - trigger: "muila"
            replace: "muíla"
            propagate_case: true
            word: true
          - trigger: "muira"
            replace: "muirá"
            propagate_case: true
            word: true
          - trigger: "muita"
            replace: "muitá"
            propagate_case: true
            word: true
          - trigger: "mujio"
            replace: "mújio"
            propagate_case: true
            word: true
          - trigger: "muleo"
            replace: "múleo"
            propagate_case: true
            word: true
          - trigger: "mulio"
            replace: "múlio"
            propagate_case: true
            word: true
          - trigger: "muloi"
            replace: "mulói"
            propagate_case: true
            word: true
          - trigger: "mumbe"
            replace: "mumbé"
            propagate_case: true
            word: true
          - trigger: "mumia"
            replace: "múmia"
            propagate_case: true
            word: true
          - trigger: "munde"
            replace: "mundé"
            propagate_case: true
            word: true
          - trigger: "mundi"
            replace: "múndi"
            propagate_case: true
            word: true
          - trigger: "munia"
            replace: "múnia"
            propagate_case: true
            word: true
          - trigger: "munje"
            replace: "munjé"
            propagate_case: true
            word: true
          - trigger: "munus"
            replace: "múnus"
            propagate_case: true
            word: true
          - trigger: "murca"
            replace: "murça"
            propagate_case: true
            word: true
          - trigger: "murex"
            replace: "múrex"
            propagate_case: true
            word: true
          - trigger: "muria"
            replace: "muriá"
            propagate_case: true
            word: true
          - trigger: "murui"
            replace: "muruí"
            propagate_case: true
            word: true
          - trigger: "murza"
            replace: "murzá"
            propagate_case: true
            word: true
          - trigger: "musme"
            replace: "musmé"
            propagate_case: true
            word: true
          - trigger: "mutoe"
            replace: "mutoé"
            propagate_case: true
            word: true
          - trigger: "mutua"
            replace: "mutuã"
            propagate_case: true
            word: true
          - trigger: "mutuo"
            replace: "mútuo"
            propagate_case: true
            word: true
          - trigger: "muviu"
            replace: "muviú"
            propagate_case: true
            word: true
          - trigger: "muxem"
            replace: "muxém"
            propagate_case: true
            word: true
          - trigger: "muzua"
            replace: "múzua"
            propagate_case: true
            word: true
          - trigger: "nabao"
            replace: "nábão"
            propagate_case: true
            word: true
          - trigger: "nabis"
            replace: "nábis"
            propagate_case: true
            word: true
          - trigger: "nacao"
            replace: "nação"
            propagate_case: true
            word: true
          - trigger: "nacar"
            replace: "nácar"
            propagate_case: true
            word: true
          - trigger: "nadem"
            replace: "nadém"
            propagate_case: true
            word: true
          - trigger: "nader"
            replace: "náder"
            propagate_case: true
            word: true
          - trigger: "nadia"
            replace: "nádia"
            propagate_case: true
            word: true
          - trigger: "nagao"
            replace: "nagão"
            propagate_case: true
            word: true
          - trigger: "nagua"
            replace: "nágua"
            propagate_case: true
            word: true
          - trigger: "naive"
            replace: "naïve"
            propagate_case: true
            word: true
          - trigger: "naixo"
            replace: "naixó"
            propagate_case: true
            word: true
          - trigger: "najir"
            replace: "nájir"
            propagate_case: true
            word: true
          - trigger: "namia"
            replace: "nâmia"
            propagate_case: true
            word: true
          - trigger: "nania"
            replace: "nânia"
            propagate_case: true
            word: true
          - trigger: "narca"
            replace: "narça"
            propagate_case: true
            word: true
          - trigger: "narea"
            replace: "nárea"
            propagate_case: true
            word: true
          - trigger: "naseo"
            replace: "náseo"
            propagate_case: true
            word: true
          - trigger: "nasio"
            replace: "násio"
            propagate_case: true
            word: true
          - trigger: "nassi"
            replace: "nássi"
            propagate_case: true
            word: true
          - trigger: "nasua"
            replace: "násua"
            propagate_case: true
            word: true
          - trigger: "natia"
            replace: "nátia"
            propagate_case: true
            word: true
          - trigger: "navao"
            replace: "navaó"
            propagate_case: true
            word: true
          - trigger: "navea"
            replace: "návea"
            propagate_case: true
            word: true
          - trigger: "navem"
            replace: "navém"
            propagate_case: true
            word: true
          - trigger: "navia"
            replace: "návia"
            propagate_case: true
            word: true
          - trigger: "naxio"
            replace: "náxio"
            propagate_case: true
            word: true
          - trigger: "nazia"
            replace: "názia"
            propagate_case: true
            word: true
          - trigger: "nazir"
            replace: "názir"
            propagate_case: true
            word: true
          - trigger: "nedai"
            replace: "nedaí"
            propagate_case: true
            word: true
          - trigger: "nedio"
            replace: "nédio"
            propagate_case: true
            word: true
          - trigger: "nedji"
            replace: "nédji"
            propagate_case: true
            word: true
          - trigger: "negao"
            replace: "negão"
            propagate_case: true
            word: true
          - trigger: "negra"
            replace: "negrã"
            propagate_case: true
            word: true
          - trigger: "nelia"
            replace: "nélia"
            propagate_case: true
            word: true
          - trigger: "nelio"
            replace: "nélio"
            propagate_case: true
            word: true
          - trigger: "nenax"
            replace: "nênax"
            propagate_case: true
            word: true
          - trigger: "nenem"
            replace: "neném"
            propagate_case: true
            word: true
          - trigger: "nenio"
            replace: "nênio"
            propagate_case: true
            word: true
          - trigger: "neone"
            replace: "néone"
            propagate_case: true
            word: true
          - trigger: "neper"
            replace: "néper"
            propagate_case: true
            word: true
          - trigger: "nepia"
            replace: "népia"
            propagate_case: true
            word: true
          - trigger: "nerio"
            replace: "nério"
            propagate_case: true
            word: true
          - trigger: "neseo"
            replace: "néseo"
            propagate_case: true
            word: true
          - trigger: "nevao"
            replace: "nevão"
            propagate_case: true
            word: true
          - trigger: "nevio"
            replace: "névio"
            propagate_case: true
            word: true
          - trigger: "nevis"
            replace: "névis"
            propagate_case: true
            word: true
          - trigger: "nevoa"
            replace: "névoa"
            propagate_case: true
            word: true
          - trigger: "nhimo"
            replace: "nhimó"
            propagate_case: true
            word: true
          - trigger: "niboe"
            replace: "niboé"
            propagate_case: true
            word: true
          - trigger: "nices"
            replace: "nicês"
            propagate_case: true
            word: true
          - trigger: "nicia"
            replace: "nícia"
            propagate_case: true
            word: true
          - trigger: "nidia"
            replace: "nídia"
            propagate_case: true
            word: true
          - trigger: "nifao"
            replace: "nifão"
            propagate_case: true
            word: true
          - trigger: "nigua"
            replace: "nígua"
            propagate_case: true
            word: true
          - trigger: "nilgo"
            replace: "nilgó"
            propagate_case: true
            word: true
          - trigger: "nilio"
            replace: "nílio"
            propagate_case: true
            word: true
          - trigger: "nimio"
            replace: "nímio"
            propagate_case: true
            word: true
          - trigger: "ninji"
            replace: "nínji"
            propagate_case: true
            word: true
          - trigger: "niopo"
            replace: "niopó"
            propagate_case: true
            word: true
          - trigger: "nipao"
            replace: "nipão"
            propagate_case: true
            word: true
          - trigger: "nipoa"
            replace: "nipoã"
            propagate_case: true
            word: true
          - trigger: "nirex"
            replace: "nírex"
            propagate_case: true
            word: true
          - trigger: "nisao"
            replace: "nisão"
            propagate_case: true
            word: true
          - trigger: "nisia"
            replace: "nísia"
            propagate_case: true
            word: true
          - trigger: "nisio"
            replace: "nísio"
            propagate_case: true
            word: true
          - trigger: "niton"
            replace: "níton"
            propagate_case: true
            word: true
          - trigger: "nivel"
            replace: "nível"
            propagate_case: true
            word: true
          - trigger: "nocao"
            replace: "noção"
            propagate_case: true
            word: true
          - trigger: "nocio"
            replace: "nócio"
            propagate_case: true
            word: true
          - trigger: "nodio"
            replace: "nódio"
            propagate_case: true
            word: true
          - trigger: "nodoa"
            replace: "nódoa"
            propagate_case: true
            word: true
          - trigger: "nogao"
            replace: "nogão"
            propagate_case: true
            word: true
          - trigger: "nomeo"
            replace: "nômeo"
            propagate_case: true
            word: true
          - trigger: "nonea"
            replace: "nônea"
            propagate_case: true
            word: true
          - trigger: "nonex"
            replace: "nônex"
            propagate_case: true
            word: true
          - trigger: "nonio"
            replace: "nônio"
            propagate_case: true
            word: true
          - trigger: "norca"
            replace: "norça"
            propagate_case: true
            word: true
          - trigger: "norio"
            replace: "nório"
            propagate_case: true
            word: true
          - trigger: "noteo"
            replace: "nóteo"
            propagate_case: true
            word: true
          - trigger: "novea"
            replace: "nóvea"
            propagate_case: true
            word: true
          - trigger: "novio"
            replace: "nóvio"
            propagate_case: true
            word: true
          - trigger: "novoa"
            replace: "nóvoa"
            propagate_case: true
            word: true
          - trigger: "noxio"
            replace: "nóxio"
            propagate_case: true
            word: true
          - trigger: "nubil"
            replace: "núbil"
            propagate_case: true
            word: true
          - trigger: "nubio"
            replace: "núbio"
            propagate_case: true
            word: true
          - trigger: "nucao"
            replace: "nução"
            propagate_case: true
            word: true
          - trigger: "nucio"
            replace: "núcio"
            propagate_case: true
            word: true
          - trigger: "nufar"
            replace: "núfar"
            propagate_case: true
            word: true
          - trigger: "nuima"
            replace: "nuíma"
            propagate_case: true
            word: true
          - trigger: "numen"
            replace: "númen"
            propagate_case: true
            word: true
          - trigger: "nuria"
            replace: "núria"
            propagate_case: true
            word: true
          - trigger: "nuveo"
            replace: "núveo"
            propagate_case: true
            word: true
          - trigger: "nuxia"
            replace: "núxia"
            propagate_case: true
            word: true
          - trigger: "oasis"
            replace: "oásis"
            propagate_case: true
            word: true
          - trigger: "obelo"
            replace: "óbelo"
            propagate_case: true
            word: true
          - trigger: "obice"
            replace: "óbice"
            propagate_case: true
            word: true
          - trigger: "obito"
            replace: "óbito"
            propagate_case: true
            word: true
          - trigger: "obolo"
            replace: "óbolo"
            propagate_case: true
            word: true
          - trigger: "obulo"
            replace: "óbulo"
            propagate_case: true
            word: true
          - trigger: "obvio"
            replace: "óbvio"
            propagate_case: true
            word: true
          - trigger: "ocrea"
            replace: "ócrea"
            propagate_case: true
            word: true
          - trigger: "oculo"
            replace: "óculo"
            propagate_case: true
            word: true
          - trigger: "ocume"
            replace: "ocumé"
            propagate_case: true
            word: true
          - trigger: "odeao"
            replace: "odeão"
            propagate_case: true
            word: true
          - trigger: "oecio"
            replace: "oécio"
            propagate_case: true
            word: true
          - trigger: "oeone"
            replace: "oéone"
            propagate_case: true
            word: true
          - trigger: "ofaie"
            replace: "ofaié"
            propagate_case: true
            word: true
          - trigger: "ofris"
            replace: "ófris"
            propagate_case: true
            word: true
          - trigger: "ofuro"
            replace: "ofurô"
            propagate_case: true
            word: true
          - trigger: "ogodo"
            replace: "ogodô"
            propagate_case: true
            word: true
          - trigger: "ogude"
            replace: "ogudê"
            propagate_case: true
            word: true
          - trigger: "oguxo"
            replace: "oguxó"
            propagate_case: true
            word: true
          - trigger: "oiaca"
            replace: "oiacá"
            propagate_case: true
            word: true
          - trigger: "oicam"
            replace: "oiçam"
            propagate_case: true
            word: true
          - trigger: "oidio"
            replace: "oídio"
            propagate_case: true
            word: true
          - trigger: "oinca"
            replace: "oincá"
            propagate_case: true
            word: true
          - trigger: "oitao"
            replace: "oitão"
            propagate_case: true
            word: true
          - trigger: "olala"
            replace: "olalá"
            propagate_case: true
            word: true
          - trigger: "olare"
            replace: "olaré"
            propagate_case: true
            word: true
          - trigger: "olele"
            replace: "olelé"
            propagate_case: true
            word: true
          - trigger: "olere"
            replace: "oleré"
            propagate_case: true
            word: true
          - trigger: "olhao"
            replace: "olhão"
            propagate_case: true
            word: true
          - trigger: "olobo"
            replace: "olobó"
            propagate_case: true
            word: true
          - trigger: "olode"
            replace: "olodé"
            propagate_case: true
            word: true
          - trigger: "olubo"
            replace: "olubó"
            propagate_case: true
            word: true
          - trigger: "omaia"
            replace: "omaiá"
            propagate_case: true
            word: true
          - trigger: "omala"
            replace: "omalá"
            propagate_case: true
            word: true
          - trigger: "ombra"
            replace: "ombrã"
            propagate_case: true
            word: true
          - trigger: "omega"
            replace: "ômega"
            propagate_case: true
            word: true
          - trigger: "omele"
            replace: "omelê"
            propagate_case: true
            word: true
          - trigger: "onfua"
            replace: "onfuá"
            propagate_case: true
            word: true
          - trigger: "opaie"
            replace: "opaié"
            propagate_case: true
            word: true
          - trigger: "opalo"
            replace: "ópalo"
            propagate_case: true
            word: true
          - trigger: "opcao"
            replace: "opção"
            propagate_case: true
            word: true
          - trigger: "opele"
            replace: "opelé"
            propagate_case: true
            word: true
          - trigger: "opera"
            replace: "ópera"
            propagate_case: true
            word: true
          - trigger: "opido"
            replace: "ópido"
            propagate_case: true
            word: true
          - trigger: "oquea"
            replace: "oqueá"
            propagate_case: true
            word: true
          - trigger: "oquie"
            replace: "oquié"
            propagate_case: true
            word: true
          - trigger: "orcar"
            replace: "orçar"
            propagate_case: true
            word: true
          - trigger: "orcaz"
            replace: "orçaz"
            propagate_case: true
            word: true
          - trigger: "orfao"
            replace: "órfão"
            propagate_case: true
            word: true
          - trigger: "orfia"
            replace: "órfia"
            propagate_case: true
            word: true
          - trigger: "orgao"
            replace: "órgão"
            propagate_case: true
            word: true
          - trigger: "orixa"
            replace: "orixá"
            propagate_case: true
            word: true
          - trigger: "orlea"
            replace: "orleã"
            propagate_case: true
            word: true
          - trigger: "orobo"
            replace: "orobó"
            propagate_case: true
            word: true
          - trigger: "oroco"
            replace: "orocó"
            propagate_case: true
            word: true
          - trigger: "orupa"
            replace: "orupá"
            propagate_case: true
            word: true
          - trigger: "oseas"
            replace: "oséas"
            propagate_case: true
            word: true
          - trigger: "osido"
            replace: "ósido"
            propagate_case: true
            word: true
          - trigger: "osmio"
            replace: "ósmio"
            propagate_case: true
            word: true
          - trigger: "ossae"
            replace: "ossãe"
            propagate_case: true
            word: true
          - trigger: "osseo"
            replace: "ósseo"
            propagate_case: true
            word: true
          - trigger: "ostio"
            replace: "óstio"
            propagate_case: true
            word: true
          - trigger: "otico"
            replace: "ótico"
            propagate_case: true
            word: true
          - trigger: "otimo"
            replace: "ótimo"
            propagate_case: true
            word: true
          - trigger: "ototo"
            replace: "ototó"
            propagate_case: true
            word: true
          - trigger: "oucao"
            replace: "oução"
            propagate_case: true
            word: true
          - trigger: "ourem"
            replace: "ourém"
            propagate_case: true
            word: true
          - trigger: "outao"
            replace: "outão"
            propagate_case: true
            word: true
          - trigger: "ovalo"
            replace: "óvalo"
            propagate_case: true
            word: true
          - trigger: "ovano"
            replace: "óvano"
            propagate_case: true
            word: true
          - trigger: "ovulo"
            replace: "óvulo"
            propagate_case: true
            word: true
          - trigger: "oxala"
            replace: "oxalá"
            propagate_case: true
            word: true
          - trigger: "oxiao"
            replace: "oxião"
            propagate_case: true
            word: true
          - trigger: "oxido"
            replace: "óxido"
            propagate_case: true
            word: true
          - trigger: "pacai"
            replace: "pacaí"
            propagate_case: true
            word: true
          - trigger: "pacal"
            replace: "paçal"
            propagate_case: true
            word: true
          - trigger: "pacao"
            replace: "pação"
            propagate_case: true
            word: true
          - trigger: "pacem"
            replace: "pacém"
            propagate_case: true
            word: true
          - trigger: "pacha"
            replace: "pachã"
            propagate_case: true
            word: true
          - trigger: "pacua"
            replace: "pacuã"
            propagate_case: true
            word: true
          - trigger: "pacui"
            replace: "pacuí"
            propagate_case: true
            word: true
          - trigger: "pader"
            replace: "páder"
            propagate_case: true
            word: true
          - trigger: "padoa"
            replace: "pádoa"
            propagate_case: true
            word: true
          - trigger: "padua"
            replace: "pádua"
            propagate_case: true
            word: true
          - trigger: "paete"
            replace: "paetê"
            propagate_case: true
            word: true
          - trigger: "pafio"
            replace: "páfio"
            propagate_case: true
            word: true
          - trigger: "pafua"
            replace: "pafuá"
            propagate_case: true
            word: true
          - trigger: "pagao"
            replace: "pagão"
            propagate_case: true
            word: true
          - trigger: "pagua"
            replace: "págua"
            propagate_case: true
            word: true
          - trigger: "pague"
            replace: "paguê"
            propagate_case: true
            word: true
          - trigger: "paiao"
            replace: "paião"
            propagate_case: true
            word: true
          - trigger: "paiba"
            replace: "paíba"
            propagate_case: true
            word: true
          - trigger: "pailo"
            replace: "pailó"
            propagate_case: true
            word: true
          - trigger: "pajao"
            replace: "pajão"
            propagate_case: true
            word: true
          - trigger: "pajau"
            replace: "pajaú"
            propagate_case: true
            word: true
          - trigger: "pajeu"
            replace: "pajeú"
            propagate_case: true
            word: true
          - trigger: "palao"
            replace: "palão"
            propagate_case: true
            word: true
          - trigger: "palea"
            replace: "pálea"
            propagate_case: true
            word: true
          - trigger: "palio"
            replace: "pálio"
            propagate_case: true
            word: true
          - trigger: "pamoa"
            replace: "pamoá"
            propagate_case: true
            word: true
          - trigger: "panao"
            replace: "panão"
            propagate_case: true
            word: true
          - trigger: "panax"
            replace: "pânax"
            propagate_case: true
            word: true
          - trigger: "panca"
            replace: "pança"
            propagate_case: true
            word: true
          - trigger: "pango"
            replace: "pangó"
            propagate_case: true
            word: true
          - trigger: "panro"
            replace: "panró"
            propagate_case: true
            word: true
          - trigger: "panto"
            replace: "pantó"
            propagate_case: true
            word: true
          - trigger: "panus"
            replace: "pânus"
            propagate_case: true
            word: true
          - trigger: "papao"
            replace: "papão"
            propagate_case: true
            word: true
          - trigger: "papio"
            replace: "pápio"
            propagate_case: true
            word: true
          - trigger: "paqua"
            replace: "paquã"
            propagate_case: true
            word: true
          - trigger: "paque"
            replace: "paquê"
            propagate_case: true
            word: true
          - trigger: "parai"
            replace: "paraí"
            propagate_case: true
            word: true
          - trigger: "parao"
            replace: "parão"
            propagate_case: true
            word: true
          - trigger: "pareo"
            replace: "pareô"
            propagate_case: true
            word: true
          - trigger: "paria"
            replace: "pariá"
            propagate_case: true
            word: true
          - trigger: "pario"
            replace: "pário"
            propagate_case: true
            word: true
          - trigger: "paris"
            replace: "páris"
            propagate_case: true
            word: true
          - trigger: "parne"
            replace: "parné"
            propagate_case: true
            word: true
          - trigger: "parsi"
            replace: "pársi"
            propagate_case: true
            word: true
          - trigger: "parua"
            replace: "paruá"
            propagate_case: true
            word: true
          - trigger: "parui"
            replace: "paruí"
            propagate_case: true
            word: true
          - trigger: "pasea"
            replace: "paseá"
            propagate_case: true
            word: true
          - trigger: "passe"
            replace: "passé"
            propagate_case: true
            word: true
          - trigger: "patai"
            replace: "pataí"
            propagate_case: true
            word: true
          - trigger: "patao"
            replace: "patão"
            propagate_case: true
            word: true
          - trigger: "patas"
            replace: "patás"
            propagate_case: true
            word: true
          - trigger: "patem"
            replace: "patém"
            propagate_case: true
            word: true
          - trigger: "pateo"
            replace: "páteo"
            propagate_case: true
            word: true
          - trigger: "patia"
            replace: "patiá"
            propagate_case: true
            word: true
          - trigger: "patio"
            replace: "pátio"
            propagate_case: true
            word: true
          - trigger: "patoa"
            replace: "patoá"
            propagate_case: true
            word: true
          - trigger: "patua"
            replace: "patuá"
            propagate_case: true
            word: true
          - trigger: "paulo"
            replace: "paúlo"
            propagate_case: true
            word: true
          - trigger: "pauna"
            replace: "paúna"
            propagate_case: true
            word: true
          - trigger: "paura"
            replace: "paúra"
            propagate_case: true
            word: true
          - trigger: "pavao"
            replace: "pavão"
            propagate_case: true
            word: true
          - trigger: "pavia"
            replace: "pávia"
            propagate_case: true
            word: true
          - trigger: "paxau"
            replace: "paxaú"
            propagate_case: true
            word: true
          - trigger: "paxia"
            replace: "páxia"
            propagate_case: true
            word: true
          - trigger: "pazao"
            replace: "pazão"
            propagate_case: true
            word: true
          - trigger: "peaca"
            replace: "peaça"
            propagate_case: true
            word: true
          - trigger: "pecem"
            replace: "pecém"
            propagate_case: true
            word: true
          - trigger: "pecoi"
            replace: "pecói"
            propagate_case: true
            word: true
          - trigger: "pegao"
            replace: "pegão"
            propagate_case: true
            word: true
          - trigger: "peipa"
            replace: "peipá"
            propagate_case: true
            word: true
          - trigger: "pelao"
            replace: "pelão"
            propagate_case: true
            word: true
          - trigger: "pelem"
            replace: "pelém"
            propagate_case: true
            word: true
          - trigger: "pelio"
            replace: "pélio"
            propagate_case: true
            word: true
          - trigger: "penao"
            replace: "penão"
            propagate_case: true
            word: true
          - trigger: "penea"
            replace: "pênea"
            propagate_case: true
            word: true
          - trigger: "penio"
            replace: "pênio"
            propagate_case: true
            word: true
          - trigger: "peone"
            replace: "péone"
            propagate_case: true
            word: true
          - trigger: "pepia"
            replace: "pépia"
            propagate_case: true
            word: true
          - trigger: "pepse"
            replace: "pepsé"
            propagate_case: true
            word: true
          - trigger: "perea"
            replace: "pereá"
            propagate_case: true
            word: true
          - trigger: "peroa"
            replace: "peroá"
            propagate_case: true
            word: true
          - trigger: "perre"
            replace: "perrê"
            propagate_case: true
            word: true
          - trigger: "pesao"
            replace: "pesão"
            propagate_case: true
            word: true
          - trigger: "pesme"
            replace: "pesmé"
            propagate_case: true
            word: true
          - trigger: "petao"
            replace: "petão"
            propagate_case: true
            word: true
          - trigger: "petem"
            replace: "petém"
            propagate_case: true
            word: true
          - trigger: "petia"
            replace: "petiá"
            propagate_case: true
            word: true
          - trigger: "petiu"
            replace: "petiú"
            propagate_case: true
            word: true
          - trigger: "peuco"
            replace: "peúco"
            propagate_case: true
            word: true
          - trigger: "peuga"
            replace: "peúga"
            propagate_case: true
            word: true
          - trigger: "peule"
            replace: "peúle"
            propagate_case: true
            word: true
          - trigger: "peuva"
            replace: "peúva"
            propagate_case: true
            word: true
          - trigger: "pexao"
            replace: "pexão"
            propagate_case: true
            word: true
          - trigger: "pexem"
            replace: "pexém"
            propagate_case: true
            word: true
          - trigger: "pezao"
            replace: "pezão"
            propagate_case: true
            word: true
          - trigger: "piaco"
            replace: "piaço"
            propagate_case: true
            word: true
          - trigger: "piade"
            replace: "piadé"
            propagate_case: true
            word: true
          - trigger: "piafe"
            replace: "piafé"
            propagate_case: true
            word: true
          - trigger: "piape"
            replace: "piapé"
            propagate_case: true
            word: true
          - trigger: "piata"
            replace: "piatã"
            propagate_case: true
            word: true
          - trigger: "piaui"
            replace: "piauí"
            propagate_case: true
            word: true
          - trigger: "picao"
            replace: "picão"
            propagate_case: true
            word: true
          - trigger: "picau"
            replace: "picaú"
            propagate_case: true
            word: true
          - trigger: "piceo"
            replace: "píceo"
            propagate_case: true
            word: true
          - trigger: "piche"
            replace: "piché"
            propagate_case: true
            word: true
          - trigger: "picui"
            replace: "picuí"
            propagate_case: true
            word: true
          - trigger: "pidao"
            replace: "pidão"
            propagate_case: true
            word: true
          - trigger: "piere"
            replace: "píere"
            propagate_case: true
            word: true
          - trigger: "pieta"
            replace: "pietá"
            propagate_case: true
            word: true
          - trigger: "pifao"
            replace: "pifão"
            propagate_case: true
            word: true
          - trigger: "pifio"
            replace: "pífio"
            propagate_case: true
            word: true
          - trigger: "pigeo"
            replace: "pígeo"
            propagate_case: true
            word: true
          - trigger: "pigua"
            replace: "piguá"
            propagate_case: true
            word: true
          - trigger: "pijin"
            replace: "píjin"
            propagate_case: true
            word: true
          - trigger: "pilao"
            replace: "pilão"
            propagate_case: true
            word: true
          - trigger: "pileo"
            replace: "píleo"
            propagate_case: true
            word: true
          - trigger: "pileu"
            replace: "piléu"
            propagate_case: true
            word: true
          - trigger: "pilio"
            replace: "pílio"
            propagate_case: true
            word: true
          - trigger: "pindo"
            replace: "pindó"
            propagate_case: true
            word: true
          - trigger: "pineo"
            replace: "píneo"
            propagate_case: true
            word: true
          - trigger: "pineu"
            replace: "pinéu"
            propagate_case: true
            word: true
          - trigger: "pinhe"
            replace: "pinhé"
            propagate_case: true
            word: true
          - trigger: "pioie"
            replace: "pioié"
            propagate_case: true
            word: true
          - trigger: "piono"
            replace: "píono"
            propagate_case: true
            word: true
          - trigger: "pioro"
            replace: "pioró"
            propagate_case: true
            word: true
          - trigger: "pipao"
            replace: "pipão"
            propagate_case: true
            word: true
          - trigger: "piper"
            replace: "píper"
            propagate_case: true
            word: true
          - trigger: "pipio"
            replace: "pipiô"
            propagate_case: true
            word: true
          - trigger: "piqua"
            replace: "píqua"
            propagate_case: true
            word: true
          - trigger: "pique"
            replace: "piquê"
            propagate_case: true
            word: true
          - trigger: "pirai"
            replace: "piraí"
            propagate_case: true
            word: true
          - trigger: "pirao"
            replace: "pirão"
            propagate_case: true
            word: true
          - trigger: "pirau"
            replace: "piraú"
            propagate_case: true
            word: true
          - trigger: "pirea"
            replace: "pírea"
            propagate_case: true
            word: true
          - trigger: "pirio"
            replace: "pírio"
            propagate_case: true
            word: true
          - trigger: "piroa"
            replace: "piroá"
            propagate_case: true
            word: true
          - trigger: "pirua"
            replace: "piruá"
            propagate_case: true
            word: true
          - trigger: "pisao"
            replace: "pisão"
            propagate_case: true
            word: true
          - trigger: "piseo"
            replace: "píseo"
            propagate_case: true
            word: true
          - trigger: "pitao"
            replace: "pitão"
            propagate_case: true
            word: true
          - trigger: "pitem"
            replace: "pitém"
            propagate_case: true
            word: true
          - trigger: "piteu"
            replace: "pitéu"
            propagate_case: true
            word: true
          - trigger: "pitia"
            replace: "pitiá"
            propagate_case: true
            word: true
          - trigger: "pitio"
            replace: "pítio"
            propagate_case: true
            word: true
          - trigger: "pitis"
            replace: "pítis"
            propagate_case: true
            word: true
          - trigger: "pitiu"
            replace: "pitiú"
            propagate_case: true
            word: true
          - trigger: "piton"
            replace: "píton"
            propagate_case: true
            word: true
          - trigger: "pitua"
            replace: "pituá"
            propagate_case: true
            word: true
          - trigger: "pitui"
            replace: "pituí"
            propagate_case: true
            word: true
          - trigger: "piuba"
            replace: "piúba"
            propagate_case: true
            word: true
          - trigger: "piuca"
            replace: "piúca"
            propagate_case: true
            word: true
          - trigger: "piugo"
            replace: "piúgo"
            propagate_case: true
            word: true
          - trigger: "piuma"
            replace: "piúma"
            propagate_case: true
            word: true
          - trigger: "piuna"
            replace: "piúna"
            propagate_case: true
            word: true
          - trigger: "piuva"
            replace: "piúva"
            propagate_case: true
            word: true
          - trigger: "pixeu"
            replace: "pixéu"
            propagate_case: true
            word: true
          - trigger: "pixis"
            replace: "píxis"
            propagate_case: true
            word: true
          - trigger: "pixua"
            replace: "pixuá"
            propagate_case: true
            word: true
          - trigger: "place"
            replace: "placê"
            propagate_case: true
            word: true
          - trigger: "pleon"
            replace: "pléon"
            propagate_case: true
            word: true
          - trigger: "poacu"
            replace: "poaçu"
            propagate_case: true
            word: true
          - trigger: "pocal"
            replace: "poçal"
            propagate_case: true
            word: true
          - trigger: "pocao"
            replace: "poção"
            propagate_case: true
            word: true
          - trigger: "podao"
            replace: "podão"
            propagate_case: true
            word: true
          - trigger: "podex"
            replace: "pódex"
            propagate_case: true
            word: true
          - trigger: "podio"
            replace: "pódio"
            propagate_case: true
            word: true
          - trigger: "podoi"
            replace: "podói"
            propagate_case: true
            word: true
          - trigger: "podon"
            replace: "pódon"
            propagate_case: true
            word: true
          - trigger: "pogea"
            replace: "pógea"
            propagate_case: true
            word: true
          - trigger: "poica"
            replace: "poiçá"
            propagate_case: true
            word: true
          - trigger: "polao"
            replace: "polão"
            propagate_case: true
            word: true
          - trigger: "polen"
            replace: "pólen"
            propagate_case: true
            word: true
          - trigger: "polex"
            replace: "pólex"
            propagate_case: true
            word: true
          - trigger: "polis"
            replace: "pólis"
            propagate_case: true
            word: true
          - trigger: "polux"
            replace: "pólux"
            propagate_case: true
            word: true
          - trigger: "ponca"
            replace: "poncã"
            propagate_case: true
            word: true
          - trigger: "ponco"
            replace: "poncó"
            propagate_case: true
            word: true
          - trigger: "ponei"
            replace: "pônei"
            propagate_case: true
            word: true
          - trigger: "pongo"
            replace: "pongó"
            propagate_case: true
            word: true
          - trigger: "ponje"
            replace: "ponjê"
            propagate_case: true
            word: true
          - trigger: "popao"
            replace: "popão"
            propagate_case: true
            word: true
          - trigger: "popia"
            replace: "popiã"
            propagate_case: true
            word: true
          - trigger: "porem"
            replace: "porém"
            propagate_case: true
            word: true
          - trigger: "porio"
            replace: "pório"
            propagate_case: true
            word: true
          - trigger: "potao"
            replace: "potão"
            propagate_case: true
            word: true
          - trigger: "potea"
            replace: "pótea"
            propagate_case: true
            word: true
          - trigger: "potia"
            replace: "pótia"
            propagate_case: true
            word: true
          - trigger: "povao"
            replace: "povão"
            propagate_case: true
            word: true
          - trigger: "povoa"
            replace: "póvoa"
            propagate_case: true
            word: true
          - trigger: "praca"
            replace: "praça"
            propagate_case: true
            word: true
          - trigger: "praja"
            replace: "prajá"
            propagate_case: true
            word: true
          - trigger: "preco"
            replace: "preço"
            propagate_case: true
            word: true
          - trigger: "preon"
            replace: "préon"
            propagate_case: true
            word: true
          - trigger: "priao"
            replace: "prião"
            propagate_case: true
            word: true
          - trigger: "prion"
            replace: "príon"
            propagate_case: true
            word: true
          - trigger: "privo"
            replace: "privó"
            propagate_case: true
            word: true
          - trigger: "proca"
            replace: "procá"
            propagate_case: true
            word: true
          - trigger: "puaco"
            replace: "puaço"
            propagate_case: true
            word: true
          - trigger: "puacu"
            replace: "puaçu"
            propagate_case: true
            word: true
          - trigger: "pubis"
            replace: "púbis"
            propagate_case: true
            word: true
          - trigger: "pucto"
            replace: "puctó"
            propagate_case: true
            word: true
          - trigger: "pugil"
            replace: "púgil"
            propagate_case: true
            word: true
          - trigger: "puita"
            replace: "puíta"
            propagate_case: true
            word: true
          - trigger: "pulao"
            replace: "pulão"
            propagate_case: true
            word: true
          - trigger: "pulex"
            replace: "púlex"
            propagate_case: true
            word: true
          - trigger: "punde"
            replace: "pundé"
            propagate_case: true
            word: true
          - trigger: "purui"
            replace: "puruí"
            propagate_case: true
            word: true
          - trigger: "puvia"
            replace: "puviá"
            propagate_case: true
            word: true
          - trigger: "puxao"
            replace: "puxão"
            propagate_case: true
            word: true
          - trigger: "quale"
            replace: "qualé"
            propagate_case: true
            word: true
          - trigger: "quali"
            replace: "quáli"
            propagate_case: true
            word: true
          - trigger: "quaro"
            replace: "quaró"
            propagate_case: true
            word: true
          - trigger: "quata"
            replace: "quatá"
            propagate_case: true
            word: true
          - trigger: "quece"
            replace: "quecé"
            propagate_case: true
            word: true
          - trigger: "quede"
            replace: "quedê"
            propagate_case: true
            word: true
          - trigger: "quele"
            replace: "quelé"
            propagate_case: true
            word: true
          - trigger: "quepi"
            replace: "quépi"
            propagate_case: true
            word: true
          - trigger: "quica"
            replace: "quiçá"
            propagate_case: true
            word: true
          - trigger: "quice"
            replace: "quicé"
            propagate_case: true
            word: true
          - trigger: "quico"
            replace: "quicó"
            propagate_case: true
            word: true
          - trigger: "quipa"
            replace: "quipã"
            propagate_case: true
            word: true
          - trigger: "quipe"
            replace: "quipé"
            propagate_case: true
            word: true
          - trigger: "quito"
            replace: "quitó"
            propagate_case: true
            word: true
          - trigger: "quiui"
            replace: "quiuí"
            propagate_case: true
            word: true
          - trigger: "quixo"
            replace: "quixó"
            propagate_case: true
            word: true
          - trigger: "rabao"
            replace: "rábão"
            propagate_case: true
            word: true
          - trigger: "rabia"
            replace: "rábia"
            propagate_case: true
            word: true
          - trigger: "racao"
            replace: "ração"
            propagate_case: true
            word: true
          - trigger: "racau"
            replace: "racaú"
            propagate_case: true
            word: true
          - trigger: "racio"
            replace: "rácio"
            propagate_case: true
            word: true
          - trigger: "racor"
            replace: "raçor"
            propagate_case: true
            word: true
          - trigger: "radao"
            replace: "radão"
            propagate_case: true
            word: true
          - trigger: "radio"
            replace: "rádio"
            propagate_case: true
            word: true
          - trigger: "radom"
            replace: "rádom"
            propagate_case: true
            word: true
          - trigger: "radon"
            replace: "rádon"
            propagate_case: true
            word: true
          - trigger: "rafia"
            replace: "ráfia"
            propagate_case: true
            word: true
          - trigger: "ragio"
            replace: "rágio"
            propagate_case: true
            word: true
          - trigger: "ragla"
            replace: "raglã"
            propagate_case: true
            word: true
          - trigger: "raiao"
            replace: "raião"
            propagate_case: true
            word: true
          - trigger: "raita"
            replace: "raíta"
            propagate_case: true
            word: true
          - trigger: "raivo"
            replace: "raivó"
            propagate_case: true
            word: true
          - trigger: "rajao"
            replace: "rajão"
            propagate_case: true
            word: true
          - trigger: "ralao"
            replace: "ralão"
            propagate_case: true
            word: true
          - trigger: "ramao"
            replace: "ramão"
            propagate_case: true
            word: true
          - trigger: "rameo"
            replace: "râmeo"
            propagate_case: true
            word: true
          - trigger: "rapao"
            replace: "rapão"
            propagate_case: true
            word: true
          - trigger: "rapia"
            replace: "rápia"
            propagate_case: true
            word: true
          - trigger: "raqui"
            replace: "ráqui"
            propagate_case: true
            word: true
          - trigger: "rasao"
            replace: "rasão"
            propagate_case: true
            word: true
          - trigger: "ratao"
            replace: "ratão"
            propagate_case: true
            word: true
          - trigger: "ratus"
            replace: "rátus"
            propagate_case: true
            word: true
          - trigger: "razao"
            replace: "razão"
            propagate_case: true
            word: true
          - trigger: "rebem"
            replace: "rebém"
            propagate_case: true
            word: true
          - trigger: "rebus"
            replace: "rébus"
            propagate_case: true
            word: true
          - trigger: "recao"
            replace: "recão"
            propagate_case: true
            word: true
          - trigger: "recem"
            replace: "recém"
            propagate_case: true
            word: true
          - trigger: "recho"
            replace: "rechô"
            propagate_case: true
            word: true
          - trigger: "recio"
            replace: "récio"
            propagate_case: true
            word: true
          - trigger: "recua"
            replace: "récua"
            propagate_case: true
            word: true
          - trigger: "redea"
            replace: "rédea"
            propagate_case: true
            word: true
          - trigger: "redem"
            replace: "redém"
            propagate_case: true
            word: true
          - trigger: "redia"
            replace: "rédia"
            propagate_case: true
            word: true
          - trigger: "refem"
            replace: "refém"
            propagate_case: true
            word: true
          - trigger: "regao"
            replace: "regão"
            propagate_case: true
            word: true
          - trigger: "regie"
            replace: "régie"
            propagate_case: true
            word: true
          - trigger: "regio"
            replace: "régio"
            propagate_case: true
            word: true
          - trigger: "regua"
            replace: "régua"
            propagate_case: true
            word: true
          - trigger: "reina"
            replace: "reína"
            propagate_case: true
            word: true
          - trigger: "reivo"
            replace: "reivó"
            propagate_case: true
            word: true
          - trigger: "rejao"
            replace: "rejão"
            propagate_case: true
            word: true
          - trigger: "renio"
            replace: "rênio"
            propagate_case: true
            word: true
          - trigger: "repia"
            replace: "répia"
            propagate_case: true
            word: true
          - trigger: "reriu"
            replace: "reriú"
            propagate_case: true
            word: true
          - trigger: "reuso"
            replace: "reúso"
            propagate_case: true
            word: true
          - trigger: "revem"
            replace: "revém"
            propagate_case: true
            word: true
          - trigger: "reves"
            replace: "revés"
            propagate_case: true
            word: true
          - trigger: "revoa"
            replace: "révoa"
            propagate_case: true
            word: true
          - trigger: "rexia"
            replace: "réxia"
            propagate_case: true
            word: true
          - trigger: "rezao"
            replace: "rezão"
            propagate_case: true
            word: true
          - trigger: "riade"
            replace: "ríade"
            propagate_case: true
            word: true
          - trigger: "ricao"
            replace: "ricão"
            propagate_case: true
            word: true
          - trigger: "ricar"
            replace: "riçar"
            propagate_case: true
            word: true
          - trigger: "ricio"
            replace: "rício"
            propagate_case: true
            word: true
          - trigger: "ricol"
            replace: "riçol"
            propagate_case: true
            word: true
          - trigger: "rifao"
            replace: "rifão"
            propagate_case: true
            word: true
          - trigger: "rigel"
            replace: "rígel"
            propagate_case: true
            word: true
          - trigger: "rigio"
            replace: "rígio"
            propagate_case: true
            word: true
          - trigger: "rijao"
            replace: "rijão"
            propagate_case: true
            word: true
          - trigger: "rimel"
            replace: "rímel"
            propagate_case: true
            word: true
          - trigger: "rinio"
            replace: "rínio"
            propagate_case: true
            word: true
          - trigger: "ripao"
            replace: "ripão"
            propagate_case: true
            word: true
          - trigger: "ripio"
            replace: "rípio"
            propagate_case: true
            word: true
          - trigger: "risao"
            replace: "risão"
            propagate_case: true
            word: true
          - trigger: "ritao"
            replace: "ritão"
            propagate_case: true
            word: true
          - trigger: "ritio"
            replace: "rítio"
            propagate_case: true
            word: true
          - trigger: "riton"
            replace: "ríton"
            propagate_case: true
            word: true
          - trigger: "riuta"
            replace: "riúta"
            propagate_case: true
            word: true
          - trigger: "rivea"
            replace: "rívea"
            propagate_case: true
            word: true
          - trigger: "robao"
            replace: "robão"
            propagate_case: true
            word: true
          - trigger: "rober"
            replace: "róber"
            propagate_case: true
            word: true
          - trigger: "robia"
            replace: "róbia"
            propagate_case: true
            word: true
          - trigger: "robor"
            replace: "róbor"
            propagate_case: true
            word: true
          - trigger: "robur"
            replace: "róbur"
            propagate_case: true
            word: true
          - trigger: "rocao"
            replace: "rocão"
            propagate_case: true
            word: true
          - trigger: "rocio"
            replace: "rócio"
            propagate_case: true
            word: true
          - trigger: "roclo"
            replace: "rocló"
            propagate_case: true
            word: true
          - trigger: "rodao"
            replace: "ródão"
            propagate_case: true
            word: true
          - trigger: "rodeo"
            replace: "ródeo"
            propagate_case: true
            word: true
          - trigger: "rodio"
            replace: "ródio"
            propagate_case: true
            word: true
          - trigger: "roger"
            replace: "róger"
            propagate_case: true
            word: true
          - trigger: "rojao"
            replace: "rojão"
            propagate_case: true
            word: true
          - trigger: "rolao"
            replace: "rolão"
            propagate_case: true
            word: true
          - trigger: "romao"
            replace: "romão"
            propagate_case: true
            word: true
          - trigger: "ronco"
            replace: "roncó"
            propagate_case: true
            word: true
          - trigger: "ronde"
            replace: "rondé"
            propagate_case: true
            word: true
          - trigger: "rondo"
            replace: "rondó"
            propagate_case: true
            word: true
          - trigger: "ronei"
            replace: "rônei"
            propagate_case: true
            word: true
          - trigger: "rongo"
            replace: "rongó"
            propagate_case: true
            word: true
          - trigger: "ronto"
            replace: "rontó"
            propagate_case: true
            word: true
          - trigger: "ropia"
            replace: "rópia"
            propagate_case: true
            word: true
          - trigger: "rosao"
            replace: "rosão"
            propagate_case: true
            word: true
          - trigger: "roseo"
            replace: "róseo"
            propagate_case: true
            word: true
          - trigger: "rosio"
            replace: "rósio"
            propagate_case: true
            word: true
          - trigger: "rotia"
            replace: "rótia"
            propagate_case: true
            word: true
          - trigger: "ruaca"
            replace: "ruaça"
            propagate_case: true
            word: true
          - trigger: "rubao"
            replace: "rubão"
            propagate_case: true
            word: true
          - trigger: "rubeo"
            replace: "rúbeo"
            propagate_case: true
            word: true
          - trigger: "rubio"
            replace: "rúbio"
            propagate_case: true
            word: true
          - trigger: "rucar"
            replace: "ruçar"
            propagate_case: true
            word: true
          - trigger: "rudao"
            replace: "rudão"
            propagate_case: true
            word: true
          - trigger: "rufao"
            replace: "rufão"
            propagate_case: true
            word: true
          - trigger: "rufio"
            replace: "rúfio"
            propagate_case: true
            word: true
          - trigger: "rugbi"
            replace: "rúgbi"
            propagate_case: true
            word: true
          - trigger: "rugio"
            replace: "rúgio"
            propagate_case: true
            word: true
          - trigger: "ruina"
            replace: "ruína"
            propagate_case: true
            word: true
          - trigger: "rumen"
            replace: "rúmen"
            propagate_case: true
            word: true
          - trigger: "rumex"
            replace: "rúmex"
            propagate_case: true
            word: true
          - trigger: "runco"
            replace: "runcó"
            propagate_case: true
            word: true
          - trigger: "runga"
            replace: "rungã"
            propagate_case: true
            word: true
          - trigger: "runle"
            replace: "runlé"
            propagate_case: true
            word: true
          - trigger: "runto"
            replace: "runtó"
            propagate_case: true
            word: true
          - trigger: "rutea"
            replace: "rútea"
            propagate_case: true
            word: true
          - trigger: "sabao"
            replace: "sabão"
            propagate_case: true
            word: true
          - trigger: "sabia"
            replace: "sabiá"
            propagate_case: true
            word: true
          - trigger: "sabio"
            replace: "sábio"
            propagate_case: true
            word: true
          - trigger: "sabiu"
            replace: "sabiú"
            propagate_case: true
            word: true
          - trigger: "sacai"
            replace: "sacaí"
            propagate_case: true
            word: true
          - trigger: "sacao"
            replace: "sacão"
            propagate_case: true
            word: true
          - trigger: "sache"
            replace: "saché"
            propagate_case: true
            word: true
          - trigger: "sacue"
            replace: "sacuê"
            propagate_case: true
            word: true
          - trigger: "sadao"
            replace: "sadão"
            propagate_case: true
            word: true
          - trigger: "sadra"
            replace: "sadrá"
            propagate_case: true
            word: true
          - trigger: "safao"
            replace: "safão"
            propagate_case: true
            word: true
          - trigger: "safeo"
            replace: "sáfeo"
            propagate_case: true
            word: true
          - trigger: "sagio"
            replace: "ságio"
            propagate_case: true
            word: true
          - trigger: "sagua"
            replace: "saguá"
            propagate_case: true
            word: true
          - trigger: "saiao"
            replace: "saião"
            propagate_case: true
            word: true
          - trigger: "saico"
            replace: "saíco"
            propagate_case: true
            word: true
          - trigger: "saije"
            replace: "saijé"
            propagate_case: true
            word: true
          - trigger: "saine"
            replace: "sainé"
            propagate_case: true
            word: true
          - trigger: "saipe"
            replace: "saipé"
            propagate_case: true
            word: true
          - trigger: "saire"
            replace: "sairé"
            propagate_case: true
            word: true
          - trigger: "saita"
            replace: "saíta"
            propagate_case: true
            word: true
          - trigger: "saiva"
            replace: "saivá"
            propagate_case: true
            word: true
          - trigger: "saixe"
            replace: "saixé"
            propagate_case: true
            word: true
          - trigger: "salao"
            replace: "salão"
            propagate_case: true
            word: true
          - trigger: "salem"
            replace: "salém"
            propagate_case: true
            word: true
          - trigger: "salio"
            replace: "sálio"
            propagate_case: true
            word: true
          - trigger: "salix"
            replace: "sálix"
            propagate_case: true
            word: true
          - trigger: "saloa"
            replace: "saloá"
            propagate_case: true
            word: true
          - trigger: "samao"
            replace: "samão"
            propagate_case: true
            word: true
          - trigger: "samea"
            replace: "sâmea"
            propagate_case: true
            word: true
          - trigger: "samio"
            replace: "sâmio"
            propagate_case: true
            word: true
          - trigger: "sampe"
            replace: "sampé"
            propagate_case: true
            word: true
          - trigger: "sanca"
            replace: "sancã"
            propagate_case: true
            word: true
          - trigger: "sandi"
            replace: "sândi"
            propagate_case: true
            word: true
          - trigger: "sanie"
            replace: "sânie"
            propagate_case: true
            word: true
          - trigger: "sanio"
            replace: "sânio"
            propagate_case: true
            word: true
          - trigger: "sante"
            replace: "santé"
            propagate_case: true
            word: true
          - trigger: "sapao"
            replace: "sapão"
            propagate_case: true
            word: true
          - trigger: "sapio"
            replace: "sápio"
            propagate_case: true
            word: true
          - trigger: "sapua"
            replace: "sapuá"
            propagate_case: true
            word: true
          - trigger: "saque"
            replace: "saqué"
            propagate_case: true
            word: true
          - trigger: "sarao"
            replace: "sarão"
            propagate_case: true
            word: true
          - trigger: "sarne"
            replace: "sarné"
            propagate_case: true
            word: true
          - trigger: "saroe"
            replace: "saroé"
            propagate_case: true
            word: true
          - trigger: "sarta"
            replace: "sartã"
            propagate_case: true
            word: true
          - trigger: "sarua"
            replace: "saruá"
            propagate_case: true
            word: true
          - trigger: "sarue"
            replace: "saruê"
            propagate_case: true
            word: true
          - trigger: "sauba"
            replace: "saúba"
            propagate_case: true
            word: true
          - trigger: "sauco"
            replace: "saúco"
            propagate_case: true
            word: true
          - trigger: "sauia"
            replace: "sauiá"
            propagate_case: true
            word: true
          - trigger: "saupe"
            replace: "saupé"
            propagate_case: true
            word: true
          - trigger: "saura"
            replace: "saurá"
            propagate_case: true
            word: true
          - trigger: "sauva"
            replace: "saúva"
            propagate_case: true
            word: true
          - trigger: "savel"
            replace: "sável"
            propagate_case: true
            word: true
          - trigger: "savia"
            replace: "saviá"
            propagate_case: true
            word: true
          - trigger: "savio"
            replace: "sávio"
            propagate_case: true
            word: true
          - trigger: "saxao"
            replace: "saxão"
            propagate_case: true
            word: true
          - trigger: "saxeo"
            replace: "sáxeo"
            propagate_case: true
            word: true
          - trigger: "sayao"
            replace: "sayão"
            propagate_case: true
            word: true
          - trigger: "sazao"
            replace: "sazão"
            propagate_case: true
            word: true
          - trigger: "secao"
            replace: "seção"
            propagate_case: true
            word: true
          - trigger: "secio"
            replace: "sécio"
            propagate_case: true
            word: true
          - trigger: "secua"
            replace: "sécua"
            propagate_case: true
            word: true
          - trigger: "sedao"
            replace: "sedão"
            propagate_case: true
            word: true
          - trigger: "sedem"
            replace: "sedém"
            propagate_case: true
            word: true
          - trigger: "sedia"
            replace: "sédia"
            propagate_case: true
            word: true
          - trigger: "segao"
            replace: "segão"
            propagate_case: true
            word: true
          - trigger: "seica"
            replace: "seiça"
            propagate_case: true
            word: true
          - trigger: "selao"
            replace: "selão"
            propagate_case: true
            word: true
          - trigger: "selia"
            replace: "sélia"
            propagate_case: true
            word: true
          - trigger: "selio"
            replace: "sélio"
            propagate_case: true
            word: true
          - trigger: "sembe"
            replace: "sembê"
            propagate_case: true
            word: true
          - trigger: "semea"
            replace: "sêmea"
            propagate_case: true
            word: true
          - trigger: "semen"
            replace: "sêmen"
            propagate_case: true
            word: true
          - trigger: "semis"
            replace: "sêmis"
            propagate_case: true
            word: true
          - trigger: "senao"
            replace: "senão"
            propagate_case: true
            word: true
          - trigger: "senio"
            replace: "sênio"
            propagate_case: true
            word: true
          - trigger: "sepio"
            replace: "sépio"
            propagate_case: true
            word: true
          - trigger: "sequi"
            replace: "séqui"
            propagate_case: true
            word: true
          - trigger: "serie"
            replace: "série"
            propagate_case: true
            word: true
          - trigger: "serio"
            replace: "sério"
            propagate_case: true
            word: true
          - trigger: "seriu"
            replace: "seriú"
            propagate_case: true
            word: true
          - trigger: "serum"
            replace: "sérum"
            propagate_case: true
            word: true

  '';
}
