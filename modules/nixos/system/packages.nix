# modules/nixos/system/packages.nix
{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    inter
  ];

  programs = {
    firefox.enable = false;
    adb.enable     = true;
    nix-ld = {
      enable    = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib glibc zlib
        freetype fontconfig
        libGL libGLU libxkbcommon
        xorg.libX11 xorg.libXext xorg.libXrender
        xorg.libXtst xorg.libXi xorg.libXfixes
        openssl postgresql.lib sqlite libclang.lib
      ];
    };
    zsh.enable = true;
  };

  environment.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    OPENSSL_DIR     = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    PATH            = "$HOME/.cargo/bin:$PATH";
    WASM_OPT        = "${pkgs.binaryen}/bin/wasm-opt";
  };

  environment.pathsToLink = [
    "/share/kservices5"
    "/share/kservices5/ServiceMenus"
    "/share/kio"
    "/share/kio/servicemenus"
  ];

  environment.systemPackages = with pkgs; [
    vim git wget htop fastfetch
    zip unzip

    grim slurp swappy
    wl-clipboard cliphist
    wl-mirror wlr-randr
    playerctl pavucontrol
    xdg-utils libnotify
    wezterm

    vivaldi obsidian onlyoffice-bin_latest gnome-disk-utility
    rofi
    kdePackages.dolphin kdePackages.ark

    (pkgs.symlinkJoin {
      name = "android-studio";
      paths = [ pkgs.android-studio ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/android-studio \
          --set DISPLAY ":1" \
          --set _JAVA_AWT_WM_NONREPARENTING "1"

        apps="$out/share/applications"
        if [ -L "$apps" ]; then
          orig=$(readlink -f "$apps")
          rm "$apps"
          mkdir -p "$apps"
          for f in "$orig"/*.desktop; do
            sed "s|Exec=.*/bin/android-studio|Exec=$out/bin/android-studio|g" \
              "$f" > "$apps/$(basename "$f")"
          done
        fi
      '';
    })

    python3 python312Packages.pip

    rustup
    wasm-pack trunk
    wasm-bindgen-cli
    binaryen wabt

    nodejs_22

    cargo-watch cargo-generate cargo-edit
    cargo-nextest cargo-audit cargo-expand cargo-flamegraph

    llvmPackages.lld mold

    pkg-config openssl openssl.dev
    gcc stdenv.cc.cc
    zulu8 openjdk11 jdk17 jdk21

    docker qemu qemu_kvm virt-manager libvirt acl polkit
    spice spice-gtk spice-protocol libguestfs libusb1 usbutils

    qmk qmk-udev-rules qmk_hid via vial kanata-with-cmd
    sxhkd brightnessctl

    auto-cpufreq libnotify
    xwinwrap mpv yt-dlp

    kdePackages.qtwayland
    kdePackages.plasma-integration
    xdg-desktop-portal-gtk

    lldb

    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages."@tailwindcss/language-server"
    emmet-language-server
    nodePackages.prettier
    nodePackages.eslint

    rust-analyzer rustfmt

    lazygit httpie websocat jq yq-go curlie

    flyctl caddy sqlx-cli mkcert

    btop dust ripgrep fd tokei hyperfine

    lazydocker dive

    wireshark fx
  ];
}
