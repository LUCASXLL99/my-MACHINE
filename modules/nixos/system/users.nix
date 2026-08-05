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
      hashedPassword = "$6$MBJkNgz.CaFcC137$ef7eNpBjGDv.ZZEN/fIVMP1TB1D4XMYQlTn3j65Gs3PeChs4e.2T.s07M0wRAx/EzwWlhQQsNj9K37rCD4Yk90";
      packages = [];
    };
  };

  security.sudo.extraRules = [{
    users    = [ "lucasxll" ];
    commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
  }];

  security.pam.services.noctalia = {};
}
