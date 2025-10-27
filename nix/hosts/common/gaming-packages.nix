{ pkgs, ... }: {
  # pkgs.allowUnfree = true;
  environment.systemPackages = with pkgs; [ discord ];
}
