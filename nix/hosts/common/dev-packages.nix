{ inputs, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    ## stable
    bootdev-cli
    bun
    cmake
    ghidra
    go
    iperf
    jetbrains.datagrip
    jq
    lazygit
    libpq
    lua5_1
    luarocks-nix
    nixfmt
    nixfmt-rfc-style
    nodejs
    ollama
    opencode
    phpactor
    pnpm
    (inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.prettier)
    protobuf
    postman
    (python313.withPackages (
      ps: with ps; [
        pip
        requests
        mcp
      ]
    ))
    ruff
    watchman
    (inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.zed-editor)
  ];
}
