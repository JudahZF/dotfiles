{ pkgs, ... }: {
  config.vim = {
    options = {
      tabstop = 4;
      shiftwidth = 4;
    };

    theme = {
      enable = true;
      name = "tokyonight";
      style = "night";
    };

    globals = {
      mapleader = ";";
      maplocalleader = ",";
    };

    languages = {
      enableTreesitter = true;
      bash.enable = true;
      css.enable = true;
      go.enable = true;
      html.enable = true;
      lua.enable = true;
      nix.enable = true;
      markdown.enable =
        false; # Disabled: marksman LSP requires dotnet which is broken on darwin-aarch64
      php.enable = true;
      python.enable = true;
      rust.enable = true;
      sql.enable = true;
      tailwind.enable = true;
      ts.enable = true;
      yaml.enable = true;
      zig.enable = true;
    };

    autocomplete.nvim-cmp = {
      enable = true;
      mappings = {
        complete = "<C-Space>";
        confirm = "<C-y>";
        next = "<C-n>";
        previous = "<C-p>";
      };
    };

    snippets.luasnip.enable = true;

    formatter.conform-nvim.enable = true;

    visuals.fidget-nvim.enable = true;

    binds.whichKey.enable = true;

    telescope = {
      enable = true;
      extensions = [{
        name = "fzf";
        packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
        setup = { fzf = { fuzzy = true; }; };
      }];
      mappings = {
        buffers = "<leader>pb";
        diagnostics = "<leader>pd";
        findFiles = "<leader>pf";
        findProjects = null;
        gitBranches = null;
        gitBufferCommits = null;
        gitCommits = null;
        gitFiles = "<leader>pg";
        gitStash = null;
        gitStatus = null;
        helpTags = null;
        liveGrep = "<leader>pr";
        lspDefinitions = "<leader>pld";
        lspDocumentSymbols = "<leader>pls";
        lspImplementations = "<leader>pli";
        lspReferences = "<leader>plr";
        lspTypeDefinitions = "<leader>plt";
        lspWorkspaceSymbols = "<leader>plS";
        open = "<leader>po";
        resume = null;
        treesitter = "<leader>pt";
      };
    };

    utility.undotree.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<leader>u";
        action = ":UndotreeToggle<CR>";
      }
      {
        mode = "n";
        key = "<leader>hm";
        action = ''
          <Cmd>lua local conf = require("telescope.config").values; local files = {}; for _, item in ipairs(require("harpoon"):list().items) do table.insert(files, item.value) end; require("telescope.pickers").new({}, {prompt_title = "Harpoon", finder = require("telescope.finders").new_table({results = files}), previewer = conf.file_previewer({}), sorter = conf.generic_sorter({})}):find()<CR>'';
      }
      {
        mode = "n";
        key = "<leader>e";
        action = ":Neotree filesystem focus right toggle<CR>";
      }
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
      }
      {
        mode = "n";
        key = "<leader>?";
        action = "<Cmd>lua require('which-key').show({ global = false })<CR>";
      }
    ];

    navigation.harpoon = {
      enable = true;

      setupOpts.defaults = {
        save_on_change = true;
        save_on_toggle = true;
      };

      mappings = {
        file1 = "<leader>ht";
        file2 = "<leader>hy";
        file3 = "<leader>hu";
        file4 = "<leader>hi";
        markFile = "<leader>ha";
        listMarks = null;
      };
    };

    terminal.toggleterm = {
      enable = true;
      lazygit = {
        enable = true;
        mappings.open = "<leader>lg";
      };
    };

    filetree.neo-tree = { enable = true; };

    lsp = {
      enable = true;
      trouble = {
        enable = true;
        mappings = {
          workspaceDiagnostics = "<leader>tt";
          quickfix = "<leader>tf";
        };
      };
      lspconfig.sources = {
        ansiblels = ''
          lspconfig.ansiblels.setup({
            capabilities = caps,
          })
        '';
        eslint = ''
          lspconfig.eslint.setup({
            capabilities = caps,
          })
        '';
        jsonls = ''
          lspconfig.jsonls.setup({
            capabilities = caps,
          })
        '';
        templ = ''
          lspconfig.templ.setup({
            capabilities = caps,
          })
        '';
      };
    };

    treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
      grammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
        comment
        csv
        editorconfig
        git_config
        gitcommit
        gitignore
        gomod
        gosum
        json
        json5
        jsonc
        make
        markdown_inline
        regex
        ruby
        scss
        swift
        toml
      ];
    };

    lazy.plugins = {
      "cloak.nvim" = {
        package = pkgs.vimPlugins.cloak-nvim;
        setupModule = "cloak";
        setupOpts = {
          cloak_character = "✱";
          highlight_group = "Comment";
          patterns = {
            file_pattern = [ ".env*" "wrangler.toml" ".dev.vars" ];
            cloak_pattern = "=.+";
          };
        };
        keys = [
          {
            mode = "n";
            key = "<leader>c";
            action = ":CloakToggle<CR>";
          }
        ];
        lazy = true;
      };

      "guess-indent.nvim" = {
        package = pkgs.vimPlugins.guess-indent-nvim;
        setupModule = "guess-indent";
        setupOpts = {
          auto_cmds = true;
          override_indent = true;
        };
      };
    };

    luaConfigPost = ''
      -- Force transparency
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    '';
  };
}
