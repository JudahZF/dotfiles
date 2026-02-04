{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    ./default.nix
  ];

  # Compress the image
  sdImage.compressImage = true;
}
