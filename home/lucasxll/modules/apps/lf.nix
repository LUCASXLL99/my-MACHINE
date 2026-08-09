{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lf bat ueberzugpp
    fd ripgrep fzf
    zoxide eza
    btop dust duf ncdu
    tldr jq yq-go
    delta lazygit
    tokei glow xh trashy
    chafa poppler
  ];

  xdg.configFile."lf/lfrc".text = ''
    set hidden true
    set icons true
    set drawbox true
    set incsearch true
    set smartcase true
    set ignorecase true
    set preview true
    set previewer ~/.config/lf/previewer.sh
    set cleaner   ~/.config/lf/cleaner.sh
    set ratios 1:2:3
    set scrolloff 5
    set shell sh
    set shellopts '-eu'
    set ifs "\n"
    set filesep "\n"

    map h updir
    map l open
    map . set hidden!
    map <esc> quit
    map q quit

    map dd cut
    map yy copy
    map pp paste
    map <delete> delete
    map R rename
    map r push :rename<space>

    map mf push $touch<space>
    map md push $mkdir<space>-p<space>
    map o &xdg-open "$f"
    map ex :extract
    map <a-a> :glob-select *
    map <a-A> :glob-unselect *

    map <c-f> $${
        res="$(fd --hidden --follow --exclude .git 2>/dev/null | fzf --preview 'bat --color=always --line-range :50 {}' 2>/dev/null)"
        [ -n "$res" ] && lf -remote "send $id select \"$res\""
    }

    cmd open &{{
        case $(file --mime-type -Lb "$f") in
            text/*|application/json|application/xml|inode/x-empty)
                lf -remote "send $id \$\${EDITOR:-vim} \"$f\""
                ;;
            *)
                xdg-open "$f" >/dev/null 2>&1
                ;;
        esac
    }}

    cmd delete $${
        set -f
        printf "%s\n" "$fx"
        printf "Deletar permanentemente? [s/N] "
        read ans
        [ "$ans" = "s" ] && rm -rf -- $fx
    }

    cmd trash ''${ set -f; trashy "$fx" }
    map <delete> trash
    map D delete

    cmd extract $${
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
    }

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

  xdg.configFile."lf/previewer.sh" = {
    executable = true;
    text = ''
      #!/bin/sh
      file=$1; w=$2; h=$3
      case $(file --mime-type -Lb "$file") in
          text/*|application/json|application/xml|application/javascript)
              bat --color=always --style=numbers,changes --line-range=:200 --theme="TwoDark" "$file" 2>/dev/null || cat "$file" ;;
          application/pdf)
              pdftotext -l 3 "$file" - 2>/dev/null | head -80 || echo "[PDF — instale poppler]" ;;
          image/*)
              chafa --format symbols --size "$w"x"$h" "$file" 2>/dev/null || echo "[Imagem: $file]" ;;
          video/*)
              echo "[Vídeo]"
              ffprobe -v quiet -show_format -show_streams "$file" 2>/dev/null \
                  | grep -E "^(filename|duration|bit_rate|codec_name|width|height)" | head -10 ;;
          audio/*)
              ffprobe -v quiet -show_format "$file" 2>/dev/null \
                  | grep -E "^(filename|duration|bit_rate|TAG)" | head -10 ;;
          application/zip|application/x-tar|application/x-7z-compressed)
              case "$file" in
                  *.zip)      unzip -l "$file" 2>/dev/null | head -40 ;;
                  *.tar*|*.tgz|*.tbz2) tar tf "$file" 2>/dev/null | head -40 ;;
                  *.7z)       7z l "$file" 2>/dev/null | head -40 ;;
                  *)          echo "$mimetype" ;;
              esac ;;
          *)
              file --brief "$file"; echo ""; head -20 "$file" 2>/dev/null ;;
      esac
    '';
  };

  xdg.configFile."lf/cleaner.sh" = {
    executable = true;
    text = ''
      #!/bin/sh
      [ -n "$UB_SOCKET" ] && ueberzugpp cmd -s "$UB_SOCKET" -a remove -i preview 2>/dev/null
      exit 0
    '';
  };

  programs.zsh = {
    initContent = ''
      eval "$(zoxide init zsh)"
      source ${pkgs.fzf}/share/fzf/completion.zsh   2>/dev/null || true
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh 2>/dev/null || true
      export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude .git"
      export FZF_DEFAULT_OPTS="
        --color=bg+:#1a1b26,bg:#16161e,spinner:#73daca,hl:#bb9af7
        --color=fg:#c0caf5,header:#7dcfff,info:#7aa2f7,pointer:#73daca
        --color=marker:#73daca,fg+:#c0caf5,prompt:#7aa2f7,hl+:#bb9af7
        --height 50% --border rounded --prompt '❯ '
      "
      export GIT_PAGER="delta"
    '';
    shellAliases = {
      lfcd = ''cd "$(command lf -print-last-dir)"'';
      ls   = "eza --icons --group-directories-first";
      ll   = "eza -la --icons --group-directories-first --git";
      la   = "eza -a --icons --group-directories-first";
      lt   = "eza --tree --icons --level=2";
      llt  = "eza -la --tree --icons --level=2 --git";
      cat  = "bat --style=plain";
      less = "bat --style=full --paging=always";
      df   = "duf";
      curl = "xh";
      lg   = "lazygit";
      gd   = "git diff | delta";
    };
  };
}
