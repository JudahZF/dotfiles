# Portable Neovim export

This directory contains a flat Lua export of the Nix/NVF Neovim config.

## Files

- `init.lua` - generated flat Neovim config, with Nix store binary paths replaced by normal executable names where possible.

## Install on another machine

1. Install Neovim 0.11+.
2. Back up any existing config:

   ```sh
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

3. Copy this export:

   ```sh
   mkdir -p ~/.config/nvim
   cp init.lua ~/.config/nvim/init.lua
   ```

4. Install required plugins with your preferred plugin manager. This file was generated from NVF and assumes these Lua modules are available:

   - `tokyonight.nvim`
   - `lz.n`
   - `lzn-auto-require`
   - `rtp.nvim`
   - `nvim-lspconfig`
   - `nvim-cmp`, `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp-treesitter`, `cmp_luasnip`
   - `LuaSnip`, `friendly-snippets`
   - `telescope.nvim`, `telescope-fzf-native.nvim`
   - `nvim-treesitter`, `nvim-ts-autotag`
   - `which-key.nvim`
   - `harpoon`
   - `neo-tree.nvim`, `nvim-web-devicons`, `plenary.nvim`, `nui.nvim`
   - `toggleterm.nvim`
   - `trouble.nvim`
   - `conform.nvim`
   - `fidget.nvim`
   - `guess-indent.nvim`
   - `cloak.nvim`
   - `undotree`
   - `rustaceanvim`

5. Install external tools used by the config if you want all features:

   ```sh
   # macOS example
   brew install ripgrep fd lazygit lua-language-server nil gopls rust-analyzer
   npm i -g bash-language-server vscode-langservers-extracted typescript typescript-language-server yaml-language-server @tailwindcss/language-server basedpyright
   ```

   Optional/additional LSPs/tools: `phpactor`, `sqls`, `zls`, `ansible-language-server`, `templ`.

## Important caveat

This is a flat export of the generated config, not a fully self-installing Neovim distribution. On Nix, NVF provides the plugins and parsers. On a non-Nix machine, you must install those plugins yourself or convert this into a plugin-manager config such as `lazy.nvim`.
