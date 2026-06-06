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
      url = "github:sodiboo/niri-flake";
      # Sem nixpkgs.follows: niri usa o nixpkgs próprio, que bate com
      # os binários pré-compilados em niri.cachix.org. Com follows = "nixpkgs"
      # o hash diverge e o niri compila localmente (~30min).
    };

    opencode-nix = {
      url    = "github:dan-online/opencode-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, noctalia, niri, opencode-nix, ... } @ inputs:
  let
    system        = "x86_64-linux";
    pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs pkgs-unstable; };
      modules = [
        # ── Overlays e allowUnfree declarados aqui, dentro do sistema,
        #    para não conflitar com home-manager.useGlobalPkgs.
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [
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
        }
        niri.nixosModules.niri
        ./hosts/nixos/default.nix
      ];
    };
  };
}
