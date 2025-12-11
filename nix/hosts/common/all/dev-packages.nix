{ inputs, pkgs, pkgs-unstable ? null, ... }:
let
  # Detect system from pkgs instead of requiring it as a parameter
  system = pkgs.stdenv.system;
  unstable = if pkgs-unstable != null then
    pkgs-unstable
  else
    import inputs.nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
in {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    ## stable
    bootdev-cli
    bun
    cmake
    ghidra
    go
    jetbrains.datagrip
    jq
    lazygit
    libpq
    lua5_1
    luarocks-nix
    nixfmt-classic
    nixfmt-rfc-style
    nodejs
    ollama
    opencode
    phpactor
    pnpm
    unstable.prettier
    protobuf
    postman
    (python313.withPackages (ps: with ps; [ pip requests mcp ]))
    ruff
    watchman
    unstable.zed-editor
  ];
}
