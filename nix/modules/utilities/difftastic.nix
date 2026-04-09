{ pkgs, ... }:
{
  environment.shellAliases = {
    # Route diff to difftastic for syntax-aware structural diffs.
    diff = "difftastic";
  };
  environment.systemPackages = [ pkgs.difftastic ];
}
