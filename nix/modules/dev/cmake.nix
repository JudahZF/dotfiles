{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ cmake ];
}
