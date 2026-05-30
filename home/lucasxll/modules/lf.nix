# home/lucasxll/modules/lf.nix
#
# lf — gerenciador de arquivos TUI em Go, inspirado no ranger
# Documentação: https://pkg.go.dev/github.com/gokcehan/lf
#
# Além do lf, este módulo instala ferramentas CLI modernas:
#
#   bat      — cat com syntax highlighting e números de linha
#   eza      — ls moderno (ícones, git status, árvore)
#   fd       — find mais rápido e com sintaxe limpa
#   ripgrep  — grep ultrarrápido (usado pelo fzf e lf)
#   fzf      — fuzzy finder interativo universal
#   zoxide   — cd inteligente (aprende seus diretórios frequentes)
#   btop     — monitor de sistema (substitui htop)
#   dust     — du visual (mostra uso de disco com barras)
#   duf      — df moderno (visão colorida de partições)
#   tldr     — man simplificado com exemplos práticos
#   jq       — processador de JSON na linha de comando
#   delta    — diff colorido para git
#   lazygit  — TUI para git (equivalente ao gitk mas no terminal)
#   ncdu     — navegador interativo de uso de disco

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # ── Gerenciador de arquivos ─────────────────────────────────
    lf

    # ── Visualizadores (usados pelo previewer do lf) ─────────────
    bat             # preview de texto com highlight
    ueberzugpp      # preview de imagens dentro do terminal

    # ── Ferramentas de busca ─────────────────────────────────────
    fd              # find moderno
    ripgrep         # grep ultrarrápido
    fzf             # fuzzy finder

    # ── Navegação inteligente ────────────────────────────────────
    zoxide          # cd com memória de frequência

    # ── Listagem de arquivos ─────────────────────────────────────
    eza             # ls moderno com ícones e git status

    # ── Monitoramento ────────────────────────────────────────────
    btop            # monitor de sistema (CPU, RAM, rede, disco)

    # ── Disco ────────────────────────────────────────────────────
    dust            # du visual
    duf             # df colorido
    ncdu            # navegador interativo de disco

    # ── Documentação ─────────────────────────────────────────────
    tldr            # man com exemplos práticos

    # ── Dados estruturados ───────────────────────────────────────
    jq              # JSON na linha de comando
    yq-go           # YAML/JSON/TOML na linha de comando

    # ── Git ──────────────────────────────────────────────────────
    delta           # diff colorido
    lazygit         # TUI para git

    # ── Extras úteis ─────────────────────────────────────────────
    tokei           # contagem de linhas de código por linguagem
    glow            # renderiza Markdown no terminal
    xh              # cliente HTTP moderno (curl mais amigável)
    trashy          # trash-cli: move para lixeira em vez de rm
  ];

  # ══════════════════════════════════════════════════════════════
  # LF — configuração principal
  # ══════════════════════════════════════════════════════════════
  xdg.configFile."lf/lfrc".text = ''
    # ── OPÇÕES GERAIS ─────────────────────────────────────────────
    set hidden true          # mostrar arquivos ocultos por padrão
    set icons true           # ícones NerdFont
    set drawbox true         # bordas nos painéis
    set incsearch true       # busca incremental ao digitar
    set smartcase true       # case-insensitive a menos que use maiúscula
    set ignorecase true      # listagem case-insensitive
    set preview true         # painel de preview à direita
    set previewer ~/.config/lf/previewer.sh
    set cleaner   ~/.config/lf/cleaner.sh
    set ratios 1:2:3         # proporção dos 3 painéis
    set scrolloff 5          # linhas de margem ao rolar
    set shell sh
    set shellopts '-eu'
    set ifs "\n"
    set filesep "\n"

    # ── ATALHOS — navegação ───────────────────────────────────────
    map h updir              # voltar (igual ao ranger/vim)
    map l open               # entrar / abrir
    map . set hidden!        # toggle arquivos ocultos
    map <esc> quit
    map q quit

    # ── ATALHOS — operações ───────────────────────────────────────
    map dd cut
    map yy copy
    map pp paste
    map <delete> delete
    map R rename
    map r push :rename<space>

    # Criar arquivo ou diretório
    map mf push $touch<space>
    map md push $mkdir<space>-p<space>

    # Abrir com o app padrão do sistema
    map o &xdg-open "$f"

    # Extrair arquivo comprimido
    map ex :extract

    # Selecionar todos
    map <a-a> :glob-select *
    map <a-A> :glob-unselect *

    # Pesquisa fuzzy (fzf) a partir do diretório atual
    map <c-f> ''${{
        res="$(fd --hidden --follow --exclude .git 2>/dev/null | fzf --preview 'bat --color=always --line-range :50 {}' 2>/dev/null)"
        [ -n "$res" ] && lf -remote "send $id select \"$res\""
    }}

    # ── COMANDOS ──────────────────────────────────────────────────
    cmd open &{{
        case $(file --mime-type -Lb "$f") in
            text/*|application/json|application/xml|inode/x-empty)
                lf -remote "send $id \$\${EDITOR:-vim} \"\$f\""
                ;;
            *)
                xdg-open "$f" >/dev/null 2>&1
                ;;
        esac
    }}

    cmd delete ''${{
        set -f
        printf "%s\n" "$fx"
        printf "Deletar permanentemente? [s/N] "
        read ans
        [ "$ans" = "s" ] && rm -rf -- $fx
    }}

    cmd trash ''${{
        set -f
        trashy "$fx"
    }}
    map <delete> trash
    map D delete

    cmd extract ''${{
        set -f
        case "$f" in
            *.tar.bz2|*.tbz2) tar xjf "$f" ;;
            *.tar.gz|*.tgz)   tar xzf "$f" ;;
            *.tar.xz)         tar xJf "$f" ;;
            *.tar.zst)        tar --zstd -xf "$f" ;;
            *.tar)            tar xf "$f" ;;
            *.zip)            unzip "$f" ;;
            *.7z)             7z x "$f" ;;
            *.rar)            unrar x "$f" ;;
            *)                echo "Formato não suportado: $f" ;;
        esac
    }}

    # ── GIT STATUS na barra de título ────────────────────────────
    cmd on-cd &{{
        git_branch=$(git branch --show-current 2>/dev/null)
        if [ -n "$git_branch" ]; then
            git_status=$(git status --porcelain 2>/dev/null | wc -l)
            [ "$git_status" -gt 0 ] && dirty=" *" || dirty=""
            lf -remote "send $id set promptfmt \"\\033[32;1m%u@%h\\033[0m:\\033[34;1m%d\\033[0m [git:$git_branch$dirty] \$f\""
        fi
    }}
    on-cd
  '';

  # Previewer: usa bat para texto, ueberzugpp para imagens
  xdg.configFile."lf/previewer.sh" = {
    executable = true;
    text = ''
      #!/bin/sh
      file=$1
      w=$2
      h=$3

      mimetype=$(file --mime-type -Lb "$file")

      case "$mimetype" in
          text/*|application/json|application/xml|application/javascript)
              bat \
                  --color=always \
                  --style=numbers,changes \
                  --line-range=:200 \
                  --theme="TwoDark" \
                  "$file" 2>/dev/null || cat "$file"
              ;;
          application/pdf)
              pdftotext -l 3 "$file" - 2>/dev/null \
                  | head -80 \
                  || echo "[PDF — instale poppler para preview]"
              ;;
          image/*)
              chafa \
                  --format symbols \
                  --size "$w"x"$h" \
                  "$file" 2>/dev/null \
                  || echo "[Imagem: $file]"
              ;;
          video/*)
              echo "[Vídeo]"
              ffprobe -v quiet -show_format -show_streams "$file" 2>/dev/null \
                  | grep -E "^(filename|duration|bit_rate|codec_name|width|height)" \
                  | head -10
              ;;
          audio/*)
              ffprobe -v quiet -show_format "$file" 2>/dev/null \
                  | grep -E "^(filename|duration|bit_rate|TAG)" \
                  | head -10
              ;;
          application/zip|application/x-tar|application/x-7z-compressed)
              case "$file" in
                  *.zip) unzip -l "$file" 2>/dev/null | head -40 ;;
                  *.tar*|*.tgz|*.tbz2) tar tf "$file" 2>/dev/null | head -40 ;;
                  *.7z) 7z l "$file" 2>/dev/null | head -40 ;;
                  *) echo "$mimetype" ;;
              esac
              ;;
          *)
              file --brief "$file"
              echo ""
              head -20 "$file" 2>/dev/null
              ;;
      esac
    '';
  };

  xdg.configFile."lf/cleaner.sh" = {
    executable = true;
    text = ''
      #!/bin/sh
      # Limpa o preview de imagens se ueberzugpp estiver em uso
      [ -n "$UB_SOCKET" ] && ueberzugpp cmd -s "$UB_SOCKET" -a remove -i preview 2>/dev/null
      exit 0
    '';
  };

  # ══════════════════════════════════════════════════════════════
  # INTEGRAÇÕES NO ZSH
  # ══════════════════════════════════════════════════════════════
  programs.zsh = {
    initContent = ''
      # ── zoxide (cd inteligente) ─────────────────────────────────
      # z <query>  → vai para o diretório mais frequente que bate
      # zi <query> → escolhe com fzf interativo
      eval "$(zoxide init zsh)"

      # ── fzf (fuzzy finder) ──────────────────────────────────────
      # Ctrl+R → histórico fuzzy
      # Ctrl+T → arquivos fuzzy
      # Alt+C  → diretórios fuzzy
      source ${pkgs.fzf}/share/fzf/completion.zsh   2>/dev/null || true
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh 2>/dev/null || true
      export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude .git"
      export FZF_DEFAULT_OPTS="
        --color=bg+:#1a1b26,bg:#16161e,spinner:#73daca,hl:#bb9af7
        --color=fg:#c0caf5,header:#7dcfff,info:#7aa2f7,pointer:#73daca
        --color=marker:#73daca,fg+:#c0caf5,prompt:#7aa2f7,hl+:#bb9af7
        --height 50% --border rounded --prompt '❯ '
      "

      # ── delta (diff melhorado para git) ─────────────────────────
      export GIT_PAGER="delta"
    '';

    shellAliases = {
      # lf
      "lf" = "lf";
      "lfcd" = ''cd "$(command lf -print-last-dir)"'';  # sai do lf no último dir

      # eza (ls moderno)
      "ls"  = "eza --icons --group-directories-first";
      "ll"  = "eza -la --icons --group-directories-first --git";
      "la"  = "eza -a --icons --group-directories-first";
      "lt"  = "eza --tree --icons --level=2";
      "llt" = "eza -la --tree --icons --level=2 --git";

      # bat (cat melhorado)
      "cat" = "bat --style=plain";
      "less" = "bat --style=full --paging=always";

      # Ferramentas modernas
      "top"  = "btop";
      "df"   = "duf";
      "du"   = "dust";
      "grep" = "rg";
      "find" = "fd";
      "curl" = "xh";

      # Git
      "lg"  = "lazygit";
      "gd"  = "git diff | delta";
    };
  };
}
