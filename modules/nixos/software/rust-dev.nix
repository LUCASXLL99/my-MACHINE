# modules/nixos/software/rust-dev.nix
# Ferramentas Rust: nativas, web/backend, WASM, banco de dados.

{ pkgs, pkgs-unstable, ... }:

{
  environment.sessionVariables = {
    # Necessário para crates com bindgen (ring, aws-lc-rs, rdkafka…)
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";

    # Necessário para sqlx/diesel com feature postgres
    PQ_LIB_DIR = "${pkgs.postgresql.lib}/lib";

    SCCACHE_CACHE_SIZE = "10G";
  };

  environment.systemPackages = with pkgs; [
    # Build de crates C-heavy
    cmake
    ninja
    clang
    libclang
    perl        # openssl-sys usa perl no build.rs

    # Banco de dados
    postgresql  # libpq + psql + pg_config
    redis
    sqlite
    (diesel-cli.override {
      sqliteSupport     = true;
      postgresqlSupport = true;
      mysqlSupport      = false;
    })

    # Cache de compilação (configurado em cargo-config.nix)
    sccache

    # Dev loop
    bacon       # substituto do cargo-watch focado em erros/warnings

    # Protobuf / gRPC
    protobuf    # protoc — necessário para prost + tonic
    grpcurl

    # Qualidade de código
    pkgs-unstable.cargo-deny  # licenças, advisories, deps duplicadas
    cargo-udeps               # detecta deps não usadas (requer nightly)
    cargo-tarpaulin           # cobertura de testes
  ];

  # Para ativar PostgreSQL/Redis local, descomentar:
  # services.postgresql = {
  #   enable  = true;
  #   package = pkgs.postgresql;
  #   authentication = pkgs.lib.mkOverride 10 ''
  #     local all all trust
  #     host  all all 127.0.0.1/32 trust
  #   '';
  # };
  # services.redis.servers."dev" = { enable = true; port = 6379; };
}
