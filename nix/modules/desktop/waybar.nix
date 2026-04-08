{ ... }: {
  programs.waybar = {
    enable = true;
    settings.main = {
      reload_style_on_change = true;
      layer = "top";
      position = "top";
      spacing = 0;
      "height" = 26;

      modules-left = [
        "hyprland/workspaces"
      ];
      modules-center = [
        "clock"
      ];
      modules-right =
        [ "tray" "bluetooth" "network" "pulseaudio" "cpu" "battery" ];

      "hyprland/workspaces" = {
        on-click = "activate";
        format = "{icon}";
        format-icons = {
          default = "";
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "active" = "󱓻";
        };
        persistent-workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
        };
      };

      cpu = {
        interval = 5;
        format = "󰍛";
        on-click = "$TERMINAL -e btop";
      };
      clock = {
        format = "{:L%A %H:%M}";
        format-alt = "{:L%d %B W%V %Y}";
        tooltip = false;
      };
      network = {
        format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
        format = "{icon}";
        format-wifi = "{icon}";
        format-ethernet = "󰀂";
        format-disconnected = "󰤮";
        tooltip-format-wifi = ''
          {essid} ({frequency} GHz)
          ⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}'';
        tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-disconnected = "Disconnected";
        interval = 3;
        spacing = 1;
      };
      battery = {
        format = "{capacity}% {icon}";
        format-discharging = "{icon}";
        format-charging = "{icon}";
        format-plugged = "";
        format-icons = {
          charging = [ "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" ];
          default = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };
        format-full = "󰂅";
        tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
        tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
        interval = 5;
        states = {
          warning = 20;
          critical = 10;
        };
      };
      bluetooth = {
        format = "";
        format-disabled = "󰂲";
        format-connected = "";
        tooltip-format = "Devices connected = {num_connections}";
        on-click = "blueberry";
      };
      pulseaudio = {
        format = "{icon}";
        on-click = "$TERMINAL --class=Wiremix -e wiremix";
        on-click-right = "pamixer -t";
        tooltip-format = "Playing at {volume}%";
        scroll-step = 5;
        format-muted = "";
        format-icons = { default = [ "" "" "" ]; };
      };

      tray = {
        icon-size = 12;
        spacing = 17;
      };
    };

    style = ''
      * {
        background-color: @background;
        color: @foreground;

        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: 'CaskaydiaMono Nerd Font';
        font-size: 12px;
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }

      #workspaces button {
        all: initial;
        padding: 0 6px;
        margin: 0 1.5px;
        min-width: 9px;
      }

      #workspaces button.empty {
        opacity: 0.5;
      }

      #cpu,
      #battery,
      #pulseaudio,
      #custom-omarchy,
      #custom-screenrecording-indicator,
      #custom-update {
        min-width: 12px;
        margin: 0 7.5px;
      }

      #tray {
        margin-right: 16px;
      }

      #bluetooth {
        margin-right: 17px;
      }

      #network {
        margin-right: 13px;
      }

      #custom-expand-icon {
        margin-right: 20px;
      }

      tooltip {
        padding: 2px;
      }

      #custom-update {
        font-size: 10px;
      }

      #clock {
        margin-left: 8.75px;
      }

      .hidden {
        opacity: 0;
      }

      #custom-screenrecording-indicator {
        min-width: 12px;
        margin-left: 8.75px;
        font-size: 10px;
      }

      #custom-screenrecording-indicator.active {
        color: #a55555;
      }
    '';
  };
}
