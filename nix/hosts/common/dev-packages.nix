{ inputs, pkgs, pkgs-unstable ? null, system ? "aarch64-darwin", ... }:
let
  unstable = if pkgs-unstable != null then
    pkgs-unstable
  else
    import inputs.nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = pkg:
          builtins.elem (inputs.nixpkgs-unstable.lib.getName pkg) [ ];
      };
    };
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [ ];
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
