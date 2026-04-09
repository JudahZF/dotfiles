{ pkgs, ... }:
{
  environment.shellAliases = {
    # Use btop as the interactive system monitor behind the familiar top command.
    top = "btop";
  };
  environment.systemPackages = [ pkgs.btop ];
}
