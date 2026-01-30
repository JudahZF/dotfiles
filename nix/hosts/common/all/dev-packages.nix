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
        allowUnfreePredicate = _: true;
      };
    };
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;
  environment.systemPackages = with pkgs; [
    ## stable
    bootdev-cli
    bun
    cmake
    unstable.claude-code
    ghidra
    gh
    go
    gradle
    jetbrains.datagrip
    jq
    lazygit
    libpq
    lua5_1
    luarocks-nix
    nanopb
    nixfmt-classic
    nixfmt-rfc-style
    nodejs
    ollama
    unstable.opencode
    phpactor
    platformio
    pnpm
    unstable.prettier
    protobuf
    postman
    (python313.withPackages (ps: with ps; [ pip requests mcp ]))
    pipx # Use `pipx install meshtastic` to install meshtastic CLI (not in nixpkgs for macOS)
    ruff
    watchman
    unstable.zed-editor
  ];
}
