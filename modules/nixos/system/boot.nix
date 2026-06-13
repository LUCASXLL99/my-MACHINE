{ pkgs, ... }:

{
  boot = {
    kernelPackages      = pkgs.linuxPackages_6_6;
    kernelModules       = [ "usbcore" "usbhid" "uinput" ];
    extraModprobeConfig = "options usbcore autosuspend=2";
    loader = {
      systemd-boot.enable      = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.includeDefaultModules = false;
  };
}
