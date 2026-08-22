{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Go
    go

    # Node
    bun
    nodejs
    pnpm

    # Lua
    lua5_1
    luarocks-nix

    # Zig
    zig
    cargo-zigbuild

    # Rust
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

    # Python
    (python313.withPackages (
      ps: with ps; [
        pip
        requests
        mcp
      ]
    ))
    (pipx.overridePythonAttrs (_: {
      doCheck = false;
    }))
    ruff
    uv
  ];
}
