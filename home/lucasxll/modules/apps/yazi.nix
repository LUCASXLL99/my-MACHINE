{ config, ... }:

{
  programs.yazi = {
    enable = true;

    settings = {
      manager = {
        ratio          = [ 1 2 4 ];
        sort_by        = "natural";
        sort_dir_first = true;
        show_hidden    = false;
        show_symlink   = true;
        linemode       = "size";
      };
      preview = {
        max_width     = 1200;
        max_height    = 900;
        image_delay   = 30;
        image_quality = 80;
      };
    };

    keymap.manager.prepend_keymap = [
      { on = ["l"];       run = "plugin smart-enter";          desc = "Entra ou abre"; }
      { on = ["h"];       run = "leave";                       desc = "Pasta pai"; }
      { on = ["."];       run = "hidden toggle";               desc = "Ocultos"; }
      { on = ["<Space>"]; run = "select --state=none";         desc = "Seleciona"; }
      { on = ["V"];       run = "select_all --state=none";     desc = "Seleciona tudo"; }
      { on = ["v"];       run = "visual_mode";                 desc = "Modo visual"; }
      { on = ["t"];       run = "tab_create --current";        desc = "Nova aba"; }
      { on = ["<Tab>"];   run = "tab_switch 1 --relative";     desc = "Próxima aba"; }
      { on = ["o" "n"];   run = "sort natural  --dir-first";   desc = "Ordena nome"; }
      { on = ["o" "s"];   run = "sort size     --dir-first";   desc = "Ordena tamanho"; }
      { on = ["o" "m"];   run = "sort modified --dir-first";   desc = "Ordena data"; }
    ];

    theme.manager = {
      cwd             = { fg = "#58a6ff"; bold = true; };
      hovered         = { fg = "#0e1117"; bg = "#58a6ff"; bold = true; };
      selected        = { fg = "#3fb950"; bold = true; };
      selected_symbol = "󰄬 ";
    };
    theme.status = {
      mode_normal = { fg = "#0e1117"; bg = "#58a6ff"; bold = true; };
      mode_select = { fg = "#0e1117"; bg = "#3fb950"; bold = true; };
    };
  };
}
