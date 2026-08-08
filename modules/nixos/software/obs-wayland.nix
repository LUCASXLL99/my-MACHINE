# obs-wayland.nix
# Garante que o OBS rode sempre em modo Wayland nativo (não via XWayland),
# o que é necessário para a fonte "Captura de Tela (PipeWire)" aparecer.
#
# Problema original: sem GDK_BACKEND=wayland, o OBS pode iniciar via
# XWayland — aí não consegue consultar o xdg-desktop-portal-gnome para
# screen cast, e a fonte some do menu de fontes.
#
# ATENÇÃO (troca niri → mango): este arquivo NÃO foi reescrito, só marcado.
# O truque abaixo (esperar xdg-desktop-portal-gnome) só funciona porque o
# niri expõe org.gnome.Mutter.ScreenCast no DBus, imitando o Mutter. O
# mango é baseado em wlroots/dwl e não tem essa emulação — a captura de
# tela por portal normalmente passa por xdg-desktop-portal-wlr em vez do
# portal-gnome. Como não tenho como testar aqui, não troquei sozinho pra
# não quebrar a gravação: seria preciso trocar o portal (adicionar
# xdg-desktop-portal-wlr, ajustar xdg.portal.config) e validar na prática.
#
# Além disso, o serviço xdg-desktop-portal-gnome às vezes sobe antes de o
# niri registrar org.gnome.Mutter.ScreenCast no DBus. O After= abaixo
# força o portal a esperar a sessão gráfica estar pronta antes de iniciar.
{ ... }:

{
  # Força OBS (GTK) a usar o backend Wayland nativo.
  # GDK_BACKEND=wayland,x11  →  tenta Wayland primeiro, cai pra X11 só se
  # WAYLAND_DISPLAY não estiver disponível (seguro: não quebra sessões X11).
  environment.sessionVariables.GDK_BACKEND = "wayland,x11";

  # Reinicia o portal gnome depois que a sessão gráfica (niri) estiver
  # estável. Sem isso, o portal às vezes inicia cedo demais e não encontra
  # a interface org.gnome.Mutter.ScreenCast — aí o OBS abre sem a fonte
  # de captura de tela e ela "some" do menu.
  systemd.user.services.xdg-desktop-portal-gnome = {
    overrideStrategy = "asDropin";
    serviceConfig = {
      # Reinicia automaticamente se o portal cair (ex: timeout de DBus).
      Restart    = "on-failure";
      RestartSec = "2s";
    };
    # Só sobe depois que a sessão gráfica (niri) estiver rodando.
    after  = [ "graphical-session.target" ];
    # Não precisa de wants; o xdg-desktop-portal principal já ativa este.
    wantedBy = [];
  };
}
