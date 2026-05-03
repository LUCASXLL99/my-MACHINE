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
    };
  };

  # ── Starship — prompt moderno ──────────────────────────────────
  # enableZshIntegration = true por padrão quando programs.zsh.enable = true
  programs.starship = {
    enable = true;
    settings = {
      # Linha em branco antes do prompt — respira melhor com outputs longos
      add_newline = true;

      # Formato da linha: contexto + dir + git + nix + lang + fim
      format = "$nix_shell$directory$git_branch$git_status$python$nodejs$rust$lua$cmd_duration$line_break$character";

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
}
