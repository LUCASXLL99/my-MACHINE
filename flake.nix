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
    mango = {
      url = "github:mangowm/mango";
      # nixpkgs-unstable, não nixpkgs (25.05 estável): o pacote do mango
      # depende de libxcb-wm, que não existe ainda na 25.05 — dava
      # "Function called without required argument libxcb-wm" no rebuild.
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    opencode-nix = {
      url    = "github:dan-online/opencode-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, noctalia, mango, opencode-nix, ... } @ inputs:
  let
    system        = "x86_64-linux";
    pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};

    # ── Noctalia com MangoService patcheado ────────────────────────────────
    # O Noctalia upstream lê os workspaces via protocolo dwl-ipc-unstable-v2,
    # que o mangowm NÃO implementa ("DWL is not available", barra sem tags).
    # Este override substitui o MangoService.qml por uma versão que usa o IPC
    # próprio do mango (`mmsg watch all-tags` / `mmsg dispatch view,N`).
    noctalia-patched = inputs.noctalia.packages.${system}.default.overrideAttrs (old: {
      installPhase = old.installPhase + ''
        cp ${./home/lucasxll/modules/wayland/MangoService.patch.qml} \
          $out/share/noctalia-shell/Services/Compositor/MangoService.qml
      '';
    });

    # ── tui-kan (kanban TUI em Rust, theblackdon) ─────────────────────────
    # fetchGit do Codeberg (Forgejo). Projeto Rust auto-contido; compilado
    # via rustPlatform.buildRustPackage usando o Cargo.lock do repo.
    tui-kan-src = builtins.fetchGit {
      url = "https://codeberg.org/theblackdon/tui-kan.git";
      rev = "3e3f8b17b4b3d04add2d1fa59d27b567ae86a705";
    };
    tui-kan-pkg = pkgs-unstable.rustPlatform.buildRustPackage {
      pname   = "tui-kan";
      version = "0.1.0";
      src     = tui-kan-src;
      cargoLock.lockFile = "${tui-kan-src}/Cargo.lock";
      meta.mainProgram = "tui-kan";
    };

    # Overlays e allowUnfree entram aqui, na instanciação do pkgs — não como
    # as opções `nixpkgs.overlays`/`nixpkgs.config`. Com
    # `home-manager.useGlobalPkgs = true`, o home-manager exige que essas
    # opções fiquem de fora; o pkgs pronto é repassado via `nixpkgs.pkgs`
    # logo abaixo, o que evita o warning (e o futuro erro de avaliação).
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (_: prev: {
          makeModulesClosure = x:
            prev.makeModulesClosure (x // { allowMissing = true; });
        })
        opencode-nix.overlays.default
        (_: _: { pi-coding-agent = pkgs-unstable.pi-coding-agent; })
      ];
    };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs pkgs-unstable noctalia-patched tui-kan-pkg; };
      modules = [
        { nixpkgs.pkgs = pkgs; }
        mango.nixosModules.mango
        ./hosts/nixos/default.nix
      ];
    };
  };
}
