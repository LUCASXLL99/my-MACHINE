# fastfetch — Nord (chaves "blue"), layout portado do
# theblackdon/mango-fedora (dotfiles/fastfetch). Logo ASCII próprio + barra
# de 8 pontos + Nerd icons.
{ pkgs, ... }:

let
  tokyoNight = ''
    ██╗  ██╗ ██████╗ ██╗  ██╗██╗   ██╗ ██████╗     ███╗   ██╗██╗ ██████╗ ██╗  ██╗████████╗
    ██║ ██╔╝██╔═══██╗██║ ██╔╝╚██╗ ██╔╝██╔═══██╗    ████╗  ██║██║██╔════╝ ██║  ██║╚══██╔══╝
    █████╔╝ ██║   ██║█████╔╝  ╚████╔╝ ██║   ██║    ██╔██╗ ██║██║██║  ███╗███████║   ██║
    ██╔═██╗ ██║   ██║██╔═██╗   ╚██╔╝  ██║   ██║    ██║╚██╗██║██║██║   ██║██╔══██║   ██║
    ██║  ██╗╚██████╔╝██║  ██╗   ██║   ╚██████╔╝    ██║ ╚████║██║╚██████╔╝██║  ██║   ██║
    ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝    ╚═════╝     ╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝
  '';
in
{
  xdg.configFile."fastfetch/ascii.txt".text = tokyoNight;

  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "source": "$HOME/.config/fastfetch/ascii.txt",
        "color": { "1": "blue", "2": "blue", "3": "blue" },
        "padding": { "top": 1, "left": 2 }
      },
      "display": { "separator": "  " },
      "modules": [
        { "type": "custom", "text": "    $col0  $col1  $col2  $col3  $col4  $col5  $col6  $col7", "prefix": "" },
        { "type": "custom", "text": "  ───────────────────────────────────────────────", "prefix": "" },
        { "type": "title", "keyWidth": 10, "keyColor": "blue" },
        { "type": "separator" },
        { "type": "os", "key": "  OS", "keyColor": "blue" },
        { "type": "kernel", "key": "  KERNEL", "keyColor": "blue" },
        { "type": "packages", "key": "  PACOTES", "keyColor": "blue" },
        { "type": "shell", "key": "  SHELL", "keyColor": "blue" },
        { "type": "terminal", "key": "  TERMINAL", "keyColor": "blue" },
        { "type": "wm", "key": "  WM", "keyColor": "blue" },
        { "type": "cpu", "key": "  CPU", "keyColor": "blue" },
        { "type": "gpu", "key": "  GPU", "keyColor": "blue" },
        { "type": "memory", "key": "  MEM", "keyColor": "blue" },
        { "type": "disk", "key": "  DISCO", "keyColor": "blue" },
        { "type": "uptime", "key": "  UPTIME", "keyColor": "blue" },
        { "type": "datetime", "key": "  DATA", "keyColor": "blue", "format": "%d/%m/%Y %H:%M" },
        { "type": "break" },
        { "type": "custom", "text": "  ───────────────────────────────────────────────", "prefix": "" },
        { "type": "custom", "text": "    $col0  $col1  $col2  $col3  $col4  $col5  $col6  $col7", "prefix": "" },
        { "type": "colors", "paddingLeft": 0, "symbol": "square", "width": 2 }
      ]
    }
  '';
}
