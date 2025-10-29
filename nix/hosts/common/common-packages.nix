{ pkgs, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    _1password-gui
    _1password-cli
    bash
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
    #firefox
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
    (inputs.nvf.lib.neovimConfiguration {
      pkgs = pkgs;
      modules = [ "${inputs.dotfiles}/nvim/config.nix" ];
    }).neovim
    nil
    nix
    nixd
    nix-index
    nmap
    obsidian # Not configured
    remmina
    ripgrep # grep
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
    pkgs.sketchybar-app-font
  ];
}
