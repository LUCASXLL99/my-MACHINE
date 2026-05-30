# home/lucasxll/modules/coding-agents.nix
#
# Coding agents de terminal: opencode e pi.
#
# opencode → gerenciado via flake dan-online/opencode-nix (sempre a versão
#             mais nova; overlay aplicado no flake.nix principal).
# pi       → pkgs.pi-coding-agent do nixpkgs oficial.
#
# Ambos usam BYOK (Bring Your Own Key) — você traz a API key do provider.
# As chaves ficam armazenadas localmente em ~/.config/opencode/ e ~/.pi/.
#
# Primeiro uso:
#   opencode     → abre o TUI; use /login para autenticar
#   pi           → abre o TUI; use /login para autenticar
#
# Ou exporte a variável antes de rodar:
#   export ANTHROPIC_API_KEY="sk-ant-..."

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # ── opencode ─────────────────────────────────────────────────────
    # Versão sempre atualizada via overlay do flake dan-online/opencode-nix.
    # O overlay injeta pkgs.opencode com o binário nativo patchado pro NixOS.
    opencode

    # ── pi ───────────────────────────────────────────────────────────
    # Coding agent minimalista: 4 ferramentas (read, write, edit, bash).
    # Extensível via TypeScript extensions e skills.
    # Cachix configurado no flake.nix pra evitar recompilar do zero.
    pi-coding-agent
  ];
}
