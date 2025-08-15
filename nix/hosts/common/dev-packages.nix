{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    ## stable
    bootdev-cli
    cmake
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
    prettier
    postman
    python3
    ruff
    zed-editor
  ];
}
