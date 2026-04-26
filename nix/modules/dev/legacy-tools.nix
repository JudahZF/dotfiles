{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gradle
    nixfmt-classic
    nixfmt-rfc-style
    phpactor
    swiftformat
  ];
}
