{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gradle
    alejandra
    phpactor
    swiftformat
  ];
}
