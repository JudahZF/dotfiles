-- In your init.lua or a dedicated plugins/init.lua file managed by lazy.nvim
return {
  'nmac427/guess-indent.nvim',
  config = function()
    require('guess-indent').setup({
      auto_cmds = true, -- Automatically set up autocommands to guess on BufReadPost
      override_indent = true, -- If true, it will override existing indentation settings
    })
  end
}
