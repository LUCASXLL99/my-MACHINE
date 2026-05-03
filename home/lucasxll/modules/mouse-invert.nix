# home/lucasxll/modules/mouse-invert.nix
#
# Inversão de eixos do mouse no Wayland via filtro evdev.
#
# O protocolo Wayland não expõe Coordinate Transformation Matrix (CTM)
# como o X11 faz via xinput. A solução é um script Python que opera
# no nível do kernel (evdev), criando um dispositivo virtual com eixos
# invertidos — transparente para qualquer compositor.
#
# ─────────────────────────────────────────────────────────────
# DOIS MODOS:
#
#   mouse-invert y   → inverte só Y
#                      usar quando a tela tem transform "flipped" ativo,
#                      porque o Niri já inverte o cursor em X
#
#   mouse-invert xy  → inverte X e Y
#                      usar quando a tela está em modo normal (sem transform)
#
# SERVIÇOS:
#
#   mouse-invert-y   → inicia com a sessão (padrão = tela espelhada)
#   mouse-invert-xy  → iniciado pelo niri-reset quando tela voltar ao normal
#
# SCRIPTS:
#
#   niri-mirror  → espelha a tela (= f-mirror do X11)
#                  muda transform → flipped, reinicia serviço no modo y
#
#   niri-reset   → restaura a tela (= f-reset do X11)
#                  muda transform → normal, reinicia serviço no modo xy
#
# ─────────────────────────────────────────────────────────────
# PRIMEIRO USO — verificar nome do output:
#
#   niri msg outputs
#
# Se o nome não for "eDP-1", edite a variável outputName abaixo
# E o bloco output "eDP-1" { ... } em niri.nix.
# ─────────────────────────────────────────────────────────────

{ pkgs, ... }:

let
  # ── Ajuste aqui se o nome do output for diferente de eDP-1 ──────
  outputName = "eDP-1";

  # ── Script Python: filtro evdev para inversão de eixos ──────────
  mouseInvert = pkgs.writers.writePython3Bin "mouse-invert" {
    libraries = [ pkgs.python3Packages.evdev ];
  } ''
    import sys
    import threading
    import time

    import evdev
    from evdev import ecodes
    from evdev import UInput

    mode = sys.argv[1] if len(sys.argv) > 1 else "xy"
    INV_X = "x" in mode
    INV_Y = "y" in mode

    print(f"[mouse-invert] modo={mode} inv_x={INV_X} inv_y={INV_Y}", flush=True)


    def process(src):
        name = src.name
        try:
            dst = UInput.from_device(src, name=name + " [inv]")
            src.grab()
            print(f"[mouse-invert] grabbing: {name} ({src.path})", flush=True)
            for ev in src.read_loop():
                if ev.type == ecodes.EV_REL:
                    if ev.code == ecodes.REL_X and INV_X:
                        dst.write(ev.type, ev.code, -ev.value)
                    elif ev.code == ecodes.REL_Y and INV_Y:
                        dst.write(ev.type, ev.code, -ev.value)
                    else:
                        dst.write_event(ev)
                else:
                    dst.write_event(ev)
                if ev.type == ecodes.EV_SYN:
                    dst.syn()
        except Exception as e:
            msg = f"[mouse-invert] erro em {name}: {e}"
            print(msg, file=sys.stderr, flush=True)
        finally:
            try:
                src.ungrab()
            except Exception:
                pass


    def find_mice():
        found = []
        for path in evdev.list_devices():
            try:
                d = evdev.InputDevice(path)
                caps = d.capabilities()
                rel = caps.get(ecodes.EV_REL, [])
                if ecodes.REL_X in rel and ecodes.REL_Y in rel:
                    if "[inv]" not in d.name:
                        found.append(d)
            except Exception:
                pass
        return found


    mice = find_mice()
    if not mice:
        print("[mouse-invert] nenhum mouse encontrado", file=sys.stderr)
        sys.exit(1)

    threads = []
    for m in mice:
        t = threading.Thread(target=process, args=(m,), daemon=True)
        t.start()
        threads.append(t)

    try:
        while True:
            time.sleep(60)
    except KeyboardInterrupt:
        pass
  '';

  # ── niri-mirror: espelha a tela (= f-mirror) ───────────────────
  niriMirror = pkgs.writeShellScriptBin "niri-mirror" ''
    set -e
    # Tela → transform flipped (espelho horizontal)
    niri msg output "${outputName}" transform flipped
    # Niri já inverte cursor X com o transform.
    # Serviço precisa inverter só Y agora.
    systemctl --user stop  mouse-invert-xy 2>/dev/null || true
    systemctl --user start mouse-invert-y  2>/dev/null || true
    echo "[niri-mirror] tela espelhada, mouse modo=y"
  '';

  # ── niri-reset: restaura a tela (= f-reset) ─────────────────────
  niriReset = pkgs.writeShellScriptBin "niri-reset" ''
    set -e
    # Tela → transform normal
    niri msg output "${outputName}" transform normal
    # Sem transform, Niri não inverte cursor.
    # Serviço precisa inverter X e Y.
    systemctl --user stop  mouse-invert-y  2>/dev/null || true
    systemctl --user start mouse-invert-xy 2>/dev/null || true
    echo "[niri-reset] tela normal, mouse modo=xy"
  '';

in
{
  home.packages = [ mouseInvert niriMirror niriReset ];

  # ── Serviço padrão ao login: modo y (tela espelhada por default) ─
  #
  # PROBLEMA ANTIGO: o serviço tinha WantedBy=graphical-session.target
  # sem condição → subia em qualquer sessão (bspwm incluído) → mouse
  # ficava invertido no bspwm depois de sair do niri.
  #
  # SOLUÇÃO: ConditionEnvironment=NIRI_SOCKET
  #   - O niri exporta NIRI_SOCKET para os filhos via spawn-at-startup
  #   - Em bspwm/X11 essa variável não existe → condição falha → serviço
  #     não ativa, mesmo que o graphical-session.target tenha subido
  #   - killUserProcesses=true no logind garante que, ao fechar a sessão
  #     niri, este serviço para antes que a sessão bspwm inicie
  #
  systemd.user.services.mouse-invert-y = {
    Unit = {
      Description          = "Mouse Y-axis inverter — modo tela espelhada";
      After                = [ "graphical-session.target" ];
      PartOf               = [ "graphical-session.target" ];
      # Só ativa dentro do niri. Em bspwm NIRI_SOCKET não existe → inativo.
      ConditionEnvironment = "NIRI_SOCKET";
    };
    Service = {
      ExecStart  = "${mouseInvert}/bin/mouse-invert y";
      Restart    = "on-failure";
      RestartSec = "3s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # ── Serviço auxiliar: modo xy (tela normal — iniciado por niri-reset) ─
  # Não inicia automaticamente; é ativado pelo script niri-reset.
  systemd.user.services.mouse-invert-xy = {
    Unit = {
      Description = "Mouse XY-axis inverter — modo tela normal";
    };
    Service = {
      ExecStart = "${mouseInvert}/bin/mouse-invert xy";
      Restart    = "on-failure";
      RestartSec = "3s";
    };
  };
}
