{
  description = "lucasxll nixos config";

  nixConfig = {
    extra-substituters        = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # unstable usado SOMENTE para noctalia/quickshell
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url    = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url    = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.home-manager.follows removido: stylix release-25.05 novo não
      # tem mais home-manager como input próprio — o módulo HM é importado
      # explicitamente via sharedModules em hosts/nixos/default.nix.
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, noctalia, ... } @ inputs:
  let
    system      = "x86_64-linux";
    pkgs        = nixpkgs.legacyPackages.${system};
    pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/nixos/default.nix
      ];
    };

    # homeConfigurations não é usado — HM está integrado via nixosModules em
    # hosts/nixos/default.nix (home-manager.users.lucasxll).
    # O módulo do noctalia é importado dentro de home/lucasxll/default.nix.
  };
}
