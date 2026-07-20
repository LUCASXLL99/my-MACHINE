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
    ibus.engines = [ ]; # nenhum engine de idioma necessário — só o hex input nativo
  };
}
