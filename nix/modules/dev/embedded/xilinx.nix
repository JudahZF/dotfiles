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
    environment.systemPackages =
      with pkgs;
      lib.optionals cfg.enableVivado [ vivado ] ++ lib.optionals cfg.enableVitis [ vitis ];

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
