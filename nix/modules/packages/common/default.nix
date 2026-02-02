{ pkgs, lib, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    beszel # server monitoring
    cmatrix
    colmena # nix server deployment
    google-chrome
    iperf3
    nmap
    obsidian
    remmina
    temurin-bin
    (inputs.zen-browser.packages.${pkgs.system}.default)
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    mkalias
  ];
}
