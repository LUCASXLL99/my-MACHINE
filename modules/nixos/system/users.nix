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
      # Senha "1" (a pedido do usuário — ver conversa: risco de segurança
      # com sudo NOPASSWD conhecido e aceito).
      hashedPassword = "$6$D18o9X.Uz4bWFKli$8O129whTx7eD33/ls38WTnCBGRB0qvJEbzqGy6giJGsaonnQDZFENQMsrDE7yxGBSfoaLaaKcqU64BVqUMkHv0";
      packages = [];
    };
  };

  security.sudo.extraRules = [{
    users    = [ "lucasxll" ];
    commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
  }];

  security.pam.services.noctalia = {};
}
