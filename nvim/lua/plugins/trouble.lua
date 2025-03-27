return {
	"folke/trouble.nvim",
	opts = {}, -- for default options, refer to the configuration section for custom setup.
	cmd = "Trouble",
	config = function()
		require("trouble").setup({})
		builtin = require("trouble")
		vim.keymap.set("n", "<leader>tt", builtin.toggle, {})
		vim.keymap.set("n", "<leader>tn", builtin.next({ jump = true, skip_group = true }, {})
		vim.keymap.set("n", "<leader>tp", builtin.previous({ jump = true, skip_group = true }, {})
		vim.keymap.set("n", "<leader>tt", builtin.toggle, {})
		vim.keymap.set("n", "<leader>tt", builtin.toggle, {})
	end,
}
