# home/lucasxll/modules/coding-agents.nix
# Coding agents: opencode (overlay dan-online/opencode-nix) e pi (nixpkgs).
# Ambos usam BYOK — chaves em ~/.config/opencode/ e ~/.pi/.

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    opencode         # sempre atualizado via overlay do flake
    pi-coding-agent  # 4 ferramentas (read, write, edit, bash) + skills TS
  ];
}
