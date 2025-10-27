{ config, pkgs, ...}:
{
  #environment.systemPackages = with pkgs; [
  #  tuigreet
  #];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions:${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session";
        user = "judahf";
      };
    };
  };
}
