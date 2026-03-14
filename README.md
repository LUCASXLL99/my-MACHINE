# nixos-config — Guia completo

## Estrutura do repositório

```
nixos-config/
│
├── flake.nix                          ← entrada única, todas as deps versionadas
│
├── hosts/
│   └── nixos/                         ← configuração desta máquina
│       ├── default.nix                ← sistema (root): boot, rede, hardware, users
│       └── hardware-configuration.nix ← gerado pelo nixos-generate-config (não edite)
│
├── modules/
│   └── nixos/
│       ├── hardware/                  ← módulos de hardware do SISTEMA
│       │   ├── input-left-handed.nix  ← mouse/touchpad invertido
│       │   ├── screen-reflect-x.nix  ← tela espelhada no login
│       │   └── kanata-keyboard.nix   ← remapeamento de teclado
│       └── software/                  ← módulos de software do SISTEMA
│           ├── secret-service.nix     ← gnome-keyring (Vivaldi, VSCode, etc.)
│           └── yazi-deps.nix          ← dependências de sistema para o yazi
│
└── home/
    └── lucasxll/                      ← tudo do usuário (Home Manager)
        ├── default.nix                ← entrada: importa todos os módulos
        └── modules/
            ├── bspwm.nix              ← window manager + startup
            ├── polybar.nix            ← barra dark
            ├── picom.nix              ← compositor (blur, sombras, bordas)
            ├── dunst.nix              ← notificações
            ├── gammastep.nix          ← modo noturno 18:00→2000K
            ├── clipboard.nix          ← greenclip (super + v)
            ├── yazi.nix               ← gerenciador terminal (tema + atalhos)
            ├── files.nix              ← thunar + plugins
            └── zsh.nix                ← shell + aliases (f, fm, flip-x, flip-reset)
```

---

## Como instalar do zero

### 1. Copiar para /etc/nixos

```bash
sudo cp -r nixos-config/* /etc/nixos/
```

### 2. Copiar seu hardware-configuration.nix real

```bash
sudo cp /etc/nixos/hardware-configuration.nix \
        /etc/nixos/hosts/nixos/hardware-configuration.nix
```

### 3. Copiar seu kanata-keyboard.nix original

```bash
sudo cp SEU_KANATA.nix \
        /etc/nixos/modules/nixos/hardware/kanata-keyboard.nix
```

### 4. Criar pasta de wallpapers

```bash
mkdir -p ~/Pictures/wallpapers
# Adicione imagens simétricas: florestas, montanhas, reflexo em lago, céu noturno
```

### 5. Primeiro rebuild com flake

```bash
cd /etc/nixos
sudo nixos-rebuild switch --flake .#nixos
```

---

## Comandos do dia a dia

| Comando | O que faz |
|---------|-----------|
| `sudo nixos-rebuild switch --flake .#nixos` | Aplica mudanças do sistema |
| `nix flake update` | Atualiza todas as dependências |
| `nix flake update nixpkgs` | Atualiza só o nixpkgs |
| `sudo nix-collect-garbage -d` | Limpa gerações antigas |
| `nix-env --list-generations` | Lista gerações disponíveis |
| `sudo nixos-rebuild switch --rollback` | Volta para a geração anterior |

---

## Como ativar/desativar módulos

Cada funcionalidade é um módulo separado. Para desativar, **comente o import**:

**Módulos do sistema** → `hosts/nixos/default.nix`:
```nix
imports = [
  # ../../modules/nixos/hardware/screen-reflect-x.nix  ← desativado
    ../../modules/nixos/hardware/input-left-handed.nix
];
```

**Módulos do usuário** → `home/lucasxll/default.nix`:
```nix
imports = [
  # ./modules/gammastep.nix   ← modo noturno desativado
    ./modules/bspwm.nix
];
```

Depois: `sudo nixos-rebuild switch --flake .#nixos`

---

## Filosofia

- **Tudo declarativo** — nenhuma config manual em `~/.config` (exceto wallpapers)
- **Separação sistema/usuário** — `hosts/` precisa de root, `home/` é do usuário
- **Módulos independentes** — cada feature é um arquivo, ativa/desativa com um comentário
- **Versionado no git** — qualquer mudança é rastreável e revertível
- **Sem duplicata de nixpkgs** — `inputs.nixpkgs.follows` garante um único nixpkgs
- **GC automático** — gerations mais antigas de 14 dias são removidas toda semana
