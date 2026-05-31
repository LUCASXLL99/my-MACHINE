# modules/nixos/hardware/qmk-rp2040.nix
# Regras udev para teclados QMK com bootloader RP2040 (Corne v4).
#
# hardware.keyboard.qmk.enable cobre DFU/HID mas NÃO o RP2040 (2e8a:0003).
# Sem esta regra, `qmk flash` falha ou exige sudo.
#
# Para flashar: segurar BOOT ao plugar → lsusb | grep "2e8a:0003" → qmk flash ...

{ config, pkgs, ... }:

{
  services.udev.extraRules = ''
    # RP2040 bootloader (mass storage / UF2)
    SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", ATTR{idProduct}=="0003", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess", \
      SYMLINK+="rp2040-boot"

    # Corne v4 modo HID normal (via/vial)
    SUBSYSTEM=="usb",    ATTR{idVendor}=="4653",  ATTR{idProduct}=="0004", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="4653", ATTRS{idProduct}=="0004", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess"

    # RP2040 modo normal (firmware QMK rodando)
    SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", ATTR{idProduct}=="0001", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess"
  '';
}
