# modules/nixos/software/rust-dev.nix
# Ferramentas Rust: apps nativos, web/backend, WASM, banco de dados.

{ pkgs, pkgs-unstable, ... }:

{
  environment.sessionVariables = {
    # bindgen precisa de LIBCLANG_PATH no NixOS (caminho não-padrão)
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";

    # sqlx/diesel/tokio-postgres — evita "could not find native static library `pq`"
    PQ_LIB_DIR = "${pkgs.postgresql.lib}/lib";

    SCCACHE_CACHE_SIZE = "10G";
  };

  environment.systemPackages = with pkgs; [
    # Build de crates C-heavy
    cmake ninja
    clang libclang   # clang para build.rs; libclang para bindgen
    perl             # openssl-sys usa perl no build.rs

    # Banco de dados
    postgresql       # psql, libpq, pg_config
    redis
    sqlite
    (diesel-cli.override {
      sqliteSupport     = true;
      postgresqlSupport = true;
      mysqlSupport      = false;
    })

    # Cache de compilação (wrapper em cargo-config.nix)
    sccache

    # Dev loop
    bacon            # substituto do cargo-watch focado em erros

    # Protobuf / gRPC
    protobuf         # protoc para prost/tonic
    grpcurl          # testa endpoints gRPC

    # Qualidade de código
    pkgs-unstable.cargo-deny   # licenças, advisories, deps duplicadas
    cargo-udeps      # dependências não usadas (requer nightly)
    cargo-tarpaulin  # cobertura de testes
  ];

  # PostgreSQL e Redis locais desativados por padrão (descomentar para ativar):
  # services.postgresql = { enable = true; package = pkgs.postgresql;
  #   authentication = pkgs.lib.mkOverride 10 ''local all all trust\nhost all all 127.0.0.1/32 trust''; };
  # services.redis.servers."dev" = { enable = true; port = 6379; };
}
