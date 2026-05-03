# home/lucasxll/modules/files.nix
# Dolphin como gerenciador de arquivos padrão

{ pkgs, ... }:

{
  # mimeapps — dolphin abre pastas e arquivos comuns
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory"         = "org.kde.dolphin.desktop";
      "application/zip"         = "org.kde.ark.desktop";
      "application/x-tar"       = "org.kde.ark.desktop";
      "application/x-compressed-tar" = "org.kde.ark.desktop";
    };
  };
}
