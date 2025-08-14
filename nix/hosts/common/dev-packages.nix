{ inputs, pkgs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    ## stable
    bootdev-cli
    cmake
    datagrip
    jq
    lazygit
    libpq
    lua5_1
    luarocks-nix
    nixfmt-rfc-style
    nodejs
    ollama
    phpactor
    pnpm
    prettier
    postman
    python3
    ruff
    zed-editor
  ];
}
