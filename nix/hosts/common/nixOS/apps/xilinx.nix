{ pkgs, ... }: {
  system.packages = with pkgs; [
    vivado
    vitis
  ];
}
