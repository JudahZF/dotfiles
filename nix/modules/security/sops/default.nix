{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  sopsInstaller = inputs.sops-nix.packages.${pkgs.stdenv.hostPlatform.system}.sops-install-secrets;
  serializedSopsInstaller = pkgs.writeShellApplication {
    name = "sops-install-secrets";
    text = ''
      lock_file=/var/run/sops-install-secrets.lock

      until /usr/bin/shlock -p "$$" -f "$lock_file"; do
        sleep 0.1
      done

      trap 'rm -f "$lock_file"' EXIT
      ${lib.getExe' sopsInstaller "sops-install-secrets"} "$@"
    '';
  };
in
lib.mkMerge [
  {
    environment.systemPackages = with pkgs; [
      age
      sops
    ];

    sops.age.keyFile =
      if pkgs.stdenv.isDarwin then
        "/Users/judahfuller/.config/sops/age/keys.txt"
      else
        "/home/judahf/.config/sops/age/keys.txt";
  }

  (lib.mkIf pkgs.stdenv.isDarwin {
    # nix-darwin starts the LaunchDaemon before sops-nix's post-activation
    # installer runs. Serialize them so both cannot mutate /run/secrets.d at once.
    sops.package = serializedSopsInstaller;
    sops.validationPackage = sopsInstaller;
  })
]
