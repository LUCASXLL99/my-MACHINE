# home/lucasxll/modules/files.nix — associações MIME (cross-session)
#
# Prioridade: apps Wayland-nativos (sessão principal niri).
# ✅ Wayland-nativo | 🔶 via xwayland | ❌ X11-only (→ bspwm.nix)

{ ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory"        = [ "org.kde.dolphin.desktop" ];

      # Browser
      "text/html"              = [ "firefox.desktop" ];
      "application/xhtml+xml"  = [ "firefox.desktop" ];
      "x-scheme-handler/http"  = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];

      # Imagens — imv (✅ Wayland)
      "image/png"     = [ "imv.desktop" ];
      "image/jpeg"    = [ "imv.desktop" ];
      "image/gif"     = [ "imv.desktop" ];
      "image/webp"    = [ "imv.desktop" ];
      "image/bmp"     = [ "imv.desktop" ];
      "image/svg+xml" = [ "firefox.desktop" ];

      # Vídeo — mpv (✅ Wayland)
      "video/mp4"        = [ "mpv.desktop" ];
      "video/mkv"        = [ "mpv.desktop" ];
      "video/webm"       = [ "mpv.desktop" ];
      "video/x-matroska" = [ "mpv.desktop" ];
      "video/avi"        = [ "mpv.desktop" ];
      "video/quicktime"  = [ "mpv.desktop" ];
      "video/x-msvideo"  = [ "mpv.desktop" ];

      # Áudio
      "audio/mpeg" = [ "mpv.desktop" ];
      "audio/flac" = [ "mpv.desktop" ];
      "audio/ogg"  = [ "mpv.desktop" ];
      "audio/wav"  = [ "mpv.desktop" ];
      "audio/opus" = [ "mpv.desktop" ];
      "audio/aac"  = [ "mpv.desktop" ];

      # Documentos
      "application/pdf"  = [ "firefox.desktop" ];
      "text/plain"       = [ "firefox.desktop" ];
      "application/json" = [ "firefox.desktop" ];

      # Archives — ark (🔶 xwayland no niri)
      "application/zip"              = [ "org.kde.ark.desktop" ];
      "application/x-tar"            = [ "org.kde.ark.desktop" ];
      "application/x-compressed-tar" = [ "org.kde.ark.desktop" ];
      "application/x-7z-compressed"  = [ "org.kde.ark.desktop" ];
      "application/x-rar"            = [ "org.kde.ark.desktop" ];
      "application/gzip"             = [ "org.kde.ark.desktop" ];
    };
  };
}
