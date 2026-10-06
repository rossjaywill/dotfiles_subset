local seto = vim.opt -- map opts to set, to keep similar API as in Vim options
local setg = vim.g   -- map global opts

seto.termguicolors = true
seto.laststatus = 3
seto.swapfile = false
seto.backup = false
seto.scrolloff = 16
seto.wrap = false
seto.ignorecase = true
seto.smartcase = true
seto.eol = true
seto.startofline = false
seto.confirm = true
seto.visualbell = true
seto.cmdheight = 1
seto.number = true
seto.relativenumber = true
seto.cursorline = true
seto.timeout = true
seto.ttimeout = true
seto.timeoutlen = 800
seto.ttimeoutlen = 0
seto.tabstop = 4
seto.softtabstop = 4
seto.shiftwidth = 4
seto.expandtab = true
seto.showtabline = 2
seto.list = true
seto.listchars = { tab = '»-', trail = '⋅' }
seto.clipboard = "unnamed"
vim.opt_local.formatoptions:remove('o') -- o and O, don't continue comments

-- Quality of Life
seto.shortmess:append('c')
seto.updatetime = 100
seto.sessionoptions:remove('options') -- do not store global config in sessions
seto.undofile = true -- persistent undo history
seto.undolevels = 5000
seto.completeopt = 'menu,menuone,noselect'
seto.lazyredraw = true

seto.splitbelow = true
seto.splitright = true

seto.foldenable = false
seto.foldmethod = 'expr'
seto.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- allow per-project config from .nvim.lua (sandboxed, prompts for trust)
seto.exrc = true

seto.mouse = 'a'
seto.guicursor = ''

-- disable unused default plugins
setg.loaded_logiPat = 1
setg.loaded_rrhelper = 1
setg.loaded_man = 1
setg.loaded_2html_plugin = 1
setg.loaded_shada_plugin = 1
setg.loaded_spellfile_plugin = 1
setg.loaded_tutor_mode_plugin = 1
setg.loaded_remote_plugins = 1

-- disable unused language providers
setg.loaded_python_provider = 0
setg.loaded_python3_provider = 0
setg.loaded_ruby_provider = 0
setg.loaded_node_provider = 0
