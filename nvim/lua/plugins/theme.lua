return {
	"folke/tokyonight.nvim",
	lazy = false,
	opts = {
		style = "night",
		transparent = true,
	},
	priority = 1000,
	config = function()
		require("tokyonight").setup(opts)
		vim.cmd([[colorscheme tokyonight-night]])
	end,
}
