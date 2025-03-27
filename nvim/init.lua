require("config.remaps")

require("config.lazy")

-- Enable line numbers
vim.opt.number = true

-- Force transparency
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
