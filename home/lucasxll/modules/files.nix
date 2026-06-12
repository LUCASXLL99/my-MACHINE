# home/lucasxll/modules/files.nix
# Associações MIME — prioriza apps da sessão principal (niri/Wayland).
#   ✅ Wayland-nativo   🔶 Via xwayland   ❌ X11-only (ficam em bspwm.nix)

{ ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory"        = [ "org.kde.dolphin.desktop" ];  # ✅

      "text/html"              = [ "firefox.desktop" ];          # ✅
      "application/xhtml+xml"  = [ "firefox.desktop" ];
      "x-scheme-handler/http"  = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];

      "image/png"     = [ "imv.desktop" ];                       # ✅
      "image/jpeg"    = [ "imv.desktop" ];
      "image/gif"     = [ "imv.desktop" ];
      "image/webp"    = [ "imv.desktop" ];
      "image/bmp"     = [ "imv.desktop" ];
      "image/svg+xml" = [ "firefox.desktop" ];

      "video/mp4"        = [ "mpv.desktop" ];                    # ✅
      "video/mkv"        = [ "mpv.desktop" ];
      "video/webm"       = [ "mpv.desktop" ];
      "video/x-matroska" = [ "mpv.desktop" ];
      "video/avi"        = [ "mpv.desktop" ];
      "video/quicktime"  = [ "mpv.desktop" ];
      "video/x-msvideo"  = [ "mpv.desktop" ];

      "audio/mpeg" = [ "mpv.desktop" ];                          # ✅
      "audio/flac" = [ "mpv.desktop" ];
      "audio/ogg"  = [ "mpv.desktop" ];
      "audio/wav"  = [ "mpv.desktop" ];
      "audio/opus" = [ "mpv.desktop" ];
      "audio/aac"  = [ "mpv.desktop" ];

      "application/pdf"  = [ "firefox.desktop" ];                # ✅
      "text/plain"       = [ "nvim.desktop" ];         # editor, não browser
      "application/json" = [ "nvim.desktop" ];

      "application/zip"              = [ "org.kde.ark.desktop" ]; # 🔶
      "application/x-tar"            = [ "org.kde.ark.desktop" ];
      "application/x-compressed-tar" = [ "org.kde.ark.desktop" ];
      "application/x-7z-compressed"  = [ "org.kde.ark.desktop" ];
      "application/x-rar"            = [ "org.kde.ark.desktop" ];
      "application/gzip"             = [ "org.kde.ark.desktop" ];
    };
  };
}
