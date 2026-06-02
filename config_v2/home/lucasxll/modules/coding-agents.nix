# home/lucasxll/modules/coding-agents.nix
#
# opencode — via flake dan-online/opencode-nix (overlay no flake.nix principal).
# pi       — pkgs.pi-coding-agent do nixpkgs-unstable.
#
# Primeiro uso:
#   opencode / pi → abrem o TUI; use /login para autenticar, ou:
#   export ANTHROPIC_API_KEY="sk-ant-..."

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    opencode      # sempre atualizado via overlay dan-online/opencode-nix
    pi-coding-agent
  ];
}
