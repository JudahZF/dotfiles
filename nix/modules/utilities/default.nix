{ pkgs, ... }: {
  # Modern replacements for the classic tools, aliased so muscle memory still works.
  environment.shellAliases = {
    diff = "difftastic";
    du = "dua";
    find = "fd";
    grep = "rg";
    lg = "lazygit";
    neofetch = "fastfetch";
    top = "btop";
    watch = "entr";
  };

  environment.systemPackages = with pkgs; [
    btop
    comma
    coreutils
    curl
    difftastic
    dua
    entr
    fastfetch
    fd
    fzf
    just
    ripgrep
    starship
    unzip
    wget
    zellij
    zip
    zoxide

    # git and friends
    git
    git-cliff
    git-crypt
    git-lfs
    gitleaks
    lazygit
    tea

    # Not yet sorted into a category
    beszel
    cmatrix
    colmena
    iperf3
    nmap
    temurin-bin
    turbo
    waifu2x-converter-cpp
  ];
}
