{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ffmpeg
    openssl
    tree-sitter
  ];
}
