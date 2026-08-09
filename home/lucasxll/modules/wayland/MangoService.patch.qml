import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Commons
import qs.Services.Keyboard

// ============================================================================
// MangoService.qml — PATCH local (NixOS /etc/nixos)
//
// O Noctalia upstream usa Quickshell.DWL (protocolo dwl-ipc-unstable-v2) para
// ler workspaces do compositor. O mangowm NÃO implementa esse protocolo (usa o
// próprio IPC `mmsg`), então DwlIpc.available=false e os workspaces nunca
// apareciam na barra ("DWL is not available" no log).
//
// Este patch troca a fonte de workspaces por `mmsg`:
//   - `mmsg watch all-tags`  → stream contínuo de JSON (workspaces 1-9)
//   - `mmsg dispatch view,N` → trocar de workspace
// A interface pública (workspaces/windows/signals) é idêntica ao upstream.
// ============================================================================

Item {
  id: root

  // ===== PUBLIC INTERFACE (CompositorService compatibility) =====

  property ListModel workspaces: ListModel {}
  property var windows: []
  property int focusedWindowIndex: -1
  property bool initialized: false

  signal workspaceChanged
  signal activeWindowChanged
  signal windowListChanged
  signal displayScalesChanged

  property string selectedMonitor: ""
  property string currentLayoutSymbol: ""

  // ===== INTERNAL =====

  QtObject {
    id: internal

    property var outputIndices: ({})
    property int outputCounter: 0
    property string lastWindowSignature: ""

    function rebuildWorkspaces(tagsData) {
      const workspaceList = [];

      if (tagsData && tagsData.all_tags) {
        for (const entry of tagsData.all_tags) {
          const outputName = entry.monitor || "DP-1";

          if (internal.outputIndices[outputName] === undefined) {
            internal.outputIndices[outputName] = internal.outputCounter++;
          }
          const outputIdx = internal.outputIndices[outputName];

          if (entry.tags) {
            for (const tag of entry.tags) {
              const tagId = (tag.index ?? 0) + 1; // index 0-based → id 1-based
              const uniqueId = outputIdx * 100 + tagId;

              if (tag.is_active) {
                root.selectedMonitor = outputName;
                root.currentLayoutSymbol = tag.layout || "T";
              }

              workspaceList.push({
                id: uniqueId,
                idx: tagId,
                name: tagId.toString(),
                output: outputName,
                isActive: !!tag.is_active,
                isFocused: !!tag.is_active,
                isUrgent: !!tag.is_urgent,
                isOccupied: (tag.client_count || 0) > 0
              });
            }
          }
        }
      }

      workspaceList.sort((a, b) => a.id - b.id);

      root.workspaces.clear();
      for (let k = 0; k < workspaceList.length; k++) {
        root.workspaces.append(workspaceList[k]);
      }
      root.workspaceChanged();
    }

    function updateWindows() {
      if (!ToplevelManager.toplevels) {
        return;
      }

      const toplevels = ToplevelManager.toplevels.values;
      const windowList = [];
      let newFocusedIdx = -1;

      for (let i = 0; i < toplevels.length; i++) {
        const toplevel = toplevels[i];
        if (!toplevel || toplevel.outliers) {
          continue;
        }

        const appId = toplevel.appId || toplevel.wayland?.appId || "";
        const title = toplevel.title || toplevel.wayland?.title || "";
        const isFocused = !!toplevel.activated;

        let outputName = root.selectedMonitor || "DP-1";
        if (toplevel.screens && toplevel.screens.length > 0) {
          outputName = toplevel.screens[0].name;
        }

        if (internal.outputIndices[outputName] === undefined) {
          internal.outputIndices[outputName] = internal.outputCounter++;
        }

        // Tag da janela: usa o workspace focado desse output
        let tagId = 1;
        for (let w = 0; w < root.workspaces.count; w++) {
          const ws = root.workspaces.get(w);
          if (ws.output === outputName && ws.isFocused) {
            tagId = ws.idx;
            break;
          }
        }

        const workspaceId = internal.outputIndices[outputName] * 100 + tagId;

        windowList.push({
          id: `${outputName}:${appId}:${title}:${i}`,
          title: title,
          appId: appId,
          class: appId,
          workspaceId: workspaceId,
          isFocused: isFocused,
          output: outputName,
          handle: toplevel,
          fullscreen: toplevel.fullscreen || false,
          floating: toplevel.maximized === false && toplevel.fullscreen === false
        });

        if (isFocused) {
          newFocusedIdx = windowList.length - 1;
        }
      }

      const signature = JSON.stringify(windowList.map(w => w.id + w.workspaceId + w.isFocused));
      if (signature !== internal.lastWindowSignature) {
        internal.lastWindowSignature = signature;
        root.windows = windowList;
        root.windowListChanged();
      }

      if (newFocusedIdx !== root.focusedWindowIndex) {
        root.focusedWindowIndex = newFocusedIdx;
        root.activeWindowChanged();
      }
    }
  }

  // ===== WATCH: stream contínuo de tags via mmsg =====

  Process {
    id: tagsWatcher
    command: ["mmsg", "watch", "all-tags"]
    running: false

    stdout: SplitParser {
      onRead: line => {
                if (!line) {
                  return;
                }
                try {
                  internal.rebuildWorkspaces(JSON.parse(line));
                } catch (e) {
                  // linha parcial entre frames; ignora
                }
                internal.updateWindows();
              }
    }

    onExited: code => {
                Logger.w("MangoService", "mmsg watch all-tags saiu (code " + code + "), reiniciando");
                if (root.initialized) {
                  restartTimer.start();
                }
              }
  }

  Timer {
    id: restartTimer
    interval: 3000
    onTriggered: {
      tagsWatcher.running = false;
      tagsWatcher.running = true;
    }
  }

  // ===== PROCESSES =====

  // Escalas dos monitores via mmsg all-monitors
  property QtObject _scaleQuery: Process {
    id: scaleQuery
    command: ["mmsg", "get", "all-monitors"]

    property string buffer: ""

    stdout: SplitParser {
      onRead: line => {
                scaleQuery.buffer += line + "\n";
              }
    }

    onExited: code => {
                if (code === 0) {
                  scalesImpl.processAllMonitors(scaleQuery.buffer);
                  scaleQuery.buffer = "";
                }
              }
  }

  // ===== TOPLEVEL MANAGER =====

  property QtObject _toplevelConnection: Connections {
    target: ToplevelManager.toplevels
    function onValuesChanged() {
      internal.updateWindows();
    }
  }

  // ===== SCALES (mmsg all-monitors) =====

  QtObject {
    id: scalesImpl

    function processAllMonitors(raw) {
      try {
        const data = JSON.parse(raw);
        const monitors = data.monitors || data.all_monitors || [];
        const scalesMap = {};
        for (const m of monitors) {
          scalesMap[m.name] = {
            name: m.name,
            scale: m.scale || 1.0,
            width: m.width || 0,
            height: m.height || 0,
            x: m.x || 0,
            y: m.y || 0
          };
        }
        if (CompositorService && CompositorService.onDisplayScalesUpdated) {
          CompositorService.onDisplayScalesUpdated(scalesMap);
        }
        root.displayScalesChanged();
      } catch (e) {
        Logger.e("MangoService", "Falha ao processar all-monitors:", e);
      }
    }
  }

  // ===== PUBLIC FUNCTIONS =====

  function initialize() {
    if (initialized) {
      return;
    }

    Logger.i("MangoService", "Inicializando integração Mango (mmsg IPC, patch local)");

    scaleQuery.running = true;
    tagsWatcher.running = true;
    safetyTimer.start();

    initialized = true;
  }

  Timer {
    id: safetyTimer
    interval: 15000
    repeat: true
    onTriggered: {
      if (!tagsWatcher.running) {
        tagsWatcher.running = true;
      }
    }
  }

  function queryDisplayScales() {
    scaleQuery.running = true;
  }

  function switchToWorkspace(workspace) {
    const tagId = workspace.idx || workspace.id || 1;
    Quickshell.execDetached(["mmsg", "dispatch", "view," + tagId]);
  }

  function focusWindow(window) {
    if (window && window.handle) {
      window.handle.activate();
    } else if (window.workspaceId) {
      const tagId = (window.workspaceId % 100);
      if (tagId > 0) {
        Quickshell.execDetached(["mmsg", "dispatch", "view," + tagId]);
      }
    }
  }

  function closeWindow(window) {
    if (window && window.handle) {
      window.handle.close();
    } else {
      Quickshell.execDetached(["mmsg", "dispatch", "killclient"]);
    }
  }

  function turnOffMonitors() {
    Quickshell.execDetached(["mmsg", "dispatch", "disable_monitor," + (root.selectedMonitor || "eDP-1")]);
  }

  function turnOnMonitors() {
    Quickshell.execDetached(["mmsg", "dispatch", "enable_monitor," + (root.selectedMonitor || "eDP-1")]);
  }

  function logout() {
    Quickshell.execDetached(["mmsg", "dispatch", "quit"]);
  }

  function cycleKeyboardLayout() {
    Logger.w("MangoService", "Keyboard layout cycling not supported");
  }

  function getFocusedScreen() {
    return null;
  }

  function spawn(command) {
    try {
      const cmd = Array.isArray(command) ? command.join(" ") : String(command);
      Quickshell.execDetached(["mmsg", "dispatch", "spawn_shell," + cmd]);
    } catch (e) {
      Logger.e("MangoService", "Falha ao spawn command:", e);
    }
  }
}
