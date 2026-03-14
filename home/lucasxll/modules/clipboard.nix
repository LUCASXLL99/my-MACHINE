# home/lucasxll/modules/clipboard.nix
# Greenclip — histórico de clipboard via rofi (super + v)

{ config, pkgs, ... }:

{
  home.packages = [ pkgs.haskellPackages.greenclip ];

  xdg.configFile."greenclip.toml".text = ''
    [greenclip]
      max_history_length       = 50
      enable_image_support     = false
      image_cache_path         = ""
      deduplicate_on_insert    = true
      history_file             = "${config.home.homeDirectory}/.cache/greenclip.history"
      blacklisted_applications = ["KeePassXC", "keepassxc", "pinentry"]
  '';
}
