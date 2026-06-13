# modules/nixos/software/rust-dev.nix
# Ferramentas Rust: nativas, web/backend, WASM, banco de dados.

{ pkgs, pkgs-unstable, ... }:

{
  environment.sessionVariables = {
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";

    PQ_LIB_DIR = "${pkgs.postgresql.lib}/lib";

    SCCACHE_CACHE_SIZE = "10G";
  };

  environment.systemPackages = with pkgs; [
    cmake
    ninja
    clang
    libclang
    perl        # openssl-sys usa perl no build.rs

    postgresql
    redis
    sqlite
    (diesel-cli.override {
      sqliteSupport     = true;
      postgresqlSupport = true;
      mysqlSupport      = false;
    })

    sccache

    bacon

    protobuf
    grpcurl

    pkgs-unstable.cargo-deny
    cargo-udeps
    cargo-tarpaulin
  ];

}
