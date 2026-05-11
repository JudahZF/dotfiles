{ pkgs, lib, ... }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "cmux";
  version = "0.64.3";

  src = pkgs.fetchurl {
    url = "https://github.com/manaflow-ai/cmux/releases/download/v${version}/cmux-macos.dmg";
    hash = "sha256-ZyYHwx/kXa4jQJqseVO61cfki1/2TKSYGLsfj82SVy8=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin" "$TMPDIR/mnt"
    /usr/bin/hdiutil attach "$src" -nobrowse -readonly -mountpoint "$TMPDIR/mnt"
    cp -R "$TMPDIR/mnt/cmux.app" "$out/Applications/"
    /usr/bin/hdiutil detach "$TMPDIR/mnt"
    ln -s "$out/Applications/cmux.app/Contents/Resources/bin/cmux" "$out/bin/cmux"

    runHook postInstall
  '';

  meta = {
    description = "Ghostty-based terminal with vertical tabs and notifications for AI coding agents";
    homepage = "https://www.cmux.dev/";
    license = lib.licenses.mit;
    mainProgram = "cmux";
    platforms = [ "aarch64-darwin" ];
  };
}
