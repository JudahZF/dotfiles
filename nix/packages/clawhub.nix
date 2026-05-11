{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "clawhub";
  version = "0.12.3";

  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/clawhub/-/clawhub-${version}.tgz";
    hash = "sha256-TsCAh6xf10A7WDpZTiFc2nllls/0OTRvirBbNF5m4Yk=";
  };

  postPatch = ''
    cp ${./node-cli-locks/clawhub-package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-pbh9/1KqdhPOvP1I1haQQ5n+H8jGCr8oMZa8py09c7U=";
  dontNpmBuild = true;

  meta = {
    description = "ClawHub CLI — install, update, search, and publish OpenClaw packages";
    homepage = "https://clawhub.ai";
    license = lib.licenses.mit;
    mainProgram = "clawhub";
  };
}
