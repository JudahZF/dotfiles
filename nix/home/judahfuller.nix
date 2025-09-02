{
  dotfiles,
  pkgs,
  ...
}:
{
  home = {
    stateVersion = "24.05";

    file = pkgs.lib.mkMerge [
      {
        nix = {
          recursive = true;
          source = "${dotfiles}/nix";
          target = ".config/nix";
        };
        nvim = {
          recursive = true;
          source = "${dotfiles}/nvim";
          target = ".config/nvim";
        };
        sketchybar = {
          recursive = true;
          source = "${dotfiles}/sketchybar";
          target = ".config/sketchybar";
        };
        skhd = {
          source = "${dotfiles}/skhdrc";
          target = ".config/skhd/skhdrc";
        };
        yabai = {
          source = "${dotfiles}/yabairc";
          target = ".config/yabai/yabairc";
        };
      }
    ];

    sessionPath = [
      "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
    ];
  };

  programs = {
    btop = {
      enable = true;
      settings = {
        color_theme = "Default";
        theme_background = true;
        truecolor = true;
        force_tty = false;
        presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
        vim_keys = false;
        rounded_corners = true;
        graph_symbol = "braille";
        shown_boxes = "cpu mem proc net";
        update_ms = 500;
        proc_sorting = "cpu lazy";
        proc_reversed = false;
        proc_tree = false;
        proc_colors = true;
        proc_gradient = true;
        proc_per_core = true;
        proc_mem_bytes = true;
        proc_cpu_graphs = true;
        proc_info_smaps = false;
        proc_left = false;
        proc_filter_kernel = true;
        proc_aggregate = true;
        cpu_graph_upper = "Auto";
        cpu_graph_lower = "Auto";
        cpu_invert_lower = true;
        cpu_single_graph = true;
        cpu_bottom = false;
        show_uptime = true;
        check_temp = true;
        cpu_sensor = "Auto";
        show_coretemp = true;
        temp_scale = "celsius";
        base_10_sizes = false;
        show_cpu_freq = true;
        background_update = true;
        mem_graphs = true;
        mem_below_net = false;
        zfs_arc_cached = true;
        show_swap = true;
        swap_disk = false;
        show_disks = true;
        only_physical = true;
        use_fstab = true;
        zfs_hide_datasets = false;
        disk_free_priv = false;
        show_io_stat = true;
        io_mode = false;
        io_graph_combined = false;
        net_download = 1024;
        net_upload = 1024;
        net_auto = true;
        net_sync = true;
        base_10_bitrate = "False";
        show_battery = true;
        selected_battery = "Auto";
        show_battery_watts = true;
      };
    };
    fastfetch = {
      enable = true;
      settings = {
        logo = {
          padding = {
            top = 2;
          };
        };
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "display"
          "terminal"
          "cpu"
          "gpu"
          "memory"
          "swap"
          "disk"
          "localip"
          "locale"
          "break"
          "colors"
        ];
      };
    };
    fd = {
      enable = true;
      hidden = true;
      ignores = [ ".git/" ];
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    ghostty = {
      # enable = true;
      settings = {
        background-opacity = 0.8;
      };
    };
    git = {
      enable = true;
      difftastic = {
        color = "always";
        enableAsDifftool = true;
        enable = true;
      };
      extraConfig =
        if pkgs.stdenv.isDarwin then
          {
            gpg."ssh".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          }
        else
          { };
      lfs = {
        enable = true;
      };
      ignores = [ ".env" ];
      signing = {
        format = "ssh";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKg+m/SsrTx6+3t00tabRdDLms4jYrxGwlh8gG7ZkIsO";
        signByDefault = true;
      };
      userEmail = "judah@judahfuller.com";
      userName = "Judah Fuller";
    };
    ssh = {
      matchBlocks.all = {
        match = "*";
        setEnv = "TERM=xterm-256color";
      };
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      initContent = builtins.readFile "${dotfiles}/zsh/macos/zshrc";
    };
  };
}
