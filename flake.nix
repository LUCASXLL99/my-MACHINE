# flake.nix — entrada única do sistema
# Toda dependência externa está aqui, versionada no flake.lock
# Para atualizar: nix flake update
# Para rebuildar: sudo nixos-rebuild switch --flake .#nixos

{
  description = "lucasxll nixos config";

  # ============================================================
  # ENTRADAS (dependências externas — todas versionadas)
  # ============================================================
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url    = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs"; # usa o mesmo nixpkgs — sem duplicata
    };
  };

  # ============================================================
  # SAÍDAS
  # ============================================================
  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs   = nixpkgs.legacyPackages.${system};
  in
  {
    # ── Sistema NixOS ──────────────────────────────────────────
    # sudo nixos-rebuild switch --flake .#nixos
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/nixos/default.nix
      ];
    };

    # ── Home Manager standalone (opcional) ────────────────────
    # home-manager switch --flake .#lucasxll
    homeConfigurations.lucasxll = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ./home/lucasxll/default.nix
      ];
    };
  };
}
