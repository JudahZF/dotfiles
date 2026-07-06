{ pkgs, ... }: {
  environment.systemPackages = [
    (pkgs.python313.withPackages (
      ps: with ps; [
        pip
        requests
        mcp
      ]
    ))
    (pkgs.pipx.overridePythonAttrs (_: {
      doCheck = false;
    }))
    pkgs.ruff
    pkgs.uv
  ];
}
