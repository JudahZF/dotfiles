{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "clawpack-cli";
  version = "0.14.2";

  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/@clawpack/cli/-/cli-${version}.tgz";
    hash = "sha256-kp3DlT7ikvWagD8r6+pUUkfCvuunHtwfJwFRea+qXBo=";
  };

  postPatch = ''
    cp ${./node-cli-locks/clawpack-cli-package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-0sTjdCx745MQsuwmg2UNLcje9ae26DxGLR7miWywy0M=";
  dontNpmBuild = true;

  meta = {
    description = "CLI for ClawPack — the agent registry";
    homepage = "https://clawpack.io";
    license = lib.licenses.mit;
    mainProgram = "clawpack";
  };
}
