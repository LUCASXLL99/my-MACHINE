# ─────────────────────────────────────────────────────────────
# dolphin-extract.nix
# Script "dolphin-extract-selected": pega o(s) item(ns) selecionado(s)
# na janela ATIVA do Dolphin e, se for .zip/.tar(.gz|.bz2|.xz)/.rar/.7z,
# extrai automaticamente na mesma pasta. Ligado ao Ctrl+Alt+E no mango
# (ver modules/wayland/mango.nix).
#
# NOTA: o método D-Bus org.kde.dolphin.MainWindow.selectedItems() foi
# removido nas versões atuais do Dolphin (KF6, testado 6.9.3) — a
# interface não expõe mais consulta direta de seleção. Como contorno,
# disparamos a ação "edit_copy" (Ctrl+C) via D-Bus na janela ativa do
# Dolphin, o que põe os itens selecionados na área de transferência
# como text/uri-list, e lemos isso com wl-paste (Wayland).
#
# NOTA 2: org.kde.dolphin.MainWindow.isActiveWindow() SEMPRE retornava
# false no niri (testado) — mango provavelmente tem o mesmo problema
# (nenhum compositor wlroots/dwl repassa isso certo pro Qt). Por isso
# descobrimos a janela focada perguntando pro PRÓPRIO mango via IPC
# (`mmsg get focusing-client`), que deve reportar appid e pid, e
# casamos o pid com o nome do serviço D-Bus org.kde.dolphin-<pid>.
#
# PORTADO niri → mango: troquei `niri msg --json focused-window` por
# `mmsg get focusing-client`. Os nomes exatos dos campos no JSON de
# retorno do mmsg eu não confirmei ao vivo (não consigo testar aqui) —
# tentei `appid` primeiro (nome usado nas windowrule do mango) com
# fallback pra `app_id`, e `pid` como no niri. Se não bater, veja o log
# em /tmp/dolphin-extract-debug.log (a linha "focused-client: ...") e
# ajusta os `jq -r` abaixo pros nomes de campo reais.
# ─────────────────────────────────────────────────────────────
{ pkgs, ... }:

let
  dolphin-extract-selected = pkgs.writeShellScriptBin "dolphin-extract-selected" ''
    set -uo pipefail
    export PATH="${pkgs.kdePackages.qttools}/bin:${pkgs.unzip}/bin:${pkgs.gnutar}/bin:${pkgs.p7zip}/bin:${pkgs.unrar}/bin:${pkgs.libnotify}/bin:${pkgs.wl-clipboard}/bin:${pkgs.coreutils}/bin:${pkgs.gnused}/bin:${pkgs.jq}/bin:$PATH"

    notify() { notify-send -a "Dolphin Extract" "$1" "''${2:-}"; }

    log="/tmp/dolphin-extract-debug.log"
    { echo "── run $(date '+%H:%M:%S') ──"; echo "DBUS_SESSION_BUS_ADDRESS=''${DBUS_SESSION_BUS_ADDRESS:-<unset>}"; } >> "$log"

    # Pergunta pro mango qual é a janela focada (isActiveWindow do Qt não
    # deve funcionar no mango também, ver NOTA 2 acima).
    focused=$(mmsg get focusing-client 2>/dev/null || true)
    if [ -z "$focused" ] || [ "$focused" = "null" ]; then
      notify "Nenhuma janela focada"
      exit 0
    fi

    app_id=$(printf '%s' "$focused" | jq -r '.appid // .app_id // empty')
    pid=$(printf '%s' "$focused" | jq -r '.pid // empty')
    echo "focused-client: $focused" >> "$log"

    if [ "$app_id" != "org.kde.dolphin" ] || [ -z "$pid" ]; then
      notify "A janela focada não é o Dolphin"
      exit 0
    fi

    active_service="org.kde.dolphin-$pid"
    all_services=$(qdbus 2>>"$log")
    echo "qdbus services: $(printf '%s' "$all_services" | tr '\n' ' ')" >> "$log"

    # Confirma que o serviço D-Bus correspondente existe e acha seu
    # objeto MainWindow (/dolphin/Dolphin_N).
    if ! printf '%s\n' "$all_services" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | grep -qx "$active_service"; then
      notify "Dolphin focado (pid $pid), mas serviço D-Bus não encontrado"
      exit 0
    fi

    all_objs=$(qdbus "$active_service" 2>>"$log")
    echo "objects for $active_service: $(printf '%s' "$all_objs" | tr '\n' ' ')" >> "$log"

    active_obj=$(printf '%s' "$all_objs" | grep -m1 '^/dolphin/Dolphin_[0-9]*$' || true)

    if [ -z "$active_obj" ]; then
      notify "Não achei o objeto MainWindow do Dolphin"
      echo "ERRO: active_obj vazio (padrão /dolphin/Dolphin_N não encontrado na lista acima)" >> "$log"
      exit 0
    fi
    echo "active_obj=$active_obj" >> "$log"

    # Guarda o conteúdo atual da área de transferência pra restaurar depois
    old_clip=$(wl-paste -t text/uri-list 2>/dev/null || true)
    echo "old_clip=$old_clip" >> "$log"

    # Dispara "copiar" (Ctrl+C) na janela ativa via D-Bus
    copy_out=$(qdbus "$active_service" "$active_obj" org.kde.KMainWindow.activateAction edit_copy 2>&1)
    copy_rc=$?
    echo "activateAction edit_copy rc=$copy_rc out=$copy_out" >> "$log"
    sleep 0.15

    items=$(wl-paste -t text/uri-list 2>/dev/null || true)
    echo "items after copy: [$items]" >> "$log"

    got_any=0

    if [ -n "$items" ]; then
        while IFS= read -r url; do
          url="''${url%$'\r'}"
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
    echo "got_any=$got_any (fim do run)" >> "$log"
  '';
in
{
  home.packages = [ dolphin-extract-selected pkgs.unrar pkgs.p7zip pkgs.wl-clipboard ];
}
