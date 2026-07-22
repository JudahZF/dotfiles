{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "locally-uncensored";
  version = "2.5.8";

  src = pkgs.fetchFromGitHub {
    owner = "PurpleDoubleD";
    repo = "locally-uncensored";
    rev = "v${version}";
    hash = "sha256-YwVfe+XeqjBNnZEVfLB+IRPNLAzvXve5W6+Suk7yBWY=";
  };

  npmDepsHash = "sha256-wOGLxaDKCGHcOh8PcpSpUNnSNGA3/d4x7GS6fkmCS7s=";

  cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
    inherit src;
    sourceRoot = "${src.name}/src-tauri";
    hash = "sha256-mdUFJUdUhHDIVgZVklyRfpZTSevCG9jmrjFHj0cB3hw=";
  };
  cargoRoot = "src-tauri";

  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": "v1Compatible"' '"createUpdaterArtifacts": false'
  '';

  nativeBuildInputs = [
    pkgs.cargo
    pkgs.rustc
    pkgs.rustPlatform.cargoSetupHook
  ];

  preBuild = ''
    install -Dm755 \
      ${pkgs.llama-cpp}/bin/llama-server \
      src-tauri/bin/llama-server-${pkgs.stdenv.hostPlatform.rust.rustcTarget}
  '';

  buildPhase = ''
    runHook preBuild
    npm run tauri:build -- --bundles app
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -R src-tauri/target/release/bundle/macos/LU.app "$out/Applications/"
    runHook postInstall
  '';

  postFixup = ''
    /usr/bin/codesign --force --deep --sign - \
      --entitlements src-tauri/Entitlements.plist \
      "$out/Applications/LU.app"
  '';

  meta = {
    description = "Local AI desktop app for chat, agents, image generation, and video generation";
    homepage = "https://github.com/PurpleDoubleD/locally-uncensored";
    license = lib.licenses.agpl3Only;
    platforms = [ "aarch64-darwin" ];
  };
}
