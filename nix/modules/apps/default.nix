{ ... }: {
  imports = [
    ./1password.nix
    ./discord.nix
    ./git.nix
    ./neovim.nix
    ./signal.nix
    ./cider.nix
    # clawdbot.nix and xilinx.nix are imported explicitly by hosts that need them
    # as they define NixOS-specific options
  ];
}
