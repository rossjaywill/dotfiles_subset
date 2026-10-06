vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('rjw.options')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = {
    { import = 'plugins' },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "rplugin",
        "tarPlugin",
        "zipPlugin",
        "gzip",
        "tohtml",
        "tutor",
        "netrwPlugin",
      }
    }
  },
})

require('rjw.ui')
require('rjw.autocommands')
require('rjw.picker')
require('rjw.lsp')
require('rjw.keys')

-- require('insights').setup({
--     local_only = true,
--     use_libc = false,
-- })

require('markview.extras.checkboxes').setup()
require('markview.extras.headings').setup()
require('markview.extras.editor').setup()

if vim.fn.executable('rg') == 1 then
  vim.o.grepprg = 'rg --vimgrep'
  vim.o.grepformat = '%f:%l:%c:%m'
end
