{ pkgs, lib, ... }:
lib.mkMerge [
  {
    home.sessionVariables = { SSH_AUTH_SOCK = "$HOME/.1password/agent.sock"; };
    home.packages = with pkgs; [ _1password-cli ];
  }
  (lib.mkIf pkgs.stdenv.isDarwin {
    home.activation.onepasswordAgentSymlink =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "$HOME/.1password"
        ln -sf "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" \
          "$HOME/.1password/agent.sock"
      '';
  })
  (lib.mkIf pkgs.stdenv.isLinux {
    xdg.desktopEntries."1password" = {
      name = "1Password";
      genericName = "Password Manager";
      comment = "1Password password manager";
      exec =
        "1password --ozone-platform=wayland --enable-features=WaylandWindowDecorations %U";
      icon = "1password";
      terminal = false;
      categories = [ "Office" "Utility" ];
      startupNotify = true;
      mimeType = [ "x-scheme-handler/onepassword" ];
    };

  })
]
