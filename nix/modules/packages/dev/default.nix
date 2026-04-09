{ inputs, pkgs, pkgs-unstable ? null, ... }:
let
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
  environment.systemPackages = with pkgs; [
    ## stable
    adafruit-nrfutil
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
    opencode
    phpactor
    platformio
    pnpm
    unstable.prettier
    protobuf
    postman
    (python313.withPackages (ps: with ps; [ pip requests mcp ]))
    pipx
    ruff
    swiftformat
    uv
    watchman
    unstable.zed-editor
  ] ++ (if builtins.hasAttr system inputs.t3code.packages
        then [ inputs.t3code.packages.${system}.default ]
        else []);
}
