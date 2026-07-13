{ pkgs, ... }:

# Define o WezTerm como terminal padrão do sistema, de forma declarativa.
#
# Sem sessão Plasma completa (niri é standalone), o "Abrir Terminal Aqui"
# do Dolphin cai no xdg-terminal-exec, que escolhe o terminal olhando:
#   1. ~/.config/xdg-terminals.list  (por usuário)
#   2. /etc/xdg/xdg-terminals.list   (sistema — é o que setamos aqui)
#   3. fallback hardcoded (konsole, gnome-terminal, kitty, etc.)
#
# Setando o arquivo do sistema, garantimos o WezTerm como padrão pra
# qualquer usuário, sem depender de dotfile manual em ~/.config.
{
  environment.etc."xdg/xdg-terminals.list".text = ''
    org.wezfurlong.wezterm.desktop
  '';

  # $TERMINAL é respeitado por vários apps/scripts (rofi, fuzzel, etc.)
  # que abrem um terminal genérico sem depender do xdg-terminal-exec.
  environment.sessionVariables.TERMINAL = "wezterm";

  # Reforça via kdeglobals de sistema (skel) pro caso de algo ainda
  # consultar TerminalApplication/TerminalService do KDE.
  environment.etc."xdg/kdeglobals".text = ''
    [General]
    TerminalApplication=wezterm
    TerminalService=org.wezfurlong.wezterm.desktop
  '';

  environment.systemPackages = [ pkgs.wezterm ];
}
