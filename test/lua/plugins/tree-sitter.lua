return 
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", -- Automatically update treesitter parsers
		config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
					"bash",
					"c",
					"comment",
					"csv",
					"css",
					"editorconfig",
					"git_config",
					"gitcommit",
					"gitignore",
					"go",
					"gomod",
					"gosum",
					"html",
					"hyprlang",
					"javascript",
					"json",
					"json5",
					"jsonc",
					"lua",
					"make",
					"markdown_inline",
					"nix",
					"php",
					"python",
					"regex",
					"requirements",
					"ruby",
					"rust",
					"scss",
					"sql",
					"ssh_config",
					"swift",
					"toml",
					"tsv",
					"tsx",
					"typescript",
					"vim",
					"yaml",
				},
			auto_install = true, -- automatically install missing parsers when entering buffer
			highlight = { enable = true },
			indent = { enable = true },
			})
		end,  
	}

