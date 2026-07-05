{ pkgs, ... }:

{
  boot = {
    kernelPackages      = pkgs.linuxPackages_6_6;
    # v4l2loopback: câmera virtual — usada pelo OBS (e outros apps) para expor
    # a "Virtual Camera" como um /dev/videoN real durante lives/gravações.
    extraModulePackages = [ pkgs.linuxPackages_6_6.v4l2loopback ];
    kernelModules       = [ "usbcore" "usbhid" "uinput" "v4l2loopback" ];
    extraModprobeConfig = ''
      options usbcore autosuspend=2
      options v4l2loopback exclusive_caps=1 card_label="OBS Virtual Camera"
    '';
    loader = {
      systemd-boot.enable      = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.includeDefaultModules = false;
  };
}
