{
  lib,
  system ? null,
  ...
}:
(lib.optionalAttrs (system != null && lib.hasSuffix "-linux" system) {
  programs.steam.enable = true;
})
// (lib.optionalAttrs (system != null && lib.hasSuffix "-darwin" system) {
  homebrew.casks = [ "steam" ];
})
