# modules/nixos/software/rust-dev.nix
#
# Tudo que faltava para desenvolvimento Rust completo:
#   aplicações nativas, serviços web/backend, WASM, banco de dados.
#
# Importar em hosts/nixos/default.nix:
#   ../../modules/nixos/software/rust-dev.nix

{ pkgs, ... }:

{
  # ── VARIÁVEIS DE AMBIENTE ────────────────────────────────────────
  environment.sessionVariables = {

    # ── bindgen / FFI ────────────────────────────────────────────────
    # Crates que geram bindings C (ring, aws-lc-rs, rdkafka, rocksdb…)
    # usam bindgen internamente. No NixOS, o clang não fica num caminho
    # padrão — sem LIBCLANG_PATH o bindgen falha com "libclang not found"
    # mesmo com clang instalado no PATH.
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";

    # ── PostgreSQL (libpq) ───────────────────────────────────────────
    # crates: sqlx (postgres feature), diesel (postgres feature), tokio-postgres
    # O build.rs desses crates chama pg_config ou busca a lib diretamente.
    # Sem isso: "could not find native static library `pq`"
    PQ_LIB_DIR = "${pkgs.postgresql.lib}/lib";

    # ── sccache — cache de compilação ───────────────────────────────
    # Com sccache, o Cargo reutiliza objetos compilados entre projetos.
    # Em projetos grandes (axum + tokio + sqlx + serde) o cold build
    # cai de ~8min para ~1min nos subsequentes.
    # RUSTC_WRAPPER instrui o Cargo a passar cada invocação pelo sccache.
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";

    # Cache local do sccache (padrão: ~/.cache/sccache, ~10GB máximo)
    # Para usar cache remota (S3, GCS): configure SCCACHE_BUCKET aqui.
    SCCACHE_CACHE_SIZE = "10G";
  };

  # ── PACOTES DO SISTEMA ──────────────────────────────────────────
  environment.systemPackages = with pkgs; [

    # ── Build nativa de crates C-heavy ──────────────────────────────
    # cmake: necessário para crates como aws-lc-sys, rdkafka, rocksdb,
    # prost-build (gRPC), e qualquer build.rs que chame cmake.
    cmake

    # ninja: backend de build ultrarrápido, usado pelo cmake quando disponível.
    ninja

    # clang + libclang: compilador C/C++ e biblioteca de parsing.
    # clang       → compilador (para crates que compilam código C no build.rs)
    # libclang    → biblioteca que o bindgen usa para parsear headers C
    # clang-tools → clangd LSP, clang-format, clang-tidy (opcional mas útil)
    clang
    libclang
    llvmPackages.clang-unwrapped

    # perl: o crate openssl-sys usa perl no build.rs para configurar o build.
    # Sem perl: "Can't locate FindBin.pm" durante `cargo build`.
    perl

    # ── Banco de dados ───────────────────────────────────────────────
    # PostgreSQL — servidor local para desenvolvimento
    # Não precisa rodar como serviço: use `pg_ctl` ou Docker.
    # O que importa aqui são as libs (libpq) e o cliente (psql).
    postgresql   # inclui psql, pg_dump, libpq, pg_config

    # Redis — servidor local + cliente CLI
    # Crates: redis, deadpool-redis, fred
    redis        # inclui redis-server e redis-cli

    # SQLite — banco embutido, muito usado em projetos menores
    # Crates: rusqlite, sqlx (sqlite feature)
    sqlite

    # diesel-cli com suporte a postgres + sqlite (os mais comuns)
    # Alternativa ao sqlx-cli para quem usa o ORM Diesel.
    # Compilar com features específicas evita dependências desnecessárias.
    (diesel-cli.override {
      sqliteSupport   = true;
      postgresSupport = true;
      mysqlSupport    = false;
    })

    # ── Cache de compilação ──────────────────────────────────────────
    # sccache (Mozilla) — o mais compatível com Rust no NixOS.
    # Configurado via RUSTC_WRAPPER acima.
    # Limpar o cache: sccache --stop-server && rm -rf ~/.cache/sccache
    # Estatísticas: sccache --show-stats
    sccache

    # ── Dev loop melhorado ───────────────────────────────────────────
    # bacon — substituto do cargo-watch focado em erros/warnings.
    # Interface limpa que mostra só o que importa, sem scroll infinito.
    # uso: bacon           → watch + build
    #      bacon test      → watch + test
    #      bacon clippy    → watch + clippy
    #      bacon doc       → watch + doc
    # Configurado por projeto em bacon.toml (gerado com: bacon --init)
    bacon

    # ── Protobuf / gRPC ─────────────────────────────────────────────
    # protobuf: compilador protoc, necessário para crates prost + tonic.
    # prost-build e tonic-build chamam protoc no build.rs automaticamente.
    # Sem isso: "protoc: command not found" ao compilar serviços gRPC.
    protobuf

    # grpcurl — cliente gRPC de linha de comando (como curl para gRPC).
    # Testa endpoints gRPC sem precisar escrever código cliente.
    # uso: grpcurl -plaintext localhost:50051 list
    grpcurl

    # ── Ferramentas de qualidade de código ──────────────────────────
    # cargo-deny — verifica licenças, advisories e deps duplicadas.
    # Bloqueia dependências banidas antes do deploy.
    # uso: cargo deny check
    # Configurado em deny.toml na raiz do projeto.
    cargo-deny

    # cargo-udeps — detecta dependências declaradas mas não usadas.
    # Requer nightly: cargo +nightly udeps
    # Mantém o Cargo.toml limpo e reduz tempo de compilação.
    cargo-udeps

    # cargo-tarpaulin — cobertura de testes em Linux.
    # Gera relatório HTML ou XML (CI).
    # uso: cargo tarpaulin --out Html
    cargo-tarpaulin

    # ── nix-ld: libs adicionais para binários ELF externos ──────────
    # Já configurado no default.nix, mas precisamos adicionar libpq e
    # openssl para ferramentas externas que linkam dinamicamente.
    # (declarado via programs.nix-ld.libraries no default.nix — ver patch)
  ];

  # ── SERVIÇOS LOCAIS DE DESENVOLVIMENTO ─────────────────────────
  # PostgreSQL local — desativado por padrão para não consumir recursos.
  # Para ativar: descomentar e fazer rebuild.
  # Depois: createuser -s lucasxll; createdb lucasxll
  #
  # services.postgresql = {
  #   enable  = true;
  #   package = pkgs.postgresql;
  #   authentication = pkgs.lib.mkOverride 10 ''
  #     local all all trust
  #     host  all all 127.0.0.1/32 trust
  #   '';
  # };

  # Redis local — idem, desativado por padrão.
  # Para ativar: descomentar e fazer rebuild.
  # Depois: redis-cli ping
  #
  # services.redis.servers."dev" = {
  #   enable = true;
  #   port   = 6379;
  # };
}
