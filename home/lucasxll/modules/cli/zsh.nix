# home/lucasxll/modules/zsh.nix
#
# Shell zsh com:
#   - oh-my-zsh: plugins de produtividade (SEM tema — Starship assume o prompt)
#   - Starship: prompt rápido e informativo (git, nix-shell, linguagem do projeto)
#
# Por que trocar robbyrussell → Starship:
#   • Robbyrussell é estático — não mostra contexto Nix, linguagem, hora
#   • Starship é escrito em Rust — carrega ~10x mais rápido que temas oh-my-zsh
#   • Mostra automaticamente: branch git + status, contexto nix-shell/devShell,
#     linguagem do projeto (Python, Node, Rust...), último exit code, duração cmd
#   • Stylix gerencia as cores via stylix.targets.starship — consistência total

{ ... }:

{
  programs.zsh = {
    enable                    = true;
    autosuggestion.enable     = true;
    syntaxHighlighting.enable = true;
    enableCompletion          = true;
    oh-my-zsh = {
      enable  = true;
      # theme = "" → desativa o prompt do oh-my-zsh; Starship assume o PS1
      theme   = "";
      plugins = [ "git" "docker" "sudo" "history" ];
    };
    shellAliases = {
      # Rebuild rápido — pode rodar de qualquer pasta
      rebuild      = "cd /etc/nixos && sudo git add . && sudo nixos-rebuild switch --flake .#nixos";
      rebuild-test = "cd /etc/nixos && sudo git add . && sudo nixos-rebuild test --flake .#nixos";
      rebuild-dry  = "cd /etc/nixos && sudo git add . && sudo nixos-rebuild dry-activate --flake .#nixos";

      # Git do nixos de qualquer lugar
      nixgit = "git -C /etc/nixos";

      # Gerenciadores de arquivo
      f  = "yazi";
      fm = "dolphin . &";

      # Tela espelhada
      flip-x     = ''xrandr --output "$(xrandr | awk '/ connected/{print $1; exit}')" --reflect x'';
      flip-reset = ''xrandr --output "$(xrandr | awk '/ connected/{print $1; exit}')" --reflect normal'';

      # ── Git visual ────────────────────────────────────────────
      lg = "lazygit";

      # ── HTTP / API testing ────────────────────────────────────
      http = "curlie";   # curlie GET https://api.exemplo.com
      ws   = "websocat"; # websocat ws://localhost:8080

      # ── JSON / dados ──────────────────────────────────────────
      json = "fx";       # explorar JSON interativo: cat data.json | fx

      # ── Rust/WASM dev loop ────────────────────────────────────
      wbuild = "wasm-pack build --target web --out-dir pkg";
      wserve = "python3 -m http.server 8080";
      wwatch = ''cargo watch -s "wasm-pack build --target web"'';
      wclean = "rm -rf pkg/ target/wasm32-unknown-unknown/";

      # ARMADILHA 7 (CORRIGIDA): rustup target não persiste entre instalações.
      # Rode uma vez por usuário/instalação nova: wasm-setup
      # Também atualiza para o latest stable (atualmente 1.95.0).
      wasm-setup = "rustup update stable && rustup default stable && rustup target add wasm32-unknown-unknown";

      # ── Cargo extras ──────────────────────────────────────────
      audit  = "cargo audit";
      expand = "cargo expand";
      ntest  = "cargo nextest run";
      flame  = "cargo flamegraph";

      # ── Erros compactos para análise por IA ──────────────────
      # cb    → build com mensagens curtas (sem unicode boxes, sem hints)
      # cbr   → igual + RUST_BACKTRACE para runtime debug
      # cerr  → filtra só linhas de erro do cargo (ideal para colar no Claude)
      # cw    → clippy compacto
      cb   = "cargo build --message-format=short 2>&1";
      cbr  = "RUST_LOG=debug RUST_BACKTRACE=1 cargo run 2>&1";
      cerr = ''cargo build 2>&1 | grep -E "^error(\[|:)" | head -40'';
      cw   = "cargo clippy --message-format=short 2>&1 | grep -E \"^error|^warning\" | head -60";

      # ── Deploy ────────────────────────────────────────────────
      fly    = "flyctl";

      # ── Terminal tools ────────────────────────────────────────
      top    = "btop";
      find   = "fd";
      grep   = "rg";
      du     = "dust";
      bench  = "hyperfine";
      lc     = "tokei";

      # ── Docker ────────────────────────────────────────────────
      lzd    = "lazydocker";

      # ── npm/npx rápido ────────────────────────────────────────
      serve = "npx serve .";
    };
  };

  # ── Starship — prompt moderno ──────────────────────────────────
  # enableZshIntegration = true por padrão quando programs.zsh.enable = true
  programs.starship = {
    enable = true;
    settings = {
      # Linha em branco antes do prompt — respira melhor com outputs longos
      add_newline = true;

      # Formato da linha (esquerda): só o cursor — da Vinci layout
      # Todo o contexto âncora na DIREITA via right_format
      format = "$line_break$character";

      # Formato da DIREITA: contexto lido da direita para a esquerda
      # Nix → dir → git → lang → duração — como da Vinci escrevia
      right_format = "$cmd_duration$rust$lua$nodejs$python$git_status$git_branch$directory$nix_shell";

      character = {
        success_symbol = "[❯](bold #7aa2f7)";
        error_symbol   = "[❯](bold #f7768e)";
        vimcmd_symbol  = "[❮](bold #9ece6a)";
      };

      directory = {
        style              = "bold #7aa2f7";
        truncation_length  = 4;
        truncate_to_repo   = true;
        read_only          = " 󰌾";
      };

      git_branch = {
        symbol = " ";
        style  = "bold #bb9af7";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };

      git_status = {
        style     = "#f7768e";
        format    = "([$all_status$ahead_behind]($style) )";
        ahead     = "⇡$count";
        behind    = "⇣$count";
        diverged  = "⇕⇡$ahead_count⇣$behind_count";
        modified  = "!$count";
        untracked = "?$count";
        staged    = "+$count";
        deleted   = "✘$count";
      };

      # Nix shell — importantíssimo para workflow NixOS
      nix_shell = {
        symbol  = " ";
        style   = "bold #73daca";
        format  = "[$symbol$state( \\($name\\))]($style) ";
        # Mostra mesmo fora de nix-shell se estiver num devShell
        impure_msg    = "[impure](bold #e0af68)";
        pure_msg      = "[pure](bold #9ece6a)";
        unknown_msg   = "[unknown](bold #ff9e64)";
      };

      python = {
        symbol = " ";
        style  = "#e0af68";
        format = "[$symbol$version( \\($virtualenv\\))]($style) ";
      };

      nodejs = {
        symbol = " ";
        style  = "#9ece6a";
      };

      rust = {
        symbol = " ";
        style  = "#ff9e64";
      };

      lua = {
        symbol = " ";
        style  = "#7aa2f7";
      };

      cmd_duration = {
        min_time = 2000;  # só mostra se demorou >2s
        style    = "bold #565f89";
        format   = "[ $duration]($style) ";
      };
    };
  };

  # ── Zoxide — cd inteligente ─────────────────────────────────────
  # `z foo`   → salta para o dir mais frequente que contém "foo"
  # `zi`      → picker interativo com fzf
  # `z -`     → volta para o diretório anterior
  # O histórico fica em ~/.local/share/zoxide/db.zo
  programs.zoxide = {
    enable               = true;
    enableZshIntegration = true;
    # Mantém `cd` funcionando normalmente — zoxide fica em `z` e `zi`.
    # Se quiser que `cd` também use zoxide, mude para: options = [ "--cmd cd" ];
    options = [];
  };

  programs.zsh.initContent = ''
    # ── Criar projeto Rust a partir dos templates ────────────────────
    # Uso: new-native meu-backend   → cria ~/projetos/meu-backend
    #      new-wasm   meu-frontend  → cria ~/projetos/meu-frontend
    _rust_new() {
      local template="$1" name="$2"
      if [[ -z "$name" ]]; then
        echo "uso: ''${template/rust-/new-} <nome-do-projeto>"
        return 1
      fi
      local dest="$HOME/projetos/$name"
      if [[ -d "$dest" ]]; then
        echo "❌ já existe: $dest"
        return 1
      fi
      mkdir -p "$HOME/projetos"
      cp -r "/etc/nixos/templates/$template" "$dest"
      sed -i "s/name *= *\"meu-projeto\"/name = \"$name\"/" "$dest/Cargo.toml"
      cd "$dest"
      git init -q
      git add .
      echo "✅ $dest"
      echo "   template : $template"
      echo "   toolchain: $(rustup show active-toolchain 2>/dev/null || echo 'ver rust-toolchain.toml')"
    }
    new-native() { _rust_new "rust-native-project" "$1"; }
    new-wasm()   { _rust_new "rust-wasm-project"   "$1"; }

    # ── Prompt sempre ancorado no fundo da janela ───────────────────
    # Imprime $LINES linhas em branco antes de cada prompt —
    # o output sobe, o cursor sempre aparece na base da tela.
    _prompt_at_bottom() {
      printf '\n%.0s' $(seq 1 $(( LINES / 4 )))
    }
    precmd_functions+=(_prompt_at_bottom)
  '';
}
