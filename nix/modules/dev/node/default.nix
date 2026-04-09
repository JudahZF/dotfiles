{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bun
    nodejs
    pnpm
  ];
}
