{
  description = "lucasxll nixos config";

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://pi.cachix.org"          # binários do pi-coding-agent pré-compilados
      "https://niri.cachix.org"        # binários do niri-flake pré-compilados
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="  # lukasl-dev/pi.nix
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfry9N+KvbD843ZCEMiypnAjAK0Oo="
    ];
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

    niri = {
      url    = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ── Coding agents ────────────────────────────────────────────────
    # opencode: sempre na versão mais nova (auto-atualiza de hora em hora,
    # baixa o binário nativo do GitHub e aplica autoPatchelfHook pro NixOS).
    # nixpkgs.follows = "nixpkgs" evita baixar um nixpkgs extra só pra isso.
    opencode-nix = {
      url    = "github:dan-online/opencode-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, noctalia, niri, opencode-nix, ... } @ inputs:
  let
    system      = "x86_64-linux";
    # Overlay aplicado aqui — antes do home-manager ver o nixpkgs.
    # Isso elimina o warning "useGlobalPkgs + nixpkgs.overlays" porque
    # o HM herda esse nixpkgs já com o overlay aplicado, sem precisar
    # declarar nixpkgs.overlays dentro do módulo NixOS.
    overlays = [
      (_: prev: {
        makeModulesClosure = x:
          prev.makeModulesClosure (x // { allowMissing = true; });
      })
      opencode-nix.overlays.default   # expõe pkgs.opencode sempre atualizado
      # pi-coding-agent ainda não chegou no nixos-25.05 — puxa do unstable.
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

    # homeConfigurations não é usado — HM está integrado via nixosModules em
    # hosts/nixos/default.nix (home-manager.users.lucasxll).
    # O módulo do noctalia é importado dentro de home/lucasxll/default.nix.
  };
}
