{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  makeWrapper,
  aria2,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xcodes";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/XcodesOrg/xcodes/releases/download/${finalAttrs.version}/xcodes.zip";
    hash = "sha256-8VGa/pNKUT6F3Zsy/IcjlL7Lu2pB2xXZrDkmoJqJGIg=";
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  unpackPhase = ''
    unzip "$src"
  '';

  installPhase = ''
    runHook preInstall
    install -D xcodes "$out/bin/xcodes"
    wrapProgram "$out/bin/xcodes" --prefix PATH : ${lib.makeBinPath [ aria2 ]}
    runHook postInstall
  '';

  meta = {
    description = "Install and switch between Xcode versions";
    homepage = "https://github.com/XcodesOrg/xcodes";
    changelog = "https://github.com/XcodesOrg/xcodes/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "xcodes";
  };
})
