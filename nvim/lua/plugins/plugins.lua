return {
    -- colourscheme
    {
      'rose-pine/neovim',
      name = 'rose-pine',
      priority = 1000,
      config = function()
        require('rose-pine').setup({
          variant = 'moon',
          dark_variant = 'moon',
          extend_background_behind_borders = true,
          dim_inactive_windows = false,
          highlight_groups = {
            -- distinguish C++ member variables from locals
            ['@lsp.type.property.cpp']                   = { fg = '#e0def4' },
            ['@parameter']                               = { fg = '#e0def4' },
            ['@keyword.operator']                        = { fg = '#eb6f92' },
            ['@type.qualifier']                          = { fg = '#9ccfd8' },
            ['@type.builtin']                            = { fg = '#9ccfd8' },
            ['@storageclass']                            = { fg = '#9ccfd8' },
            ['@lsp.type.method.cpp']                     = { fg = '#c4a7e7' },
            ['@function.method.call.cpp']                = { fg = '#c4a7e7' },
            ['@lsp.typemod.method.defaultLibrary.cpp']   = { fg = '#ea9a97' },
            ['@lsp.typemod.function.defaultLibrary.cpp'] = { fg = '#ea9a97' },
            ['@lsp.typemod.method.declaration.cpp']      = { fg = '#c4a7e7' },
            ['@lsp.typemod.method.definition.cpp']       = { fg = '#c4a7e7' },
            ['@lsp.typemod.function.declaration.cpp']    = { fg = '#c4a7e7' },
            ['@lsp.typemod.function.definition.cpp']     = { fg = '#c4a7e7' },
            ['@lsp.typemod.function.globalScope.cpp']    = { fg = '#c4a7e7' },
          },
        })
        vim.cmd[[colorscheme rose-pine-moon]]
      end,
    },

    -- ui, loaded at startup and configured in rjw.ui
    { 'nvim-lualine/lualine.nvim' },
    { 'kdheepak/tabline.nvim' },
    { 'petertriho/nvim-scrollbar' },
    { 'nvim-tree/nvim-web-devicons' },
    {
      'OXY2DEV/markview.nvim',
      lazy = false, -- author recommends against lazy-loading
    },

    {
      'esmuellert/codediff.nvim',
      cmd = "CodeDiff"
    },
    {
      'max397574/better-escape.nvim',
      event = 'InsertEnter',
      config = function()
        require('better_escape').setup()
      end,
    },
    {
      'aserowy/tmux.nvim',
      event = 'VeryLazy',
      opts = {
        copy_sync = {
          enable = true,
        },
        navigation = {
          enable_default_keybindings = true,
        },
        resize = {
          enable_default_keybindings = true,
        }
      },
    },
    {
      -- split resizing only; <C-hjkl> navigation is handled by tmux.nvim
      'mrjones2014/smart-splits.nvim',
      keys = {
        { '<A-Left>',  function() require('smart-splits').resize_left() end },
        { '<A-Down>',  function() require('smart-splits').resize_down() end },
        { '<A-Up>',    function() require('smart-splits').resize_up() end },
        { '<A-Right>', function() require('smart-splits').resize_right() end },
      },
      opts = {},
    },
    {
      'brenoprata10/nvim-highlight-colors',
      event = 'VeryLazy',
      config = function()
        require('nvim-highlight-colors').setup()
      end,
    },
    -- {
    --   'simonwinther/cppman.nvim',
    --   verison = '*',
    --   cmd = 'cppman',
    --   opts = {
    --     picker = {
    --       provider = 'snacks',
    --     },
    --   },
    --   keys = {
    --     { '<leader>cs', function() require('cppman').search() end },
    --     { '<leader>cu', function() require('cppman').open_for(vim.fn.expand('<cword>')) end },
    --   },
    -- },
    -- { 'rossjaywill/insights.nvim' },

    { 'echasnovski/mini.icons',     version = '*', event = 'VeryLazy', opts = {} },
    { 'echasnovski/mini.ai',        version = '*', event = 'VeryLazy', opts = {} },
    { 'echasnovski/mini.pairs',     version = '*', event = 'VeryLazy', opts = {} },
    { 'echasnovski/mini.align',     version = '*', event = 'VeryLazy', opts = {} },
    { 'echasnovski/mini.operators', version = '*', event = 'VeryLazy', opts = {} },
    { 'echasnovski/mini.surround',  version = '*', event = 'VeryLazy', opts = {} },

    -- vim
    { 'tpope/vim-eunuch' },
    { 'tpope/vim-repeat', event = 'VeryLazy' },
    {
      'tpope/vim-obsession',
      cmd = 'Obsession',
    },
    { 'tpope/vim-sleuth' },
    { 'tpope/vim-speeddating', event = 'VeryLazy' },
    {
      'tpope/vim-dispatch',
      cmd = { 'Dispatch', 'Make', 'Focus', 'Start' },
    },
    { 'jessarcher/vim-heritage' },
    { 'mtdl9/vim-log-highlighting', ft = 'log' },
    {
      'mbbill/undotree',
      cmd = 'UndotreeToggle',
    },
}
