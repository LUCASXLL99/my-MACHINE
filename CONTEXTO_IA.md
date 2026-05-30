# Contexto completo — NixOS Config (lucasxll)

> Este arquivo resume tudo que é necessário para continuar trabalhando nesta configuração NixOS.
> O zip anexo contém os arquivos fonte completos.

---

## Visão geral da máquina

- **OS**: NixOS (flake-based, `hosts/nixos/default.nix`)
- **Usuário**: `lucasxll`
- **Shell**: zsh + oh-my-zsh + Starship
- **Display Manager**: SDDM (modo X11, lista sessões Wayland automaticamente)
- **WMs disponíveis**: dois, alternados pelo SDDM:
  - **Niri** (Wayland, principal/mais usado)
  - **bspwm** (X11, fallback)
- **Home Manager**: integrado ao flake, configurações em `home/lucasxll/`
- **Tema/cores**: Tokyo Night Dark via Stylix

---

## Estrutura do repositório

```
flake.nix                          ← entrada única
hosts/nixos/
  default.nix                      ← config do sistema (root): boot, pkgs, hardware, sudo, etc.
  hardware-configuration.nix       ← gerado automaticamente (não editar)
modules/nixos/
  hardware/
    kanata-keyboard/               ← remapeamento de teclado (kanata)
    bluetooth-audio.nix
    input-left-handed.nix          ← mouse/touchpad invertido
    sddm-reflect.nix
  software/
    niri.nix                       ← habilita programs.niri + xwayland-satellite no sistema
    secret-service.nix
    yazi-deps.nix
    no-keyring.nix
home/lucasxll/
  default.nix                      ← imports de todos os módulos do usuário
  modules/
    niri.nix                       ← CONFIG PRINCIPAL do niri: KDL, keybinds, waybar, systemd services
    bspwm.nix                      ← bspwm + sxhkdrc inline
    noctalia.nix                   ← noctalia-shell (barra, launcher, notif, wallpaper, lock, idle)
    terminals.nix                  ← wezterm + kitty
    polybar.nix                    ← barra para sessão bspwm
    picom.nix                      ← compositor X11
    dunst.nix                      ← notificações X11
    clipboard.nix                  ← copyq (bspwm) / noctalia clipboard (niri)
    stylix.nix                     ← tema global Tokyo Night
    zsh.nix                        ← shell + aliases (rebuild, nixgit, f, fm)
    neovim.nix, lf.nix, yazi.nix   ← editores/file managers
    mouse-invert.nix               ← serviço systemd para inverter mouse no niri
    nightlight.nix                 ← luz noturna (wlsunset para niri, gammastep fallback)
    display-mode.nix               ← scripts de modo de tela
    screen-reflect.nix
    dolphin-nord.nix
```

---

## Pacotes notáveis instalados (`hosts/nixos/default.nix`)

- `rofi` — launcher X11 (usado no bspwm e via DISPLAY=:0 no niri)
- `sxhkd` — hotkey daemon do bspwm
- `android-studio` — wrapped com `symlinkJoin` + `wrapProgram`
- `xwayland-satellite` — compatibilidade X11 dentro do niri
- `fuzzel` — launcher nativo Wayland (fallback no niri)
- `wezterm`, `kitty` — terminais
- `dolphin`, `yazi`, `lf` — gerenciadores de arquivo
- `brightnessctl`, `playerctl`, `wpctl` — controles de brilho/mídia/volume
- `flameshot`, `grim`, `slurp`, `swappy` — screenshot
- JDKs: `zulu8`, `openjdk11`, `jdk17`, `jdk21`
- `kanata-with-cmd`, `qmk`, `via`, `vial`
- `docker`, `qemu`, `virt-manager`, `libvirt`

---

## Keybinds — Niri (Super = Mod)

| Tecla | Ação |
|---|---|
| Mod+Enter / Mod+T | wezterm |
| Mod+Shift+Enter | kitty |
| Mod+D | rofi -show drun (**corrigido**) |
| Mod+Shift+D | rofi -show run |
| Mod+Space | noctalia launcher toggle (**noctalia saiu do Mod+D**) |
| Mod+R | fuzzel |
| Mod+A | android-studio (aguarda socket X1 — evita race condition) |
| Mod+E | dolphin |
| Mod+W / Mod+Shift+Q | fecha janela |
| Mod+F | maximiza coluna |
| Mod+Shift+F | fullscreen |
| Mod+H/J/K/L | foco |
| Mod+Shift+H/J/K/L | move janela |
| Mod+Alt+H/J/K/L | redimensiona |
| Mod+Ctrl+J/K | troca workspace |
| Mod+Ctrl+L | trava tela (noctalia) |
| Mod+V | clipboard noctalia |
| Mod+1–9 / Mod+Shift+1–9 | workspace |
| Mod+, / Mod+. | consume/expulsa janela de coluna |

## Keybinds — bspwm (sxhkdrc inline em `bspwm.nix`)

| Tecla | Ação |
|---|---|
| Super+Enter | wezterm |
| Super+D | rofi -show drun |
| Super+Shift+D | rofi -show run |
| Super+E | dolphin |
| Super+W / Shift+Q | fecha janela |
| Super+H/J/K/L | foco |
| Super+M | alterna layout |
| Super+F / Shift+F | fullscreen / floating |
| Super+1–9 | desktop |
| Super+V | copyq show |
| Super+Print | screenshot full |

---

## Noctalia (substitui waybar + mako + fuzzel + swww + hyprlock + swayidle)

- **Barra**: topo, compacta, fundo 92% opaco, cantos arredondados
- **Widgets esquerda**: Launcher · Clock · ActiveWindow
- **Widgets centro**: Workspace
- **Widgets direita**: Tray · NotifHistory · Battery(20%) · Volume · Brightness · ControlCenter
- **Launcher**: centro, ordenado por uso, com histórico de clipboard
- **Wallpaper**: `~/Pictures/wallpapers`, troca aleatória a cada 5min, fade 1.5s
- **Idle**: lock 5min, tela off 6min, suspend 30min
- **Night Light**: automático (pôr/nascer do sol), 3500K→6500K
- **Localização**: Fortaleza, Brasil, 24h

---

## Serviços systemd user relevantes

| Serviço | Descrição |
|---|---|
| `xwayland-satellite` | X11 em :0 para apps legados no niri. After+BindsTo=niri.service |
| `waybar` | Barra (fallback; noctalia é o principal) |
| `dunst` | Notificações (X11/bspwm) |
| `picom` | Compositor X11 |
| `mouse-invert-y` | Inverte eixo Y do mouse no niri |

O xwayland-satellite tem ExecStartPre que aguarda WAYLAND_DISPLAY no bus, e ExecStartPost que exporta `DISPLAY=:0` ao D-Bus depois que o socket `/tmp/.X11-unix/X0` aparecer.

---

## Problemas conhecidos e correções já aplicadas

### 1. `Super+D` não abria rofi no Niri — **CORRIGIDO**
**Causa**: `Mod+D` estava mapeado para `noctalia-shell ipc call launcher toggle`, não para rofi.  
**Fix**: `Mod+D` → `DISPLAY=:0 rofi -show drun`. Noctalia movido para `Mod+Space`.  
**Arquivo**: `home/lucasxll/modules/niri.nix`

### 2. Android Studio não abre pelo launcher — **CORRIGIDO**
**Causa**: O `.desktop` do android-studio (gerado pelo nixpkgs) continha o caminho absoluto do nix store original no campo `Exec=`. O `symlinkJoin` + `wrapProgram` envolvia `$out/bin/android-studio` com `DISPLAY=:1`, mas o launcher (rofi, noctalia) lia o `.desktop` e chamava o binário **original não-wrapped**, sem variáveis de ambiente. A janela nunca aparecia e nenhum erro era exibido.  
**Fix**: No `postBuild`, após o `wrapProgram`, o `.desktop` é copiado (de symlink para arquivo real) e o `Exec=` é substituído pelo caminho do wrapper via `sed`.  
**Arquivo**: `hosts/nixos/default.nix`

`Mod+A` aguarda o socket `/tmp/.X11-unix/X1` por até 10s antes de lançar, evitando race condition logo após o login (xwayland-satellite ainda subindo).

### 3. `sudo` falha com "must have setuid bit set" — **CORRIGIDO**
**Causa**: O PATH definido no bloco `environment {}` do niri não incluía `/run/wrappers/bin`. No NixOS, o `sudo` com setuid real fica em `/run/wrappers/bin/sudo`. A versão em `/run/current-system/sw/bin/sudo` é apenas um symlink para o nix store, que é montado com `nosuid`. Todo terminal aberto pelo niri (wezterm, kitty) herdava esse PATH defeituoso.  
**Fix**: `/run/wrappers/bin` adicionado **no início** do PATH no niri.  
**Arquivo**: `home/lucasxll/modules/niri.nix`

---

## Observações importantes sobre o ambiente

- O SDDM inicia o niri com PATH mínimo; o bloco `environment {}` do niri declara PATH explícito que todos os filhos herdam.
- Apps X11 (rofi, android-studio, flameshot) precisam de `DISPLAY=:0` explícito no niri — sem isso falham silenciosamente.
- O niri não carrega `.zshrc`/`.profile`; toda variável de ambiente necessária deve estar no bloco `environment {}` do KDL.
- `QT_QPA_PLATFORM=wayland` está definido no niri para apps Qt6 (Dolphin, etc.); **não** está definido `QT_QPA_PLATFORMTHEME=kde` — esse plugin causava crash silencioso.
- O `gnome-keyring` service está mascarado (`xdg-desktop-portal-gnome`) para não conflitar com o portal gtk no niri.
- O rebuild é feito via alias `rebuild` (zsh): `cd /etc/nixos && sudo git add . && sudo nixos-rebuild switch --flake .#nixos`
- O flake.nix tem inputs: `nixpkgs`, `home-manager`, `noctalia` (custom, com cachix), provavelmente `stylix`.

---

## Como aplicar as correções do zip

```bash
# 1. Copie os arquivos para /etc/nixos (ou onde está o seu flake)
sudo cp -r . /etc/nixos/

# 2. Aplique
cd /etc/nixos
sudo git add .
sudo nixos-rebuild switch --flake .#nixos
```

> **Nota**: a correção do `sudo` no PATH só funciona depois do rebuild. Antes disso, use `su -` ou acesse via TTY para rodar o rebuild.


---

## WebAssembly — Toolchain de desenvolvimento (adicionado em 2026-05-07)

### Pacotes adicionados em `hosts/nixos/default.nix`

| Pacote | Propósito |
|---|---|
| `wasm-bindgen-cli` | CLI autônoma do wasm-bindgen; re-gera bindings manualmente |
| `binaryen` | Fornece `wasm-opt` — otimiza .wasm após compilação (usado pelo wasm-pack) |
| `wabt` | Toolkit WASM: `wasm2wat`, `wasm-validate`, `wasm-objdump` para debug |
| `nodejs_22` | `npx serve .` para servidor local; ecossistema npm para bundlers |
| `cargo-watch` | Recompila automaticamente ao salvar: `cargo watch -s "wasm-pack build --target web"` |
| `cargo-generate` | Scaffolding de projetos: `cargo generate rustwasm/wasm-pack-template` |
| `cargo-edit` | Gerencia deps via CLI: `cargo add wasm-bindgen` / `cargo upgrade` |
| `llvmPackages.lld` | Linker LLVM — obrigatório para target `wasm32-unknown-unknown` |
| `mold` | Linker ultrarrápido para binários nativos (proc-macros, build-scripts) |

### Variáveis de ambiente adicionadas em `environment.sessionVariables`

| Variável | Valor | Motivo |
|---|---|---|
| `CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER` | `lld` | Cargo não encontra linker WASM sem isto |
| `CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER` | `mold` | Acelera compilação de crates nativos |
| `WASM_OPT` | `binaryen/bin/wasm-opt` | wasm-pack precisa do path explícito em sessões Niri |

### Após o rebuild — configurar rustup

```bash
# Toolchain estável + target WASM
rustup default stable
rustup target add wasm32-unknown-unknown

# Opcional: nightly para features experimentais
rustup toolchain install nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
```

### Fluxo básico de desenvolvimento

```bash
# 1. Criar projeto a partir de template oficial
cargo generate rustwasm/wasm-pack-template --name meu-projeto
cd meu-projeto

# 2. Compilar para WASM
wasm-pack build --target web --out-dir pkg

# 3. Servir localmente
python3 -m http.server 8080
# ou
npx serve .

# 4. Dev loop com reload automático
cargo watch -s "wasm-pack build --target web"
```
