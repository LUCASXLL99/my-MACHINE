# modules/nixos/system/boot.nix
{ pkgs, ... }:
{
  boot = {
    kernelPackages            = pkgs.linuxPackages_6_6;
    kernelModules             = [ "usbcore" "usbhid" "uinput" ];  # kvm auto-detectado
    extraModprobeConfig       = "options usbcore autosuspend=2";
    loader = {
      systemd-boot.enable      = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.includeDefaultModules = false;
  };
}
