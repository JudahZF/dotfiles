{ pkgs, lib, ... }:

# Cursor Origin CLI, stable channel. nix/update-origin.sh refreshes the
# version and hashes from the official installer.
let
  version = "2026.10.01-18-10-45-4a05741";
  targets = {
    aarch64-darwin = {
      platform = "darwin-arm64";
      hash = "sha256-ZOJVhhaqCyi4tFZm4t3h7zBQjJumYsWdzA48PT61I+g=";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      hash = "sha256-v2IqiR4FB0G2KK5fjpchrFfaq3DfBoeW5B+jZvXsXTA=";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      hash = "sha256-AbWtU0IV1zStBWSJaEnnyH94kJprKOvAFEhTpFSNYd4=";
    };
    x86_64-linux = {
      platform = "linux-x64";
      hash = "sha256-ZzKWe+nT1EU7LiKBAZMGv7lOpEQPq80RGBzYHWoCuvw=";
    };
  };
  inherit (pkgs.stdenv.hostPlatform) system;
  target = targets.${system} or (throw "origin: unsupported system ${system}");
in
pkgs.stdenv.mkDerivation {
  pname = "origin";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://downloads.cursor.com/co/${version}/${target.platform}/co.tar.gz";
    inherit (target) hash;
  };

  sourceRoot = ".";
  nativeBuildInputs = lib.optional pkgs.stdenv.isLinux pkgs.autoPatchelfHook;

  # A Bun single-file executable: the app payload is appended after the ELF/Mach-O
  # image. Stripping drops it; patchelf keeps it intact at the end of the file.
  dontStrip = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 origin "$out/bin/origin"
    runHook postInstall
  '';

  meta = {
    description = "Cursor Origin git hosting CLI";
    homepage = "https://cursor.com/docs/origin/cli";
    license = lib.licenses.unfree;
    mainProgram = "origin";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames targets;
  };
}
