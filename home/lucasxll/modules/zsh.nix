# home/lucasxll/modules/zsh.nix

{ ... }:

{
  programs.zsh = {
    enable                    = true;
    autosuggestion.enable     = true;
    syntaxHighlighting.enable = true;
    enableCompletion          = true;
    oh-my-zsh = {
      enable  = true;
      theme   = "";  # Starship assume o PS1
      plugins = [ "git" "docker" "sudo" "history" ];
    };
    shellAliases = {
      rebuild      = "cd /etc/nixos && sudo git add . && sudo nixos-rebuild switch --flake .#nixos";
      rebuild-test = "cd /etc/nixos && sudo git add . && sudo nixos-rebuild test --flake .#nixos";
      rebuild-dry  = "cd /etc/nixos && sudo git add . && sudo nixos-rebuild dry-activate --flake .#nixos";

      nixgit = "git -C /etc/nixos";

      f  = "yazi";
      fm = "dolphin . &";

      flip-x     = ''xrandr --output "$(xrandr | awk '/ connected/{print $1; exit}')" --reflect x'';
      flip-reset = ''xrandr --output "$(xrandr | awk '/ connected/{print $1; exit}')" --reflect normal'';

      lg  = "lazygit";
      http = "curlie";
      ws   = "websocat";
      json = "fx";

      wbuild = "wasm-pack build --target web --out-dir pkg";
      wserve = "python3 -m http.server 8080";
      wwatch = ''cargo watch -s "wasm-pack build --target web"'';
      wclean = "rm -rf pkg/ target/wasm32-unknown-unknown/";
      # Rode wasm-setup uma vez por instalação nova para adicionar o target wasm32
      wasm-setup = "rustup update stable && rustup default stable && rustup target add wasm32-unknown-unknown";

      audit  = "cargo audit";
      expand = "cargo expand";
      ntest  = "cargo nextest run";
      flame  = "cargo flamegraph";

      # Saída compacta para análise por IA
      cb   = "cargo build --message-format=short 2>&1";
      cbr  = "RUST_LOG=debug RUST_BACKTRACE=1 cargo run 2>&1";
      cerr = ''cargo build 2>&1 | grep -E "^error(\[|:)" | head -40'';
      cw   = "cargo clippy --message-format=short 2>&1 | grep -E \"^error|^warning\" | head -60";

      fly    = "flyctl";
      top    = "btop";
      find   = "fd";
      grep   = "rg";
      du     = "dust";
      bench  = "hyperfine";
      lc     = "tokei";
      lzd    = "lazydocker";
      serve  = "npx serve .";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format      = "$line_break$character";
      # Contexto na direita: nix → dir → git → lang → duração
      right_format = "$cmd_duration$rust$lua$nodejs$python$git_status$git_branch$directory$nix_shell";

      character = {
        success_symbol = "[❯](bold #7aa2f7)";
        error_symbol   = "[❯](bold #f7768e)";
        vimcmd_symbol  = "[❮](bold #9ece6a)";
      };

      directory = {
        style             = "bold #7aa2f7";
        truncation_length = 4;
        truncate_to_repo  = true;
        read_only         = " 󰌾";
      };

      git_branch = {
        symbol = " ";
        style  = "bold #bb9af7";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };

      git_status = {
        style    = "#f7768e";
        format   = "([$all_status$ahead_behind]($style) )";
        ahead    = "⇡$count";
        behind   = "⇣$count";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
        modified = "!$count";
        untracked = "?$count";
        staged   = "+$count";
        deleted  = "✘$count";
      };

      nix_shell = {
        symbol      = " ";
        style       = "bold #73daca";
        format      = "[$symbol$state( \\($name\\))]($style) ";
        impure_msg  = "[impure](bold #e0af68)";
        pure_msg    = "[pure](bold #9ece6a)";
        unknown_msg = "[unknown](bold #ff9e64)";
      };

      python = {
        symbol = " ";
        style  = "#e0af68";
        format = "[$symbol$version( \\($virtualenv\\))]($style) ";
      };

      nodejs = { symbol = " "; style = "#9ece6a"; };
      rust   = { symbol = " "; style = "#ff9e64"; };
      lua    = { symbol = " "; style = "#7aa2f7"; };

      cmd_duration = {
        min_time = 2000;
        style    = "bold #565f89";
        format   = "[ $duration]($style) ";
      };
    };
  };

  programs.zoxide = {
    enable               = true;
    enableZshIntegration = true;
    options = [];  # cd continua normal; zoxide fica em `z` e `zi`
  };

  programs.zsh.initContent = ''
    # Templates Rust
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
    }
    new-native() { _rust_new "rust-native-project" "$1"; }
    new-wasm()   { _rust_new "rust-wasm-project"   "$1"; }

    # Mantém o prompt ancorado na base da janela
    _prompt_at_bottom() {
      printf '\n%.0s' $(seq 1 $(( LINES / 4 )))
    }
    precmd_functions+=(_prompt_at_bottom)
  '';
}
