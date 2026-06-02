{
  description = "lucasxll nixos config";

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://pi.cachix.org"
      "https://niri.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfry9N+KvbD843ZCEMiypnAjAK0Oo="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url    = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url    = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    niri = {
      url    = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode-nix = {
      url    = "github:dan-online/opencode-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, noctalia, niri, opencode-nix, ... } @ inputs:
  let
    system      = "x86_64-linux";
    overlays = [
      (_: prev: {
        makeModulesClosure = x:
          prev.makeModulesClosure (x // { allowMissing = true; });
      })
      opencode-nix.overlays.default
      (_: _: {
        pi-coding-agent =
          (import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; }).pi-coding-agent;
      })
    ];
    pkgs          = import nixpkgs { inherit system overlays; config.allowUnfree = true; };
    pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = { inherit inputs pkgs-unstable; };
      modules = [
        niri.nixosModules.niri
        ./hosts/nixos/default.nix
      ];
    };
  };
}
