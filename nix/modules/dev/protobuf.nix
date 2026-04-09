{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ protobuf ];
}
