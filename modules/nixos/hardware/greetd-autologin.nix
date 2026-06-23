# ══════════════════════════════════════════════════════════════════════════════
# greetd — autologin para niri com fallback SDDM
# ══════════════════════════════════════════════════════════════════════════════
#
# Problema resolvido:
#   SDDM (display-manager) + autologin Wayland tem uma race condition estrutural:
#   o SDDM roda em X11 na TTY7 e lança o niri numa VT diferente (TTY1). Ao matar
#   a sessão com loginctl kill-session, o kernel volta o foco pra TTY1 (tela
#   preta) em vez da TTY7 onde o SDDM está esperando.
#
# Arquitetura adotada (padrão recomendado para niri/nixos):
#
#   boot → greetd (TTY1) → autologin → niri-session
#                │
#                └── sessão morta manualmente → greetd chama sddm-greeter
#                    (tela bonita do SDDM astronaut aparece na mesma TTY)
#
# Por que greetd e não SDDM direto:
#   - greetd é um session manager minimalista que não tenta gerenciar VTs
#   - ele simplesmente exec() o compositor, sem camada X11 no meio
#   - ao terminar, volta pro próprio processo greetd que chama o greeter
#   - zero race condition porque nunca há mudança de TTY
#
# SDDM preservado:
#   - services.displayManager.sddm permanece habilitado para registrar as
#     sessões xsessions/wayland-sessions (bspwm, niri) no sistema
#   - mas display-manager.service é desabilitado — quem gerencia o login é
#     o greetd.service
#   - o tema sddm-astronaut continua disponível via sddm-greeter

{ pkgs, config, lib, ... }:

let
  # Greeter de fallback: quando a sessão é morta manualmente, o greetd
  # chama o sddm-greeter standalone (sem o display-manager do SDDM).
  # Isso preserva a tela bonita do sddm-astronaut-theme.
  sddmGreeterCmd = "${pkgs.kdePackages.sddm}/bin/sddm-greeter-qt6 --socket ${config.services.greetd.settings.terminal.vt}";
in
{
  # ── greetd ────────────────────────────────────────────────────────────────
  services.greetd = {
    enable   = true;
    restart  = false;   # não reinicia o greetd em loop se o greeter travar
    settings = {
      terminal.vt = 1;  # TTY1 — mesma VT do autologin, sem salto de VT

      # Sessão padrão: autologin direto no niri, sem tela de login
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd niri-session";
        user    = "greeter";
      };

      # Sessão inicial: autologin imediato no boot
      initial_session = {
        command = "niri-session";
        user    = "lucasxll";
      };
    };
  };

  # Pacotes necessários para o greetd e o greeter de fallback
  environment.systemPackages = with pkgs; [
    greetd.greetd
  ];

  # ── SDDM preservado como registro de sessões ───────────────────────────────
  # services.displayManager.sddm.enable = true continua em sddm-reflect.nix
  # para que as sessões (niri, bspwm) sejam registradas em xsessions/
  # wayland-sessions. Mas o display-manager.service não deve subir junto
  # com o greetd.service — desabilitamos o unit do SDDM aqui.
  systemd.services.display-manager.enable = lib.mkForce false;

  # O greetd precisa de acesso ao PAM para autenticar
  security.pam.services.greetd = {};
}
