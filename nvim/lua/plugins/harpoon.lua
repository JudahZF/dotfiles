return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup({
			global_settings = {
				save_on_toggle = true,
				save_on_change = true,
			}
		})

		-- basic telescope configuration
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
		    local file_paths = {}
		    for _, item in ipairs(harpoon_files.items) do
		        table.insert(file_paths, item.value)
		    end
		
		    require("telescope.pickers").new({}, {
		        prompt_title = "Harpoon",
		        finder = require("telescope.finders").new_table({
		            results = file_paths,
		        }),
		        previewer = conf.file_previewer({}),
		        sorter = conf.generic_sorter({}),
		    }):find()
		end

		vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
		vim.keymap.set("n", "<leader>hm", function() toggle_telescope(harpoon:list()) end)

		vim.keymap.set("n", "<leader>ht", function() harpoon:list():select(1) end)
		vim.keymap.set("n", "<leader>hy", function() harpoon:list():select(2) end)
		vim.keymap.set("n", "<leader>hu", function() harpoon:list():select(3) end)
		vim.keymap.set("n", "<leader>hi", function() harpoon:list():select(4) end)

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
		vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)
	end,
	dependencies = { 
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	}
}
