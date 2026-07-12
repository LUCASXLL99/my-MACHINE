{ pkgs, ... }:

{
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono noto-fonts inter ];

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
    # AMD: garante que VAAPI/VDPAU usem o driver mesa (radeonsi), necessário
    # pro plugin obs-vaapi e pra encode de hardware funcionarem certo.
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER      = "radeonsi";
  };

  # kbuildsycoca6 exige um applications.menu (freedesktop Menu Spec) em
  # /etc/xdg/menus — normalmente vem do desktop environment completo
  # (Plasma/GNOME), que não temos rodando (niri é standalone). Sem ele,
  # o Dolphin não lista nenhum app no diálogo "Abrir com". Reaproveita o
  # gnome-applications.menu do gnome-menus (pacote leve) só renomeado.
  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.gnome-menus}/etc/xdg/menus/gnome-applications.menu";

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
    playerctl pavucontrol blueman
    xdg-utils libnotify
    wezterm

    vivaldi obsidian onlyoffice-bin_latest gnome-disk-utility
    rofi
    kdePackages.dolphin kdePackages.ark
    # kbuildsycoca6: sem sessão Plasma completa (niri), ninguém mantém o
    # cache de serviços/MIME do KDE atualizado — sem isso, "Abrir com" no
    # Dolphin não lista nenhum app instalado.
    kdePackages.kservice

    (pkgs.symlinkJoin {
      name = "android-studio";
      paths = [ pkgs.android-studio ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/android-studio \
          --set   DISPLAY                     ":1" \
          --set   _JAVA_AWT_WM_NONREPARENTING "1" \
          --set   ELECTRON_PASSWORD_STORE      "basic" \
          --set   SECRET_BACKEND              "gnome-libsecret" \
          --add-flags "-Dawt.toolkit.name=WLToolkit" \
          --add-flags "-Dsun.java2d.uiScale.enabled=true"

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
    wasm-pack trunk wasm-bindgen-cli
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

    # ── Gravação / streaming (demo p/ cliente) ──────────────────────────
    # OBS: captura de tela via portal PipeWire (niri expõe a interface
    # org.gnome.Mutter.ScreenCast, então o portal-gnome já configurado
    # funciona sem precisar do xdg-desktop-portal-wlr).
    obs-studio
    obs-studio-plugins.obs-pipewire-audio-capture
    obs-studio-plugins.obs-vaapi
    obs-studio-plugins.obs-vkcapture

    # Alternativas CLI leves (já usadas via nix-shell no handoff — agora
    # permanentes, sem precisar baixar de novo a cada gravação)
    wf-recorder
    ffmpeg-full

    # v4l-utils: inspecionar/gerenciar o /dev/video da câmera virtual
    # (v4l2loopback, habilitado em modules/nixos/system/boot.nix)
    v4l-utils
    libva-utils # `vainfo` — confirma se a aceleração AMD/VAAPI está ativa

    # streamlink não incluso (não há pedido de assistir/repassar streams,
    # só gravar/transmitir a demo — adicionar depois se precisar)
  ];
}
