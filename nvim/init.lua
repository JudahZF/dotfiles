require("config.remaps")

require("config.lazy")

-- Enable line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Force transparency
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

-- Set tab size
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
