# ─────────────────────────────────────────────────────────────
# dolphin-extract.nix
# Script "dolphin-extract-selected": pega o(s) item(ns) selecionado(s)
# na janela ativa do Dolphin via D-Bus e, se for .zip/.tar(.gz|.bz2|.xz)/
# .rar, extrai automaticamente na mesma pasta. Ligado ao Ctrl+Alt+E
# no niri (ver modules/wayland/niri.nix).
# ─────────────────────────────────────────────────────────────
{ pkgs, ... }:

let
  dolphin-extract-selected = pkgs.writeShellScriptBin "dolphin-extract-selected" ''
    set -uo pipefail
    export PATH="${pkgs.kdePackages.qttools}/bin:${pkgs.unzip}/bin:${pkgs.gnutar}/bin:${pkgs.p7zip}/bin:${pkgs.unrar}/bin:${pkgs.libnotify}/bin:${pkgs.coreutils}/bin:${pkgs.gnused}/bin:$PATH"

    notify() { notify-send -a "Dolphin Extract" "$1" "''${2:-}"; }

    # Dolphin (KF6) registra um serviço D-Bus por janela: org.kde.dolphin-<pid>
    services=$(qdbus | grep '^org\.kde\.dolphin-' || true)
    if [ -z "$services" ]; then
      notify "Nenhuma janela do Dolphin encontrada"
      exit 0
    fi

    got_any=0

    for service in $services; do
      # Cada janela pode ter várias views (Dolphin_1, Dolphin_2, ...) —
      # tentamos todas e ficamos com quem responder itens selecionados.
      objects=$(qdbus "$service" | grep '^/dolphin/Dolphin_' || true)
      for obj in $objects; do
        items=$(qdbus "$service" "$obj" org.kde.dolphin.MainWindow.selectedItems 2>/dev/null || true)
        [ -z "$items" ] && continue

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
      done
    done

    if [ "$got_any" -eq 0 ]; then
      notify "Nada selecionado no Dolphin"
    fi
  '';
in
{
  home.packages = [ dolphin-extract-selected pkgs.unrar pkgs.p7zip ];
}
