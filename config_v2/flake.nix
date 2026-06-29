{
  description = "lucasxll nixos config";

  inputs = {
    nixpkgs.url         = "github:NixOS/nixpkgs/nixos-25.05";
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
      url    = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # Sem nixpkgs.follows: niri usa o nixpkgs próprio para bater com os
    # binários pré-compilados em niri.cachix.org (com follows compila ~30min).
    niri.url = "github:sodiboo/niri-flake";
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
        {
          nixpkgs.config.allowUnfree = true;
          # Overlays e allowUnfree aqui — fora do home-manager.useGlobalPkgs.
          nixpkgs.overlays = [
            (_: prev: {
              makeModulesClosure = x:
                prev.makeModulesClosure (x // { allowMissing = true; });
            })
            opencode-nix.overlays.default
            (_: _: { pi-coding-agent = pkgs-unstable.pi-coding-agent; })
          ];
        }
        niri.nixosModules.niri
        ./hosts/nixos/default.nix
      ];
    };
  };
}
