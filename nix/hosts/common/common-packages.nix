{ inputs, pkgs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    ## stable
    _1password-gui
    _1password-cli
    angryipscanner
    beszel
    btop
    cmatrix
    coreutils
    difftastic      # diff
    dua             # du
    entr            # watch
    fastfetch
    fd              # find
    ffmpeg
    firefox
    gimp
    iperf3
    jetbrains-mono # font
    jq
    mosh            # ssh
    neovim
    nerdfonts
    nmap
    obsidian
    oh-my-posh
    ripgrep         # grep
    tailscale
    telescope
    unzip
    vlc
    wget
    wireguard-tools
    zoxide          # cd
  ];
}
