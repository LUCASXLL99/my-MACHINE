# ─────────────────────────────────────────────────────────────
# dolphin-extract.nix
# Script "dolphin-extract-selected": pega o(s) item(ns) selecionado(s)
# na janela ATIVA do Dolphin e, se for .zip/.tar(.gz|.bz2|.xz)/.rar/.7z,
# extrai automaticamente na mesma pasta. Ligado ao Ctrl+Alt+E no niri
# (ver modules/wayland/niri.nix).
#
# NOTA: o método D-Bus org.kde.dolphin.MainWindow.selectedItems() foi
# removido nas versões atuais do Dolphin (KF6, testado 6.9.3) — a
# interface não expõe mais consulta direta de seleção. Como contorno,
# disparamos a ação "edit_copy" (Ctrl+C) via D-Bus na janela ativa do
# Dolphin, o que põe os itens selecionados na área de transferência
# como text/uri-list, e lemos isso com wl-paste (Wayland).
#
# NOTA 2: org.kde.dolphin.MainWindow.isActiveWindow() SEMPRE retorna
# false no niri (testado) — niri não é KWin e não repassa o estado de
# ativação do Qt corretamente via Wayland. Por isso descobrimos a
# janela focada perguntando pro PRÓPRIO niri via IPC (`niri msg --json
# focused-window`), que reporta o app_id e pid corretos, e casamos o
# pid com o nome do serviço D-Bus org.kde.dolphin-<pid>.
# ─────────────────────────────────────────────────────────────
{ pkgs, ... }:

let
  dolphin-extract-selected = pkgs.writeShellScriptBin "dolphin-extract-selected" ''
    set -uo pipefail
    export PATH="${pkgs.kdePackages.qttools}/bin:${pkgs.unzip}/bin:${pkgs.gnutar}/bin:${pkgs.p7zip}/bin:${pkgs.unrar}/bin:${pkgs.libnotify}/bin:${pkgs.wl-clipboard}/bin:${pkgs.coreutils}/bin:${pkgs.gnused}/bin:${pkgs.niri}/bin:${pkgs.jq}/bin:$PATH"

    notify() { notify-send -a "Dolphin Extract" "$1" "''${2:-}"; }

    # Pergunta pro niri qual é a janela focada (isActiveWindow do Qt não
    # funciona no niri, ver NOTA 2 acima).
    focused=$(niri msg --json focused-window 2>/dev/null || true)
    if [ -z "$focused" ] || [ "$focused" = "null" ]; then
      notify "Nenhuma janela focada"
      exit 0
    fi

    app_id=$(printf '%s' "$focused" | jq -r '.app_id // empty')
    pid=$(printf '%s' "$focused" | jq -r '.pid // empty')

    if [ "$app_id" != "org.kde.dolphin" ] || [ -z "$pid" ]; then
      notify "A janela focada não é o Dolphin"
      exit 0
    fi

    active_service="org.kde.dolphin-$pid"

    # Confirma que o serviço D-Bus correspondente existe e acha seu
    # objeto MainWindow (/dolphin/Dolphin_N).
    if ! qdbus | grep -qx "$active_service"; then
      notify "Dolphin focado (pid $pid), mas serviço D-Bus não encontrado"
      exit 0
    fi

    active_obj=$(qdbus "$active_service" | grep -m1 '^/dolphin/Dolphin_[0-9]*$' || true)

    if [ -z "$active_obj" ]; then
      notify "Não achei o objeto MainWindow do Dolphin"
      exit 0
    fi

    # Guarda o conteúdo atual da área de transferência pra restaurar depois
    old_clip=$(wl-paste -t text/uri-list 2>/dev/null || true)

    # Dispara "copiar" (Ctrl+C) na janela ativa via D-Bus
    qdbus "$active_service" "$active_obj" org.kde.KMainWindow.activateAction edit_copy >/dev/null 2>&1 || true
    sleep 0.15

    items=$(wl-paste -t text/uri-list 2>/dev/null || true)

    got_any=0

    if [ -n "$items" ]; then
        while IFS= read -r url; do
          [ -z "$url" ] && continue
          got_any=1
          # file:///caminho/arquivo.zip -> /caminho/arquivo.zip
          path="''${url#file://}"
          # URL-decode básico (%20 etc.)
          path=$(printf '%b' "''${path//%/\\x}")

          [ -f "$path" ] || continue
          dir=$(dirname -- "$path")
          base=$(basename -- "$path")

          case "$base" in
            *.zip)
              notify "Extraindo (zip)" "$base"
              unzip -o -q "$path" -d "$dir"
              ;;
            *.tar.gz|*.tgz)
              notify "Extraindo (tar.gz)" "$base"
              tar -xzf "$path" -C "$dir"
              ;;
            *.tar.bz2|*.tbz2)
              notify "Extraindo (tar.bz2)" "$base"
              tar -xjf "$path" -C "$dir"
              ;;
            *.tar.xz|*.txz)
              notify "Extraindo (tar.xz)" "$base"
              tar -xJf "$path" -C "$dir"
              ;;
            *.tar)
              notify "Extraindo (tar)" "$base"
              tar -xf "$path" -C "$dir"
              ;;
            *.rar)
              notify "Extraindo (rar)" "$base"
              unrar x -o+ "$path" "$dir/" > /dev/null
              ;;
            *.7z)
              notify "Extraindo (7z)" "$base"
              7z x -y -o"$dir" "$path" > /dev/null
              ;;
            *)
              notify "Ignorado (não é arquivo compactado)" "$base"
              ;;
          esac
        done <<< "$items"
    fi

    # Restaura o que estava na área de transferência antes
    if [ -n "$old_clip" ]; then
      printf '%s' "$old_clip" | wl-copy -t text/uri-list
    else
      wl-copy -c
    fi

    if [ "$got_any" -eq 0 ]; then
      notify "Nada selecionado no Dolphin"
    fi
  '';
in
{
  home.packages = [ dolphin-extract-selected pkgs.unrar pkgs.p7zip pkgs.wl-clipboard ];
}
