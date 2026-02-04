{ system, lib, ... }: {
  imports = [
    ./common
    ./dev
    ./design
    ./music
    ./production
    ./uni
  ] ++ lib.optionals (lib.hasSuffix "-linux" system) [
    ./gaming
  ];
}
