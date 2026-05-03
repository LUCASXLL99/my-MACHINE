{
  description = "lucasxll nixos config";

  nixConfig = {
    extra-substituters        = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # unstable usado SOMENTE para noctalia/quickshell
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url    = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url    = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, noctalia, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs   = nixpkgs.legacyPackages.${system};
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
