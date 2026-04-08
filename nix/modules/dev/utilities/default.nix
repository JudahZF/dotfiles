{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gh
    jq
    watchman
  ];
}
