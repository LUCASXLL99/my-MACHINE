# modules/nixos/hardware/qmk-rp2040.nix
#
# Regras udev para teclados QMK com bootloader RP2040 (Corne v4).
# hardware.keyboard.qmk.enable não cobre o RP2040 — por isso este módulo existe.
#
# Para flashar:
#   1. Segurar BOOT ao plugar (ou apertar reset)
#   2. lsusb | grep "2e8a:0003"
#   3. qmk flash -kb foostan/corne/v4/rev1 -km default
#      ou: cp firmware.uf2 /run/media/lucasxll/RPI-RP2/

{ ... }:

{
  services.udev.extraRules = ''
    # RP2040 bootloader (massa de armazenamento UF2)
    SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", ATTR{idProduct}=="0003", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess", \
      SYMLINK+="rp2040-boot"

    # Corne v4 modo normal (HID via/vial)
    SUBSYSTEM=="usb",    ATTR{idVendor}=="4653",  ATTR{idProduct}=="0004", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="4653", ATTRS{idProduct}=="0004", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess"

    # RP2040 com firmware QMK rodando
    SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", ATTR{idProduct}=="0001", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess"
  '';
}
