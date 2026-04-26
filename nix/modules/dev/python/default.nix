{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.python313.withPackages (
      ps: with ps; [
        pip
        requests
        mcp
      ]
    ))
    pkgs.pipx
    pkgs.ruff
    pkgs.uv
  ];
}
