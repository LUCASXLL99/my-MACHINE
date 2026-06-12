{
  description = "lucasxll nixos config";

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
            (_: _: { pi-coding-agent = pkgs-unstable.pi-coding-agent; })
          ];
        }
        niri.nixosModules.niri
        ./hosts/nixos/default.nix
      ];
    };
  };
}
