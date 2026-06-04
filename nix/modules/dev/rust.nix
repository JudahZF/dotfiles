{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    cargo-edit
    cargo-watch
    cargo-nextest
    cargo-audit
    cargo-expand
    pkg-config
    openssl
  ];
}
