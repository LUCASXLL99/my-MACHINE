# Ativa o IBus.
#
# Motivo principal: o teclado Corne (QMK) usa entrada Unicode (UC_LNX) na
# camada SYM para os símbolos de pontuação, pra não depender do layout
# xkb ativo no sistema (br/nodeadkeys). Isso evita que o SO "traduza"
# errado as posições físicas das teclas quando o layout não é US.
#
# O IBus embutido já sabe interpretar a sequência Ctrl+Shift+U + hex do
# QMK sem precisar de nenhum "engine" de idioma adicional — não estamos
# usando o IBus para digitar japonês/chinês/etc, só o input Unicode
# nativo dele.
{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type   = "ibus";
    ibus = {
      engines = [ ]; # nenhum engine de idioma necessário — só o hex input nativo

      # O WezTerm fala com o IBus via XIM (config.xim_im_name = 'ibus'),
      # não pelo protocolo nativo de text-input do Wayland. Nesta versão
      # do nixpkgs (25.05) o IBus já usa o frontend X11/XIM por padrão,
      # então não precisamos forçar nada extra aqui.
    };
  };

  # Em Wayland, o módulo do IBus só define XMODIFIERS automaticamente.
  # GTK_IM_MODULE/QT_IM_MODULE ficam de fora por padrão (não são
  # necessárias pra apps GTK/Qt nativos em Wayland), mas o WezTerm
  # precisa delas mesmo assim por causa do caminho XIM.
  environment.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE  = "ibus";
    XMODIFIERS    = "@im=ibus";
  };

  # O niri não faz autostart de apps via XDG Autostart como GNOME/KDE
  # fazem, então o ibus-daemon nunca sobe sozinho na sessão. Subimos
  # ele manualmente como serviço de usuário, atrelado à sessão gráfica.
  systemd.user.services.ibus-daemon = {
    description = "IBus daemon";
    wantedBy    = [ "graphical-session.target" ];
    partOf      = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.ibus}/bin/ibus-daemon --xim --replace --panel=disable";
      Restart   = "on-failure";
    };
  };
}
