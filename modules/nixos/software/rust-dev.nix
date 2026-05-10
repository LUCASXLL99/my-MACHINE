{ pkgs, ... }:
{
  environment.sessionVariables = {
    LIBCLANG_PATH      = "${pkgs.libclang.lib}/lib";
    PQ_LIB_DIR         = "${pkgs.postgresql.lib}/lib";
    RUSTC_WRAPPER      = "${pkgs.sccache}/bin/sccache";
    SCCACHE_CACHE_SIZE = "10G";
  };
  environment.systemPackages = with pkgs; [
    cmake ninja clang libclang llvmPackages.clang-unwrapped perl
    postgresql redis sqlite
    (diesel-cli.override {
      sqliteSupport   = true;
      postgresSupport = true;
      mysqlSupport    = false;
    })
    sccache bacon protobuf grpcurl
    cargo-deny cargo-udeps cargo-tarpaulin
  ];
}
