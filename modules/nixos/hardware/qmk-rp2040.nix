# Regras udev para teclados QMK com bootloader RP2040 (Corne v4).
# hardware.keyboard.qmk.enable não cobre o RP2040.
# Flashar: segurar BOOT ao plugar → qmk flash -kb foostan/corne/v4/rev1 -km default

{ ... }:

{
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", ATTR{idProduct}=="0003", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess", SYMLINK+="rp2040-boot"

    SUBSYSTEM=="usb",    ATTR{idVendor}=="4653",  ATTR{idProduct}=="0004", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="4653", ATTRS{idProduct}=="0004", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess"

    SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", ATTR{idProduct}=="0001", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess"
  '';
}
