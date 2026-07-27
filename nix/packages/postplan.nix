{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "postplan";
  version = "0.0.4";

  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/postplan/-/postplan-${version}.tgz";
    hash = "sha256-1EvhJm/7deFzS8bo/hY9PUugVkOF6b0YfnGMoDP0V7g=";
  };

  postPatch = ''
    cp ${./node-cli-locks/postplan-package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-vo++fEaAYWV2dYrf5gnswNdDBc0gmIiy4mCE2abrl5A=";
  dontNpmBuild = true;

  meta = {
    description = "Authenticated static HTML draft publishing for agents";
    homepage = "https://postplan.dev";
    license = lib.licenses.mit;
    mainProgram = "postplan";
  };
}
