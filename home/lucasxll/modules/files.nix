# home/lucasxll/modules/files.nix
# Gerenciadores de arquivo gráficos — zero KDE/GNOME

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.tumbler
    file-roller
    p7zip
    unrar
  ];

  # Abre pastas no thunar quando clicado em outros apps
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };
  };
}
