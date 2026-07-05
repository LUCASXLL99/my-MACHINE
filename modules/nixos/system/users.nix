{ pkgs, ... }:

{
  users.groups.yurii = {};

  users.users = {
    yurii = {
      isNormalUser       = true;
      group              = "yurii";
      hashedPasswordFile = "/etc/passwdfile";
      shell              = pkgs.zsh;
    };
    lucasxll = {
      isNormalUser   = true;
      description    = "LUCASXLL";
      shell          = pkgs.zsh;
      extraGroups    = [
        "networkmanager" "wheel" "docker"
        "libvirt" "libvirtd" "kvm" "qemu-libvirtd"
        "adbusers" "uucp" "uinput" "input" "plugdev"
        "usb" "disk" "cdrom"
        "video" "audio" # v4l2loopback (câmera virtual OBS) + captura de áudio
      ];
      hashedPassword = "$6$6PEfHzY1BpSqVGXG$j1j7Chn4nt3ehnojWM2mZMaof2LhA2MTN48MNGFzlqZPHjxbgMatRWNU34D6yC5aoeGk1pVc9aTQzc07Px.s8.";
      packages = [];
    };
  };

  security.sudo.extraRules = [{
    users    = [ "lucasxll" ];
    commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
  }];

  security.pam.services.noctalia = {};
}
