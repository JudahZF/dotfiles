{ pkgs, lib, ... }:

# Upstream t3code-nix tracks stable releases; delete this when it exposes nightly.
let
  pname = "t3code";
  version = "0.0.29-nightly.20260703.715";
  releaseUrl = "https://github.com/pingdotgg/t3code/releases/download/v${version}";
  codexPath = lib.makeBinPath [ pkgs.codex ];

  commonMeta = {
    description = "T3 Code nightly desktop app";
    homepage = "https://github.com/pingdotgg/t3code";
    changelog = "https://github.com/pingdotgg/t3code/releases/tag/v${version}";
    downloadPage = "https://github.com/pingdotgg/t3code/releases";
    license = lib.licenses.mit;
    mainProgram = pname;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };

  linuxSrc = pkgs.fetchurl {
    url = "${releaseUrl}/T3-Code-${version}-x86_64.AppImage";
    hash = "sha256-m4sFqZkY20PNOFfkwF65OHFSEwVtrVSzYaba+n1OTs0=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version;
    src = linuxSrc;
  };

  linuxPackage = pkgs.appimageTools.wrapType2 {
    inherit pname version;
    src = linuxSrc;
    nativeBuildInputs = [ pkgs.makeWrapper ];

    extraInstallCommands = ''
      mkdir -p "$out/share"

      if [ -d ${appimageContents}/usr/share ]; then
        cp -r ${appimageContents}/usr/share/* "$out/share/"
      fi

      desktop_file="$(find "$out/share" -type f -name '*.desktop' | head -n 1 || true)"
      if [ -z "$desktop_file" ]; then
        desktop_source="$(find ${appimageContents} -maxdepth 2 -type f -name '*.desktop' | head -n 1 || true)"
        if [ -n "$desktop_source" ]; then
          desktop_file="$out/share/applications/$(basename "$desktop_source")"
          install -Dm444 "$desktop_source" "$desktop_file"
        fi
      fi

      if [ -n "$desktop_file" ]; then
        desktop_basename="$(basename "$desktop_file")"

        sed -i \
          -e 's|Exec=AppRun|Exec=${pname}|g' \
          -e 's|Exec=AppRun %U|Exec=${pname} %U|g' \
          -e 's|TryExec=AppRun|TryExec=${pname}|g' \
          "$desktop_file"

        wrapProgram "$out/bin/${pname}" \
          --set CHROME_DESKTOP "$desktop_basename" \
          --prefix XDG_DATA_DIRS : "$out/share" \
          --prefix PATH : "${codexPath}"
      fi

      if [ -f ${appimageContents}/.DirIcon ]; then
        install -Dm444 ${appimageContents}/.DirIcon "$out/share/pixmaps/${pname}.png"
      fi
    '';

    meta = commonMeta;
  };

  darwinAppName = "T3 Code (Nightly).app";
  darwinExecutable = "T3 Code (Nightly)";
  darwinAsset =
    if pkgs.stdenv.hostPlatform.isAarch64 then
      "T3-Code-${version}-arm64.zip"
    else
      "T3-Code-${version}-x64.zip";
  darwinHash =
    if pkgs.stdenv.hostPlatform.isAarch64 then
      "sha256-yJ7thK0oSJL08JOVox0h3jKbeClYskSSSSWaoCduo98="
    else
      "sha256-0F31lK2fAIX4ZwFMH9MCYgIRNpLnroLUWiw3if8s7vU=";

  darwinPackage = pkgs.stdenvNoCC.mkDerivation {
    inherit pname version;

    src = pkgs.fetchurl {
      url = "${releaseUrl}/${darwinAsset}";
      hash = darwinHash;
    };

    nativeBuildInputs = [
      pkgs.makeWrapper
      pkgs.unzip
    ];

    sourceRoot = ".";
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications" "$out/bin"
      mv "${darwinAppName}" "$out/Applications/"

      makeWrapper \
        "$out/Applications/${darwinAppName}/Contents/MacOS/${darwinExecutable}" \
        "$out/bin/${pname}" \
        --prefix PATH : "${codexPath}"

      runHook postInstall
    '';

    meta = commonMeta;
  };
in
if pkgs.stdenv.hostPlatform.isLinux && pkgs.stdenv.hostPlatform.isx86_64 then
  linuxPackage
else if pkgs.stdenv.hostPlatform.isDarwin then
  darwinPackage
else
  throw "t3code nightly is only packaged for x86_64-linux, x86_64-darwin, and aarch64-darwin"
