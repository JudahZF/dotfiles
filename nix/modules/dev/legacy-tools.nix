{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gradle
    nixfmt
    phpactor
    swiftformat
  ];
}
