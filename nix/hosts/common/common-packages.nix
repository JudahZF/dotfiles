{ inputs, pkgs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    _1password-gui
    _1password-cli
    angryipscanner
    beszel
    btop
    cmatrix
    colmena
    comma
    coreutils
    difftastic # diff
    dua # du
    entr # watch
    fastfetch
    fd # find
    ffmpeg
    ghostty
    git
    git-lfs
    google-chrome
    handbrake
    home-manager
    iperf3
    jetbrains-mono # font
    just
    mosh # ssh
    neovim
    nerdfonts
    nil
    nix
    nixd
    nix-index
    nmap
    obsidian
    rellij # tmux
    remmina
    ripgrep # grep
    sketchybar-app-font
    starship
    telescope
    temurin-bin
    tree-sitter
    unzip
    vlc
    wget
    wireguard-tools
    yt-dlp
    zoxide # cd
    zsh
  ];

  fonts.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.fira-fira-mono
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.jetbrains-mono
  ];

  programs.zsh = {
    enableCompletion = true;
  };
}
