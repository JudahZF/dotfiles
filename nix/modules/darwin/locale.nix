_: {
  # macOS can publish Apple/ICU locale identifiers such as
  # en-GB-u-ca-gregory-co-standard-cu-gbp-fw-mon-hc-h23-ms-uksystem-tz-gblon.
  # Bash/GNU tools from Nix do not understand that form and warn before shell
  # startup files can correct it, so set a POSIX locale in launchd too.
  launchd.user.envVariables = {
    LANG = "en_GB.UTF-8";
    LC_ALL = "en_GB.UTF-8";
  };

  environment.variables = {
    LANG = "en_GB.UTF-8";
    LC_ALL = "en_GB.UTF-8";
  };
}
