{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    claude-code
    cmake
    git-lfs
    go
    lazygit
    nodejs
    phpactor
    pnpm
    postman
    prettier
    python3
    ruff
    zed-editor
  ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
