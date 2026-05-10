# home/lucasxll/modules/files.nix
# Associações MIME — qual app abre cada tipo de arquivo.
#
# NOTA SOBRE SESSÕES
# ──────────────────
# xdg.mimeApps é uma configuração por usuário, não por sessão.
# O arquivo ~/.config/mimeapps.list é o mesmo para X11 e Wayland.
# Por isso, priorizamos apps que funcionam na sessão PRINCIPAL (niri/Wayland).
#
#   ✅ Wayland-nativo  → funciona perfeitamente no niri
#   🔶 Via xwayland    → funciona no niri via xwayland-satellite (:1)
#   ❌ X11-only        → NÃO usar aqui; esses apps estão em bspwm.nix
#
# Viewers por sessão:
#   Imagens  → imv   (Wayland ✅) | feh no bspwm, aberto direto pelo wallpaper
#   Vídeo    → mpv   (Wayland ✅)
#   Browser  → firefox (Wayland ✅)
#   Arquivos → dolphin (Wayland ✅) | também funciona em X11
#   Archives → ark    (🔶 xwayland no niri, nativo em X11)

{ ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {

      # ── Diretórios ──────────────────────────────────────────────
      "inode/directory" = [ "org.kde.dolphin.desktop" ];  # ✅ Wayland + X11

      # ── Browser ─────────────────────────────────────────────────
      "text/html"              = [ "firefox.desktop" ];   # ✅
      "application/xhtml+xml"  = [ "firefox.desktop" ];
      "x-scheme-handler/http"  = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];

      # ── Imagens — imv (Wayland-nativo) ──────────────────────────
      # imv instalado em default.nix (pacotes cross-session).
      # Em X11/bspwm o feh lida com imagens diretamente (não via MIME).
      "image/png"     = [ "imv.desktop" ];  # ✅
      "image/jpeg"    = [ "imv.desktop" ];
      "image/gif"     = [ "imv.desktop" ];
      "image/webp"    = [ "imv.desktop" ];
      "image/bmp"     = [ "imv.desktop" ];
      "image/svg+xml" = [ "firefox.desktop" ];  # SVG melhor no browser

      # ── Vídeo — mpv (Wayland-nativo) ────────────────────────────
      "video/mp4"         = [ "mpv.desktop" ];  # ✅
      "video/mkv"         = [ "mpv.desktop" ];
      "video/webm"        = [ "mpv.desktop" ];
      "video/x-matroska"  = [ "mpv.desktop" ];
      "video/avi"         = [ "mpv.desktop" ];
      "video/quicktime"   = [ "mpv.desktop" ];
      "video/x-msvideo"   = [ "mpv.desktop" ];

      # ── Áudio — mpv ─────────────────────────────────────────────
      "audio/mpeg" = [ "mpv.desktop" ];  # ✅
      "audio/flac" = [ "mpv.desktop" ];
      "audio/ogg"  = [ "mpv.desktop" ];
      "audio/wav"  = [ "mpv.desktop" ];
      "audio/opus" = [ "mpv.desktop" ];
      "audio/aac"  = [ "mpv.desktop" ];

      # ── Documentos ──────────────────────────────────────────────
      "application/pdf"  = [ "firefox.desktop" ];  # ✅
      "text/plain"       = [ "firefox.desktop" ];
      "application/json" = [ "firefox.desktop" ];

      # ── Archives — ark (via xwayland no niri) ───────────────────
      "application/zip"              = [ "org.kde.ark.desktop" ];  # 🔶
      "application/x-tar"            = [ "org.kde.ark.desktop" ];
      "application/x-compressed-tar" = [ "org.kde.ark.desktop" ];
      "application/x-7z-compressed"  = [ "org.kde.ark.desktop" ];
      "application/x-rar"            = [ "org.kde.ark.desktop" ];
      "application/gzip"             = [ "org.kde.ark.desktop" ];
    };
  };
}
