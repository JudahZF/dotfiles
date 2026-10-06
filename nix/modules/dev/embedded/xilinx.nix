{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.xilinx;
in
{
  options.programs.xilinx = {
    enable = lib.mkEnableOption "AMD/Xilinx Vivado and Vitis toolset";

    enableVivado = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Vivado Design Suite for FPGA development";
    };

    enableVitis = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Vitis for embedded software development";
    };

    enableCableDrivers = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install udev rules for Xilinx/Digilent USB JTAG cables";
    };
  };

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    # AMD's tools hard-code FHS paths: launchers use /bin/bash, run scripts
    # mark finished runs with /bin/touch (without it, dependent runs stay
    # queued forever), and xelab calls /usr/bin/{gcc,as,ld}. envfs serves
    # /bin and /usr/bin from the caller's PATH.
    services.envfs = {
      enable = true;
      # Keep /bin/bash working for callers without bash on PATH.
      extraFallbackPathCommands = "ln -s ${pkgs.bash}/bin/bash $out/bash";
    };

    # Vivado's bundled gcc links xsim snapshots against glibc's crt files and
    # looks for them in /usr/lib/../lib64, as on RHEL.
    systemd.tmpfiles.rules = [
      "d /usr/lib 0755 root root -"
      "L+ /usr/lib64 - - - - ${pkgs.glibc}/lib"
    ];

    # Vivado's Java UI otherwise opens a blank window under Xwayland.
    environment.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";

    # Support AMD's prebuilt binaries and their Java GUI outside an FHS shell.
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libxcrypt-legacy
        ncurses
        ncurses5
        pixman
        libpng
        fontconfig
        freetype
        libx11
        libxext
        libxrender
        libxtst
        libxi
        libxrandr
        libxcursor
        libxfixes
        libxinerama
        libglvnd
        gtk3
        nss
        nspr
        alsa-lib
        # Bundled git's HTTPS helper (board store refresh) and Vitis' dtc.
        expat
        libyaml
        # Vitis IDE (Electron), Vivado's embedded browser (JCEF) and JavaFX.
        glib
        dbus
        at-spi2-core
        cups
        libdrm
        libgbm
        pango
        cairo
        gdk-pixbuf
        libxcb
        libxkbcommon
        libxcomposite
        libxdamage
        libxshmfence
        libxxf86vm
      ];
    };

    environment.systemPackages =
      with pkgs;
      # AMD lists a host GCC as an xsim prerequisite; Vitis' lopper also runs cpp.
      [ gcc ] ++ lib.optionals cfg.enableVivado [ vivado ] ++ lib.optionals cfg.enableVitis [ vitis ];

    # udev rules for Xilinx USB JTAG cables (Platform Cable USB, etc.)
    # and Digilent boards (Zybo, Arty, etc.)
    services.udev.extraRules = lib.mkIf cfg.enableCableDrivers ''
      # Xilinx Platform Cable USB and USB-JTAG adapters
      SUBSYSTEM=="usb", ATTR{idVendor}=="03fd", MODE="0666", GROUP="plugdev"

      # Digilent USB devices (Zybo, Arty, Basys, Nexys, etc.)
      SUBSYSTEM=="usb", ATTR{idVendor}=="1443", MODE="0666", GROUP="plugdev"

      # FTDI-based JTAG cables (common for many dev boards)
      SUBSYSTEM=="usb", ATTR{idVendor}=="0403", MODE="0666", GROUP="plugdev"

      # Xilinx DLC9/DLC10 cables
      SUBSYSTEM=="usb", ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="0666", GROUP="plugdev"
      SUBSYSTEM=="usb", ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="0666", GROUP="plugdev"
      SUBSYSTEM=="usb", ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="0666", GROUP="plugdev"
      SUBSYSTEM=="usb", ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="0666", GROUP="plugdev"
      SUBSYSTEM=="usb", ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="0666", GROUP="plugdev"
      SUBSYSTEM=="usb", ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="0666", GROUP="plugdev"
      SUBSYSTEM=="usb", ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="0666", GROUP="plugdev"
    '';

    # Add plugdev group for USB device access
    users.groups.plugdev = { };
  };
}
