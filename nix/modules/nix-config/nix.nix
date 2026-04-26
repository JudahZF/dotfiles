{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nil
    nix
    nixd
    nix-index
  ];

  nix = {
    channel.enable = false;
    enable = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };
}
