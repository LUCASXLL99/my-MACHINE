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
      theme   = "robbyrussell";
      plugins = [ "git" "docker" "sudo" "history" ];
    };
    shellAliases = {
# Rebuild rápido — pode rodar de qualquer pasta
  rebuild = "cd /etc/nixos && sudo git add . && sudo nixos-rebuild switch --flake .#nixos";
  rebuild-test = "cd /etc/nixos && sudo git add . && sudo nixos-rebuild test --flake .#nixos";
  rebuild-dry  = "cd /etc/nixos && sudo git add . && sudo nixos-rebuild dry-activate --flake .#nixos";

  # Git do nixos de qualquer lugar
  nixgit = "git -C /etc/nixos";





      # Gerenciadores de arquivo
      f    = "yazi";
      fm   = "thunar . &";
      # Tela
      flip-x     = ''xrandr --output "$(xrandr | awk '/ connected/{print $1; exit}')" --reflect x'';
      flip-reset = ''xrandr --output "$(xrandr | awk '/ connected/{print $1; exit}')" --reflect normal'';
    };
  };
}
