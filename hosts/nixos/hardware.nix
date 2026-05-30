{ pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_6_1;
    loader = {
      systemd-boot.enable      = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules       = [ "kvm-amd" "kvm-intel" "usbcore" "usbhid" "uinput" ];
    extraModprobeConfig = "options usbcore autosuspend=2";
  };

  hardware.bluetooth.enable    = true;
  hardware.keyboard.qmk.enable = true;
  services.pulseaudio.enable   = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    wireplumber.enable = true;
  };

  services.udisks2.enable = true;
  services.gvfs.enable    = true;
  services.printing.enable = true;
  services.upower.enable  = true;

  # Reinicia mouse-invert quando novo mouse é plugado (hotplug)
  services.udev.extraRules = ''
    SUBSYSTEM=="input", ACTION=="add", ENV{ID_INPUT_MOUSE}=="1", \
      TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="mouse-invert-y.service"
  '';

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    inter
  ];
}
