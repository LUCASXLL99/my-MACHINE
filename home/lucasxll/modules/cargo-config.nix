# home/lucasxll/modules/cargo-config.nix
# Configuração global do Cargo: sccache como rustc-wrapper (instalado em rust-dev.nix),
# mold como linker nativo e lld para WASM.

{ pkgs, ... }:
{
  home.file.".cargo/config.toml".text = ''
    [build]
    rustc-wrapper = "${pkgs.sccache}/bin/sccache"

    [target.x86_64-unknown-linux-gnu]
    linker = "${pkgs.clang}/bin/clang"
    rustflags = [
      "-L${pkgs.stdenv.cc.cc.lib}/lib",
      "-L${pkgs.glibc}/lib",
      "-L${pkgs.zlib}/lib",
      "-Clink-arg=-fuse-ld=mold",
    ]

    [target.wasm32-unknown-unknown]
    linker = "${pkgs.llvmPackages.lld}/bin/lld"

    [term]
    color = "never"
  '';
}
