# modules/nixos/system/network.nix
{ ... }:
{
  networking = {
    hostName              = "nixos";
    networkmanager.enable = true;
  };
}
