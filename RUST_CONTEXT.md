# RUST_CONTEXT

## sistema
NixOS 25.05 flake-based, x86_64, kernel 6.1 LTS, Wayland/niri

## toolchain rust
- rustup: stable 1.95.0 + nightly (nightly só para cargo-udeps)
- targets: x86_64-unknown-linux-gnu, wasm32-unknown-unknown
- linker nativo: clang + mold (via CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS)
- linker WASM: lld (via CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER)
- cache: sccache (RUSTC_WRAPPER ativo via rust-dev.nix)
- LIBCLANG_PATH definido (bindgen funciona)
- PQ_LIB_DIR definido (sqlx/diesel postgres funciona)
- CARGO_TERM_COLOR=never (erros sem ANSI — menores para colar no Claude)

## .cargo/config.toml global (~/.cargo/config.toml)
[build]
rustc-wrapper = "sccache"

[target.x86_64-unknown-linux-gnu]
linker = "clang"
rustflags = ["-C", "link-arg=-fuse-ld=mold"]

[target.wasm32-unknown-unknown]
linker = "lld"

ATENÇÃO: não definir rustflags neste arquivo para x86_64 se
CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS já estiver setado —
a variável de ambiente tem precedência e o config.toml é ignorado.

## ferramentas disponíveis
cargo-watch, cargo-generate, cargo-edit, cargo-deny, cargo-udeps, cargo-tarpaulin
wasm-bindgen-cli 0.2.100, wasm-opt (binaryen), wabt
wasm-pack, trunk 0.21.14
sqlx-cli, diesel-cli (sqlite+postgres)
bacon, sccache, protobuf, grpcurl
cmake, clang, libclang, perl, ninja
postgresql, redis, sqlite (libs + clients)
docker, qemu, virt-manager

## editor
neovim com rust-analyzer (LSP), codelldb (DAP), clippy on save, procMacro on
formatter: rustfmt via conform-nvim

## aliases úteis
wbuild, wserve, wwatch, wclean, wasm-setup  (wasm dev loop)
cb    = cargo build --message-format=short 2>&1  (erros compactos)
cbr   = RUST_LOG=debug RUST_BACKTRACE=1 cargo run 2>&1
cerr  = filtra só linhas error do build (ideal para colar no Claude)
cw    = clippy compacto (só erros/warnings, max 60 linhas)
rebuild = nixos-rebuild switch --flake .#nixos

## regras para respostas
sem imagens, sem diagramas, sem emojis
código ultra compacto: máximo na mesma linha, sem comentários, sem linhas vazias, nomes curtos
só código quando pedido, sem explicações antes ou depois
foco total no projeto, zero abstração
economia de tokens acima de legibilidade

## formato de código rust esperado
fn main(){let x=vec![1,2,3];x.iter().for_each(|n|println!("{}",n));}

## stack por tipo de projeto

site/webapp:
- backend: axum + tokio + tower
- db: sqlx (async) ou diesel
- template: askama ou minijinja
- assets: tower-http ServeDir

wasm/frontend:
- leptos ou yew
- wasm-bindgen = "=0.2.100" (VERSÃO EXATA — bater com wasm-bindgen-cli)
- trunk para dev server
- .cargo/config.toml local com target wasm32-unknown-unknown

api/serviço:
- axum + serde_json
- authn: jsonwebtoken ou axum-login
- grpc: tonic + prost

minijogo:
- macroquad (simples, wasm-ready)
- ou bevy (ECS, mais pesado)

## como passar erros de compilação para o Claude
# Opção 1 — mais compacto (recomendado)
cb 2>&1 | head -80

# Opção 2 — só as linhas de erro
cerr

# Opção 3 — clippy compacto
cw

# NÃO colar saída de `cargo build` sem filtro — tem ANSI, unicode boxes,
# notas longas e hints que consomem contexto sem agregar informação.
