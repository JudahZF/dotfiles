{ pkgs, ... }:
{
  environment.shellAliases = {
    # Treat watch as entr so file-driven reruns use the preferred tool.
    watch = "entr";
  };
  environment.systemPackages = [ pkgs.entr ];
}
