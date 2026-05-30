# qmk-rp2040.nix — Regras udev para teclados QMK com bootloader RP2040
#
# Problema: o `hardware.keyboard.qmk.enable` e `qmk-udev-rules` cobrem
# bootloaders DFU/HID, mas NÃO cobrem o RP2040 (Raspberry Pi RP2 Boot).
#
# O Corne v4 (foostan) usa RP2040. Em modo bootloader ele aparece como:
#   2e8a:0003  Raspberry Pi RP2 Boot  ← mass storage (UF2)
#
# Sem essa regra, o dispositivo fica acessível apenas como root,
# e o `qmk flash` falha silenciosamente ou pede sudo.
#
# Para flashar após aplicar:
#   1. Segurar BOOT/RESET no teclado ao plugar (ou apertar o botão reset)
#   2. Confirmar com: lsusb | grep "2e8a:0003"
#   3. qmk flash -kb foostan/corne/v4/rev1 -km default
#      ou copiar direto: cp firmware.uf2 /run/media/lucasxll/RPI-RP2/
{ config, pkgs, ... }:

{
  services.udev.extraRules = ''
    # ── RP2040 bootloader (Raspberry Pi RP2 Boot) ──────────────────────
    # Cobre qualquer placa RP2040 em modo bootloader (Corne v4, etc.)
    SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", ATTR{idProduct}=="0003", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess", \
      SYMLINK+="rp2040-boot"

    # ── Corne v4 modo normal (foostan) ─────────────────────────────────
    # VID:PID 4653:0004 — modo HID normal (via/vial)
    SUBSYSTEM=="usb", ATTR{idVendor}=="4653", ATTR{idProduct}=="0004", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess"

    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="4653", ATTRS{idProduct}=="0004", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess"

    # ── RP2040 modo normal (firmware QMK rodando) ───────────────────────
    # Mesmo VID do bootloader, product diferente
    SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", ATTR{idProduct}=="0001", \
      MODE="0660", GROUP="plugdev", TAG+="uaccess"
  '';
}
