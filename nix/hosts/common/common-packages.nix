{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    _1password-gui
    _1password-cli
    beszel # server monitoring
    btop # top
    cmatrix
    colmena # nix server deployment
    comma # nix commands
    coreutils
    difftastic # diff
    dua # du
    entr # watch
    fastfetch
    fd # find
    ffmpeg
    fzf
    # ghostty
    git
    git-cliff
    git-lfs
    google-chrome
    home-manager
    iperf3
    jetbrains-mono # font
    just
    neovim
    nil
    nix
    nixd
    nix-index
    nmap
    obsidian # Not configured
    remmina
    ripgrep # grep
    sketchybar-app-font
    starship
    temurin-bin
    tree-sitter
    unzip
    wget
    zellij # tmux
    zoxide # cd
    zsh
  ];

  fonts.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.fira-mono
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
