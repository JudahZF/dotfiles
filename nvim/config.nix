{ pkgs, ... }:
{
  config.vim = {
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
      lua.enable = true;
      nix.enable = true;
      markdown.enable = true;
      python.enable = true;
      rust.enable = true;
      ts.enable = true;
    };

    telescope = {
      enable = true;
      extensions = [
        {
          name = "fzf";
          packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
          setup = {fzf = {fuzzy = true;};};
        }
      ];
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
        action = "<Cmd>lua local conf = require(\"telescope.config\").values; local files = {}; for _, item in ipairs(require(\"harpoon\"):list().items) do table.insert(files, item.value) end; require(\"telescope.pickers\").new({}, {prompt_title = \"Harpoon\", finder = require(\"telescope.finders\").new_table({results = files}), previewer = conf.file_previewer({}), sorter = conf.generic_sorter({})}):find()<CR>";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = ":Neotree filesystem focus right toggle<CR>";
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

    filetree.neo-tree = {
      enable = true;
    };

    lsp = {
      enable = true;
      trouble = {
        enable = true;
        mappings = {
          workspaceDiagnostics = "<leader>tt";
          quickfix = "<leader>tf";
          #next = "]t";
          #previous = "[t";
        };
      };
    };

    treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
    };

    lazy.plugins = {
      "cloak.nvim" = {
        package = pkgs.vimPlugins.cloak-nvim;
        setupModule = "cloak";
        setupOpts = {
          cloak_character = "✱";
          highlight_group = "Comment";
					patterns = {
  					file_pattern = [
  						".env*"
  						"wrangler.toml"
  						".dev.vars"
  					];
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
    };
  };
}
