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
# ─────────────────────────────────────────────────────────────
{ pkgs, ... }:

let
  dolphin-extract-selected = pkgs.writeShellScriptBin "dolphin-extract-selected" ''
    set -uo pipefail
    export PATH="${pkgs.kdePackages.qttools}/bin:${pkgs.unzip}/bin:${pkgs.gnutar}/bin:${pkgs.p7zip}/bin:${pkgs.unrar}/bin:${pkgs.libnotify}/bin:${pkgs.wl-clipboard}/bin:${pkgs.coreutils}/bin:${pkgs.gnused}/bin:$PATH"

    notify() { notify-send -a "Dolphin Extract" "$1" "''${2:-}"; }

    # Dolphin (KF6) registra um serviço D-Bus por janela: org.kde.dolphin-<pid>
    services=$(qdbus | grep '^org\.kde\.dolphin-' || true)
    if [ -z "$services" ]; then
      notify "Nenhuma janela do Dolphin encontrada"
      exit 0
    fi

    # Acha o objeto MainWindow da janela ATIVA (evita pegar seleção
    # da janela errada quando há mais de um Dolphin aberto).
    active_service=""
    active_obj=""
    for service in $services; do
      objects=$(qdbus "$service" | grep '^/dolphin/Dolphin_' || true)
      for obj in $objects; do
        is_active=$(qdbus "$service" "$obj" org.kde.dolphin.MainWindow.isActiveWindow 2>/dev/null || echo "false")
        if [ "$is_active" = "true" ]; then
          active_service="$service"
          active_obj="$obj"
          break 2
        fi
      done
    done

    if [ -z "$active_service" ]; then
      notify "Nenhuma janela do Dolphin está ativa/focada"
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
