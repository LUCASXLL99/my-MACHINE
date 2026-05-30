{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
    ./users.nix
    ./system.nix

    ../../modules/nixos/display/sddm.nix
    ../../modules/nixos/display/niri.nix
    ../../modules/nixos/display/portals.nix

    ../../modules/nixos/hardware/bluetooth.nix
    ../../modules/nixos/hardware/input.nix
    ../../modules/nixos/hardware/kanata
    ../../modules/nixos/hardware/qmk.nix

    ../../modules/nixos/power/ryzenadj.nix
    ../../modules/nixos/power/auto-cpufreq.nix

    ../../modules/nixos/software/no-keyring.nix
    ../../modules/nixos/software/yazi-deps.nix
    ../../modules/nixos/software/rust-dev.nix
    ../../modules/nixos/software/wallcards.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
  ];

  stylix.base16Scheme = {
    scheme  = "Tokyo Night Dark";
    author  = "lucasxll (adaptado de enkia/tokyo-night-vscode-theme)";
    base00  = "1a1b26"; base01 = "16161e"; base02 = "292e42"; base03 = "565f89";
    base04  = "9aa5ce"; base05 = "c0caf5"; base06 = "cfc9c2"; base07 = "d5d6db";
    base08  = "f7768e"; base09 = "ff9e64"; base0A = "e0af68"; base0B = "9ece6a";
    base0C  = "73daca"; base0D = "7aa2f7"; base0E = "bb9af7"; base0F = "db4b4b";
  };

  stylix.image = config.lib.stylix.pixel "1a1b26";

  stylix.fonts = {
    monospace = { package = pkgs.nerd-fonts.jetbrains-mono; name = "JetBrainsMono Nerd Font"; };
    sansSerif = { package = pkgs.inter; name = "Inter"; };
    serif     = { package = pkgs.inter; name = "Inter"; };
    sizes = { terminal = 13; applications = 11; desktop = 11; };
  };

  home-manager = {
    useGlobalPkgs       = true;
    useUserPackages     = true;
    extraSpecialArgs    = { inherit inputs; };
    backupFileExtension = "backup";
    # stylix release-25.05 não injeta o módulo HM automaticamente
    sharedModules = [ inputs.stylix.homeModules.stylix ];
    users.lucasxll = import ../../home/lucasxll/default.nix;
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
    trusted-users         = [ "root" "lucasxll" ];
  };
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 14d";
  };

  # Workaround bug modules-shrunk NixOS 25.05
  boot.initrd.includeDefaultModules = false;
  system.stateVersion = "25.05";
}
