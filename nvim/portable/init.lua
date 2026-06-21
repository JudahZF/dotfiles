

-- nvim-lspconfig v2 warns whenever nvf's generated config uses the
-- legacy require('lspconfig').server.setup API. nvf still generates that
-- API today, so suppress just this noisy startup deprecation until nvf
-- migrates to vim.lsp.config.
local original_deprecate = vim.deprecate
vim.deprecate = function(name, alternative, version, plugin, backtrace)
  if name == "The `require('lspconfig')` \"framework\"" and plugin == "nvim-lspconfig" then
    return
  end

  return original_deprecate(name, alternative, version, plugin, backtrace)
end

-- SECTION: theme

require('tokyonight').setup {
  transparent = false;
  styles = {
    sidebars = "dark",
    floats = "dark",
  },
}
vim.cmd[[colorscheme tokyonight-night]]




-- SECTION: globalsScript
vim.g.editorconfig = true
vim.g.mapleader = ";"
vim.g.maplocalleader = ","
vim.g.zig_fmt_autosave = 0


-- SECTION: basic








vim.o.smartcase = false
vim.o.ignorecase = false



-- SECTION: optionsScript
vim.o.autoindent = true
vim.o.backup = false
vim.o.cmdheight = 1
vim.o.cursorlineopt = "line"
vim.o.encoding = "utf-8"
vim.o.errorbells = false
vim.o.expandtab = true
vim.o.hidden = true
vim.o.mouse = "nvi"
vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 4
vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.tm = 500
vim.o.updatetime = 300
vim.o.visualbell = false
vim.o.wrap = true
vim.o.writebackup = false


-- SECTION: lazyConfigs
require('lz.n').load({{"cloak.nvim",["after"] = function()
  
  require("cloak").setup({["cloak_character"] = "✱",["highlight_group"] = "Comment",["patterns"] = {["cloak_pattern"] = "=.+",["file_pattern"] = {".env*","wrangler.toml",".dev.vars"}}})
  
end
,["keys"] = {{"<leader>c",":CloakToggle<CR>",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false}},["lazy"] = true},{"cmp-buffer",["after"] = function()
  
  
  local path = vim.fn.globpath(vim.o.packpath, 'pack/*/opt/cmp-buffer')
require("rtp_nvim").source_after_plugin_dir(path)

end
,["lazy"] = true},{"cmp-luasnip",["after"] = function()
  
  
  local path = vim.fn.globpath(vim.o.packpath, 'pack/*/opt/cmp-luasnip')
require("rtp_nvim").source_after_plugin_dir(path)

end
,["lazy"] = true},{"cmp-nvim-lsp",["after"] = function()
  
  
  local path = vim.fn.globpath(vim.o.packpath, 'pack/*/opt/cmp-nvim-lsp')
require("rtp_nvim").source_after_plugin_dir(path)

end
,["lazy"] = true},{"cmp-path",["after"] = function()
  
  
  local path = vim.fn.globpath(vim.o.packpath, 'pack/*/opt/cmp-path')
require("rtp_nvim").source_after_plugin_dir(path)

end
,["lazy"] = true},{"cmp-treesitter",["after"] = function()
  
  
  local path = vim.fn.globpath(vim.o.packpath, 'pack/*/opt/cmp-treesitter')
require("rtp_nvim").source_after_plugin_dir(path)

end
,["lazy"] = true},{"fidget-nvim",["after"] = function()
  
  require("fidget").setup({["integration"] = {["nvim-tree"] = {["enable"] = false},["xcodebuild-nvim"] = {["enable"] = true}},["logger"] = {["float_precision"] = 0.010000,["level"] = vim.log.levels.WARN,["max_size"] = 10000,["path"] = string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache"))
},["notification"] = {["configs"] = {["default"] = require('fidget.notification').default_config},["filter"] = vim.log.levels.INFO,["history_size"] = 128,["override_vim_notify"] = false,["poll_rate"] = 10,["redirect"] = function(msg, level, opts)
  if opts and opts.on_open then
    return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
  end
end
,["view"] = {["group_separator"] = "---",["group_separator_hl"] = "Comment",["icon_separator"] = " ",["render_message"] = function(msg, cnt)
  return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
end
,["stack_upwards"] = true},["window"] = {["align"] = "bottom",["border"] = "none",["max_height"] = 0,["max_width"] = 0,["normal_hl"] = "Comment",["relative"] = "editor",["winblend"] = 100,["x_padding"] = 1,["y_padding"] = 0,["zindex"] = 45}},["progress"] = {["display"] = {["done_icon"] = "✓",["done_style"] = "Constant",["done_ttl"] = 3,["format_annote"] = function(msg) return msg.title end
,["format_group_name"] = function(group) return tostring(group) end
,["format_message"] = require("fidget.progress.display").default_format_message
,["group_style"] = "Title",["icon_style"] = "Question",["overrides"] = {},["priority"] = 30,["progress_icon"] = {["pattern"] = "dots",["period"] = 1},["progress_style"] = "WarningMsg",["progress_ttl"] = 99999,["render_limit"] = 16,["skip_history"] = true},["ignore"] = {},["ignore_done_already"] = false,["ignore_empty_message"] = false,["lsp"] = {["log_handler"] = false,["progress_ringbuf_size"] = 100},["notification_group"] = function(msg)
  return msg.lsp_client.name
end
,["poll_rate"] = 0,["suppress_on_insert"] = false}})
  
end
,["event"] = "LspAttach"},{"guess-indent.nvim",["after"] = function()
  
  require("guess-indent").setup({["auto_cmds"] = true,["override_indent"] = true})
  
end
},{"harpoon",["after"] = function()
  
  require("harpoon").setup({["defaults"] = {["key"] = function()
  return vim.uv.cwd()
end
,["save_on_change"] = true,["save_on_toggle"] = true,["sync_on_ui_close"] = false}})
  
end
,["cmd"] = {"Harpoon"},["keys"] = {{"<leader>ha","<Cmd>lua require('harpoon'):list():add()<CR>",["desc"] = "Mark file [Harpoon]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>ht","<Cmd>lua require('harpoon'):list():select(1)<CR>",["desc"] = "Go to marked file 1 [Harpoon]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>hy","<Cmd>lua require('harpoon'):list():select(2)<CR>",["desc"] = "Go to marked file 2 [Harpoon]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>hu","<Cmd>lua require('harpoon'):list():select(3)<CR>",["desc"] = "Go to marked file 3 [Harpoon]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>hi","<Cmd>lua require('harpoon'):list():select(4)<CR>",["desc"] = "Go to marked file 4 [Harpoon]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false}}},{"luasnip",["after"] = function()
  
  require("luasnip").setup({["enable_autosnippets"] = false})
  
require('luasnip.loaders.from_vscode').lazy_load()

end
,["lazy"] = true},{"neo-tree-nvim",["after"] = function()
  
  require("neo-tree").setup({["add_blank_line_at_top"] = false,["auto_clean_after_session_restore"] = false,["default_source"] = "filesystem",["enable_cursor_hijack"] = false,["enable_diagnostics"] = true,["enable_git_status"] = true,["enable_modified_markers"] = true,["enable_opened_markers"] = true,["enable_refresh_on_write"] = true,["filesystem"] = {["hijack_netrw_behavior"] = "open_default"},["git_status_async"] = false,["hide_root_node"] = false,["log_level"] = "info",["log_to_file"] = false,["open_files_do_not_replace_types"] = {"terminal","Trouble","qf","edgy"},["open_files_in_last_window"] = true,["retain_hidden_root_indent"] = false})
  
end
,["cmd"] = {"Neotree"}},{"nvim-cmp",["after"] = function()
  
  
  local luasnip = require('luasnip')
local cmp = require("cmp")

local kinds = require("cmp.types").lsp.CompletionItemKind
local deprio = function(kind)
  return function(e1, e2)
    if e1:get_kind() == kind then
      return false
    end
    if e2:get_kind() == kind then
      return true
    end
    return nil
  end
end

cmp.setup({["completion"] = {["completeopt"] = "menu,menuone,noinsert"},["formatting"] = {["format"] = function(entry, vim_item)
  vim_item.menu = ({["luasnip"] = "[LuaSnip]",["nvim_lsp"] = "[LSP]",["treesitter"] = "[Treesitter]"})[entry.source.name]
  return vim_item
end
},["mapping"] = {["<C-Space>"] = cmp.mapping.complete(),["<C-d>"] = cmp.mapping.scroll_docs(-4),["<C-e>"] = cmp.mapping.abort(),["<C-f>"] = cmp.mapping.scroll_docs(4),["<C-n>"] = cmp.mapping(function(fallback)
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  if cmp.visible() then
    cmp.select_next_item()
    elseif luasnip.locally_jumpable(1) then
  luasnip.jump(1)

  elseif has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end)
,["<C-p>"] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
    elseif luasnip.locally_jumpable(-1) then
  luasnip.jump(-1)

  else
    fallback()
  end
end)
,["<C-y>"] = cmp.mapping.confirm({ select = true })},["sorting"] = {["comparators"] = {deprio(kinds.Text),deprio(kinds.Snippet),cmp.config.compare.offset,cmp.config.compare.exact,cmp.config.compare.score,cmp.config.compare.kind,cmp.config.compare.length,cmp.config.compare.sort_text}},["sources"] = {{["name"] = "luasnip"},{["name"] = "nvim_lsp"},{["name"] = "treesitter"}}})

require('lz.n').trigger_load("cmp-luasnip")
require('lz.n').trigger_load("cmp-buffer")
require('lz.n').trigger_load("cmp-path")
require('lz.n').trigger_load("cmp-treesitter")
require('lz.n').trigger_load("cmp-nvim-lsp")

end
,["event"] = {"InsertEnter","CmdlineEnter"}},{"telescope",["after"] = function()
  
  require("telescope").setup({["defaults"] = {["color_devicons"] = false,["entry_prefix"] = "  ",["extensions"] = {["fzf"] = {["fuzzy"] = true}},["file_ignore_patterns"] = {"node_modules","%.git/","dist/","build/","target/","result/"},["initial_mode"] = "insert",["layout_config"] = {["height"] = 0.800000,["horizontal"] = {["preview_width"] = 0.550000,["prompt_position"] = "top"},["preview_cutoff"] = 120,["vertical"] = {["mirror"] = false},["width"] = 0.800000},["layout_strategy"] = "horizontal",["path_display"] = {"absolute"},["pickers"] = {["find_command"] = {"fd"}},["prompt_prefix"] = "     ",["selection_caret"] = "  ",["selection_strategy"] = "reset",["set_env"] = {["COLORTERM"] = "truecolor"},["sorting_strategy"] = "ascending",["vimgrep_arguments"] = {"rg","--color=never","--no-heading","--with-filename","--line-number","--column","--smart-case","--hidden","--no-ignore"},["winblend"] = 0},["pickers"] = {["find_files"] = {["find_command"] = {"fd","--type=file"}}}})
  local telescope = require("telescope")



telescope.load_extension('fzf')

end
,["before"] = function()
  vim.g.loaded_telescope = nil

end
,["cmd"] = {"Telescope"},["keys"] = {{"<leader>pf","<cmd>Telescope find_files<CR>",["desc"] = "Find files [Telescope]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>pr","<cmd>Telescope live_grep<CR>",["desc"] = "Live grep [Telescope]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>pb","<cmd>Telescope buffers<CR>",["desc"] = "Buffers [Telescope]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>po","<cmd>Telescope<CR>",["desc"] = "Open [Telescope]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>pg","<cmd>Telescope git_files<CR>",["desc"] = "Git files [Telescope]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>pls","<cmd>Telescope lsp_document_symbols<CR>",["desc"] = "LSP Document Symbols [Telescope]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>plS","<cmd>Telescope lsp_workspace_symbols<CR>",["desc"] = "LSP Workspace Symbols [Telescope]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>plr","<cmd>Telescope lsp_references<CR>",["desc"] = "LSP References [Telescope]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>pli","<cmd>Telescope lsp_implementations<CR>",["desc"] = "LSP Implementations [Telescope]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>pld","<cmd>Telescope lsp_definitions<CR>",["desc"] = "LSP Definitions [Telescope]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>plt","<cmd>Telescope lsp_type_definitions<CR>",["desc"] = "LSP Type Definitions [Telescope]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>pd","<cmd>Telescope diagnostics<CR>",["desc"] = "Diagnostics [Telescope]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>pt","<cmd>Telescope treesitter<CR>",["desc"] = "Treesitter [Telescope]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false}}},{"toggleterm-nvim",["after"] = function()
  
  require("toggleterm").setup({["direction"] = "horizontal",["enable_winbar"] = false,["size"] = function(term)
  if term.direction == "horizontal" then
    return 15
  elseif term.direction == "vertical" then
    return vim.o.columns * 0.4
  end
end
,["winbar"] = {["enabled"] = true,["name_formatter"] = function(term)
  return term.name
end
}})
  local terminal = require 'toggleterm.terminal'
local lazygit = terminal.Terminal:new({
  cmd = 'lazygit',
  direction = 'float',
  hidden = true,
  on_open = function(term)
    vim.cmd("startinsert!")
  end
})

vim.keymap.set('n', "<leader>lg", function() lazygit:toggle() end, {silent = true, noremap = true, desc = 'Open lazygit [toggleterm]'})

end
,["cmd"] = {"ToggleTerm","ToggleTermSendCurrentLine","ToggleTermSendVisualLines","ToggleTermSendVisualSelection","ToggleTermSetName","ToggleTermToggleAll"},["keys"] = {{"<c-t>","<Cmd>execute v:count . \"ToggleTerm\"<CR>",["desc"] = "Toggle terminal",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>lg",["desc"] = "Open lazygit [toggleterm]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false}}},{"trouble",["after"] = function()
  
  require("trouble").setup({})
  
end
,["cmd"] = "Trouble",["keys"] = {{"<leader>tt","<cmd>Trouble toggle diagnostics<CR>",["desc"] = "Workspace diagnostics [trouble]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>ld","<cmd>Trouble toggle diagnostics filter.buf=0<CR>",["desc"] = "Document diagnostics [trouble]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>lr","<cmd>Trouble toggle lsp_references<CR>",["desc"] = "LSP References [trouble]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>tf","<cmd>Trouble toggle quickfix<CR>",["desc"] = "QuickFix [trouble]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>xl","<cmd>Trouble toggle loclist<CR>",["desc"] = "LOCList [trouble]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false},{"<leader>xs","<cmd>Trouble toggle symbols<CR>",["desc"] = "Symbols [trouble]",["expr"] = false,["mode"] = "n",["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false}}},{"undotree",["cmd"] = {"UndotreeToggle","UndotreeShow","UndotreeHide","UndotreePersistUndo","UndotreeFocus"}}})
require('lzn-auto-require').enable()


-- SECTION: pluginConfigs
-- SECTION: lsp-setup
vim.g.formatsave = false;

local attach_keymaps = function(client, bufnr)
  vim.keymap.set('n', '<leader>lgD', vim.lsp.buf.declaration, {buffer=bufnr, noremap=true, silent=true, desc='Go to declaration'})
  vim.keymap.set('n', '<leader>lgd', vim.lsp.buf.definition, {buffer=bufnr, noremap=true, silent=true, desc='Go to definition'})
  vim.keymap.set('n', '<leader>lgt', vim.lsp.buf.type_definition, {buffer=bufnr, noremap=true, silent=true, desc='Go to type'})
  vim.keymap.set('n', '<leader>lgi', vim.lsp.buf.implementation, {buffer=bufnr, noremap=true, silent=true, desc='List implementations'})
  vim.keymap.set('n', '<leader>lgr', vim.lsp.buf.references, {buffer=bufnr, noremap=true, silent=true, desc='List references'})
  vim.keymap.set('n', '<leader>lgn', vim.diagnostic.goto_next, {buffer=bufnr, noremap=true, silent=true, desc='Go to next diagnostic'})
  vim.keymap.set('n', '<leader>lgp', vim.diagnostic.goto_prev, {buffer=bufnr, noremap=true, silent=true, desc='Go to previous diagnostic'})
  vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, {buffer=bufnr, noremap=true, silent=true, desc='Open diagnostic float'})
  vim.keymap.set('n', '<leader>lH', vim.lsp.buf.document_highlight, {buffer=bufnr, noremap=true, silent=true, desc='Document highlight'})
  vim.keymap.set('n', '<leader>lS', vim.lsp.buf.document_symbol, {buffer=bufnr, noremap=true, silent=true, desc='List document symbols'})
  vim.keymap.set('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, {buffer=bufnr, noremap=true, silent=true, desc='Add workspace folder'})
  vim.keymap.set('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, {buffer=bufnr, noremap=true, silent=true, desc='Remove workspace folder'})
  vim.keymap.set('n', '<leader>lwl', function() vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, {buffer=bufnr, noremap=true, silent=true, desc='List workspace folders'})
  vim.keymap.set('n', '<leader>lws', vim.lsp.buf.workspace_symbol, {buffer=bufnr, noremap=true, silent=true, desc='List workspace symbols'})
  vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, {buffer=bufnr, noremap=true, silent=true, desc='Trigger hover'})
  vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, {buffer=bufnr, noremap=true, silent=true, desc='Signature help'})
  vim.keymap.set('n', '<leader>ln', vim.lsp.buf.rename, {buffer=bufnr, noremap=true, silent=true, desc='Rename symbol'})
  vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, {buffer=bufnr, noremap=true, silent=true, desc='Code action'})
  vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, {buffer=bufnr, noremap=true, silent=true, desc='Format'})
  vim.keymap.set('n', '<leader>ltf', function() vim.b.disableFormatSave = not vim.b.disableFormatSave end, {buffer=bufnr, noremap=true, silent=true, desc='Toggle format on save'})
end


default_on_attach = function(client, bufnr)
  attach_keymaps(client, bufnr)
  
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- TODO(horriblename): migrate to vim.lsp.config['*']
-- HACK: copied from cmp-nvim-lsp. If we ever lazy load lspconfig we
-- should re-evaluate whether we can just use `default_capabilities`
capabilities = {
  textDocument = {
    completion = {
      dynamicRegistration = false,
      completionItem = {
        snippetSupport = true,
        commitCharactersSupport = true,
        deprecatedSupport = true,
        preselectSupport = true,
        tagSupport = {
          valueSet = {
            1, -- Deprecated
          }
        },
        insertReplaceSupport = true,
        resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
            "sortText",
            "filterText",
            "insertText",
            "textEdit",
            "insertTextFormat",
            "insertTextMode",
          },
        },
        insertTextModeSupport = {
          valueSet = {
            1, -- asIs
            2, -- adjustIndentation
          }
        },
        labelDetailsSupport = true,
      },
      contextSupport = true,
      insertTextMode = 1,
      completionList = {
        itemDefaults = {
          'commitCharacters',
          'editRange',
          'insertTextFormat',
          'insertTextMode',
          'data',
        }
      }
    },
  },
}





-- SECTION: lspconfig
local lspconfig = require('lspconfig')




-- SECTION: ansiblels
lspconfig.ansiblels.setup({
  capabilities = caps,
})


-- SECTION: bash-lsp
lspconfig.bashls.setup{
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"bash-language-server",  "start"};
}


-- SECTION: conform-nvim
require("conform").setup({["default_format_opts"] = {["lsp_format"] = "fallback"},["format_after_save"] = function()
  if not vim.g.formatsave or vim.b.disableFormatSave then
    return
  else
    return {["lsp_format"] = "fallback"}
  end
end
,["format_on_save"] = function()
  if not vim.g.formatsave or vim.b.disableFormatSave then
    return
  else
    return {lsp_format = "fallback", timeout_ms = 500}
  end
end
,["formatters_by_ft"] = {}})


-- SECTION: css-lsp
-- enable (broadcasting) snippet capability for completion
-- see <https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#cssls>
local css_capabilities = vim.lsp.protocol.make_client_capabilities()
css_capabilities.textDocument.completion.completionItem.snippetSupport = true

-- cssls setup
lspconfig.cssls.setup {
  capabilities = css_capabilities;
  on_attach = default_on_attach;
  cmd = {"vscode-css-language-server", "--stdio"}
}


-- SECTION: eslint
lspconfig.eslint.setup({
  capabilities = caps,
})


-- SECTION: go-lsp
lspconfig.gopls.setup {
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"gopls", "serve"},
}


-- SECTION: html-autotag
require('nvim-ts-autotag').setup()


-- SECTION: jsonls
lspconfig.jsonls.setup({
  capabilities = caps,
})


-- SECTION: lua-lsp
lspconfig.lua_ls.setup {
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"lua-language-server"};
}


-- SECTION: neo-tree
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("load_neo_tree", {}),
  desc = "Loads neo-tree when opening a directory",
  callback = function(args)
    local stats = vim.uv.fs_stat(args.file)

    if not stats or stats.type ~= "directory" then
      return
    end

    require("lz.n").trigger_load("neo-tree-nvim")

    return true
  end,
})


-- SECTION: nix-lsp
lspconfig.nil_ls.setup{
  capabilities = capabilities,
on_attach = attach_keymaps,
  cmd = {"nil"},

}


-- SECTION: nvim-web-devicons
require("nvim-web-devicons").setup({["color_icons"] = true,["override"] = {}})


-- SECTION: php-lsp
lspconfig.phpactor.setup{
  capabilities = capabilities,
  on_attach = default_on_attach,
  cmd = {
  "phpactor",
  "language-server"
},

}


-- SECTION: python-lsp
lspconfig.basedpyright.setup{
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"basedpyright-langserver", "--stdio"}
}


-- SECTION: rustaceanvim
vim.g.rustaceanvim = {
-- LSP
tools = {
  hover_actions = {
    replace_builtin_hover = false
  },
},
server = {
  cmd = {"rust-analyzer"},
  default_settings = {
    
  },
  on_attach = function(client, bufnr)
    default_on_attach(client, bufnr)
    local opts = { noremap=true, silent=true, buffer = bufnr }
    vim.keymap.set("n", "<localleader>rr", ":RustLsp runnables<CR>", opts)
    vim.keymap.set("n", "<localleader>rp", ":RustLsp parentModule<CR>", opts)
    vim.keymap.set("n", "<localleader>rm", ":RustLsp expandMacro<CR>", opts)
    vim.keymap.set("n", "<localleader>rc", ":RustLsp openCargo", opts)
    vim.keymap.set("n", "<localleader>rg", ":RustLsp crateGraph x11", opts)
    
  end
},


  
}


-- SECTION: sql-lsp
lspconfig.sqls.setup {
  on_attach = function(client)
    client.server_capabilities.execute_command = true
    on_attach_keymaps(client, bufnr)
    require'sqls'.setup{}
  end,
  cmd = { "sqls", "-config", string.format("%s/config.yml", vim.fn.getcwd()) }
}


-- SECTION: tailwindcss-lsp
lspconfig.tailwindcss.setup {
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"tailwindcss-language-server", "--stdio"}
}


-- SECTION: templ
lspconfig.templ.setup({
  capabilities = caps,
})


-- SECTION: treesitter
require('nvim-treesitter.configs').setup {
  -- Disable imperative treesitter options that would attempt to fetch
  -- grammars into the read-only Nix store. To add additional grammars here
  -- you must use the `config.vim.treesitter.grammars` option.
  auto_install = false,
  sync_install = false,
  ensure_installed = {},

  -- Indentation module for Treesitter
  indent = {
    enable = true,
    disable = {},
  },

  -- Highlight module for Treesitter
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },

  -- Indentation module for Treesitter
  -- Keymaps are set to false here as they are
  -- handled by `vim.maps` entries calling lua
  -- functions achieving the same functionality.
  incremental_selection = {
    enable = true,
    disable = {},
    keymaps = {
      init_selection = false,
      node_incremental = false,
      scope_incremental = false,
      node_decremental = false,

    },
  },
}


-- SECTION: ts-lsp
lspconfig.ts_ls.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    attach_keymaps(client, bufnr);
    client.server_capabilities.documentFormattingProvider = false;
  end,
  cmd = {"typescript-language-server", "--stdio"}
}


-- SECTION: whichkey
local wk = require("which-key")
wk.setup ({["notify"] = true,["preset"] = "modern",["replace"] = {["<cr>"] = "RETURN",["<leader>"] = "SPACE",["<space>"] = "SPACE",["<tab>"] = "TAB"},["win"] = {["border"] = "rounded"}})
wk.add({{{ '<leader>a', desc = 'Harpoon Mark' }},{{ '<leader>f', desc = '+Telescope' }},{{ '<leader>fl', desc = 'Telescope LSP' }},{{ '<leader>fm', desc = 'Cellular Automaton' }},{{ '<leader>fv', desc = 'Telescope Git' }},{{ '<leader>fvc', desc = 'Commits' }},{{ '<leader>lw', desc = '+Workspace' }},{{ '<leader>x', desc = '+Trouble' }}})


-- SECTION: yaml-lsp


lspconfig.yamlls.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
  local filetype = vim.bo[bufnr].filetype
  if filetype == "helm" then
    client.stop()
  end
end,
  cmd = {"yaml-language-server", "--stdio"},
}


-- SECTION: zig-lsp
lspconfig.zls.setup {
  capabilities = capabilities,
  on_attach = default_on_attach,
  cmd = {'zls'}
}




-- SECTION: augroups
local nvf_autogroups = {}
for _, group in ipairs({{["clear"] = true,["enable"] = true,["name"] = "nvf_lazy_file_hooks"},{["clear"] = true,["enable"] = true,["name"] = "nvf_lsp"}}) do
  if group.name then
    nvf_autogroups[group.name] = { clear = group.clear }
  end
end

for group_name, options in pairs(nvf_autogroups) do
  vim.api.nvim_create_augroup(group_name, options)
end


-- SECTION: autocmds
local nvf_autocommands = {{["command"] = "doautocmd User LazyFile",["enable"] = true,["event"] = {"BufReadPost","BufNewFile","BufWritePre"},["group"] = "nvf_lazy_file_hooks",["nested"] = false,["once"] = true}}
for _, autocmd in ipairs(nvf_autocommands) do
  vim.api.nvim_create_autocmd(
    autocmd.event,
    {
      group     = autocmd.group,
      pattern   = autocmd.pattern,
      buffer    = autocmd.buffer,
      desc      = autocmd.desc,
      callback  = autocmd.callback,
      command   = autocmd.command,
      once      = autocmd.once,
      nested    = autocmd.nested
    }
  )
end



-- SECTION: lsp-servers
-- Individual LSP configurations managed by nvf.
vim.lsp.config["*"] = {["capabilities"] = capabilities,["enable"] = true,["on_attach"] = default_on_attach}



-- Enable configured LSPs explicitly
vim.lsp.enable({})


-- SECTION: mappings
vim.keymap.set({"n"}, "gnn", ":lua require('nvim-treesitter.incremental_selection').init_selection()<CR>", {["desc"] = "Init selection [treesitter]",["expr"] = false,["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false})
vim.keymap.set({"n","x"}, "grc", "<cmd>lua require('nvim-treesitter.incremental_selection').scope_incremental()<CR>", {["desc"] = "Increment selection by scope [treesitter]",["expr"] = false,["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false})
vim.keymap.set({"n","x"}, "grm", "<cmd>lua require('nvim-treesitter.incremental_selection').node_decremental()<CR>", {["desc"] = "Decrement selection by node [treesitter]",["expr"] = false,["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false})
vim.keymap.set({"n","x"}, "grn", "<cmd>lua require('nvim-treesitter.incremental_selection').node_incremental()<CR>", {["desc"] = "Increment selection by node [treesitter]",["expr"] = false,["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false})
vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", {["expr"] = false,["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false})
vim.keymap.set("n", "<leader>hm", "<Cmd>lua local conf = require(\"telescope.config\").values; local files = {}; for _, item in ipairs(require(\"harpoon\"):list().items) do table.insert(files, item.value) end; require(\"telescope.pickers\").new({}, {prompt_title = \"Harpoon\", finder = require(\"telescope.finders\").new_table({results = files}), previewer = conf.file_previewer({}), sorter = conf.generic_sorter({})}):find()<CR>", {["expr"] = false,["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false})
vim.keymap.set("n", "<leader>e", ":Neotree filesystem focus right toggle<CR>", {["expr"] = false,["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false})
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {["expr"] = false,["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {["expr"] = false,["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false})
vim.keymap.set("n", "<leader>?", "<Cmd>lua require('which-key').show({ global = false })<CR>", {["expr"] = false,["noremap"] = true,["nowait"] = false,["script"] = false,["silent"] = true,["unique"] = false})


-- Force transparency
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

