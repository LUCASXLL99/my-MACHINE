{ pkgs, ... }:

# Sem sessão Plasma completa (mango é standalone), nada dispara o
# kbuildsycoca6 automaticamente quando pacotes/.desktop mudam. O cache
# de serviços/MIME do KDE (ksycoca) fica obsoleto e o Dolphin passa a
# listar/tentar executar entradas erradas no diálogo "Abrir com"
# (ex.: apontando pra uma pasta como se fosse um app instalado).
#
# Este módulo reconstrói o cache a cada login gráfico e, como reforço,
# uma vez por dia — assim o "Abrir com" do Dolphin nunca fica com uma
# entrada zumbi por muito tempo.

{
  systemd.user.services.kbuildsycoca-autofix = {
    description = "Reconstroi o cache de servicos/MIME do KDE (ksycoca)";
    serviceConfig = {
      Type      = "oneshot";
      ExecStart = "${pkgs.kdePackages.kservice}/bin/kbuildsycoca6 --noincremental";
    };
  };

  systemd.user.timers.kbuildsycoca-autofix = {
    description = "Dispara o rebuild do ksycoca no login e diariamente";
    wantedBy    = [ "timers.target" ];
    timerConfig = {
      OnStartupSec = "30s";
      OnUnitActiveSec = "1d";
      Unit = "kbuildsycoca-autofix.service";
    };
  };
}
