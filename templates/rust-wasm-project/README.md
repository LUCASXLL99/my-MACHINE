# Template Rust/WASM — Armadilhas Corrigidas

Este template já incorpora os fixes para as 7 armadilhas documentadas.

## O que está corrigido aqui

| Armadilha | Arquivo | Fix |
|---|---|---|
| 1 — mold incompatível com wasm-pack | `hosts/nixos/default.nix` | `CARGO_TARGET_X86_64` usa `lld` em vez de `mold` |
| 2 — wasm-opt falha na validação | `Cargo.toml` | `wasm-opt = false` no profile release |
| 3 — Scripts inline bloqueados por CSP | `index.html` | Placeholders de hash SHA-256 na CSP |
| 4 — frame-ancestors ignorado no `<meta>` | `index.html` | Removido; proteção via script inline |
| 5 — sessionVariables não refletem no terminal | `hosts/nixos/default.nix` | `RUST_LOG` e `RUST_BACKTRACE` adicionados |
| 6 — features web-sys faltando | `Cargo.toml` | Lista de features comentada e documentada |
| 7 — rustup target não persiste | `home/.../zsh.nix` | Alias `wasm-setup` adicionado |

## Uso rápido

```bash
# 1. Aplique a config NixOS
rebuild

# 2. Abra terminal NOVO e configure rustup (armadilha 7)
wasm-setup

# 3. Build do projeto (armadilha 1 já corrigida no environment)
cd ~/rustteste/seuProjeto
wbuild

# 4. Sirva e verifique CSP no browser (armadilha 3)
wserve
# Abra http://localhost:8080 → F12 → console
# Copie os hashes de erro e cole no index.html
```

## Se wasm-opt ainda falhar (armadilha 2)

Já está desabilitado no `Cargo.toml` deste template via:
```toml
[package.metadata.wasm-pack.profile.release]
wasm-opt = false
```

## Checklist novo projeto

- [ ] `wasm-setup` (rustup target)
- [ ] Copiar este `Cargo.toml` e ajustar `name`
- [ ] Adicionar features `web-sys` necessárias
- [ ] Copiar `index.html`, buildar, copiar hashes do console
- [ ] Remover `frame-ancestors` do `<meta>` (já feito aqui)
