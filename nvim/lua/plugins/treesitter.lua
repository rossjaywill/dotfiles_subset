return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    branch = 'master',
    build = ':TSUpdate',
    config = function()
      require('rjw.treesitter')
    end,
    lazy = false,
  },
  {
    'Wansmer/treesj',
    keys = {
      { '<leader>jj', function() require('treesj').toggle() end,                              mode = { 'n', 'x' } },
      { '<leader>jJ', function() require('treesj').toggle({ split = { recursive = true } }) end, mode = { 'n', 'x' } },
    },
    opts = { use_default_keymaps = false },
  },
  {
    'stevearc/aerial.nvim',
    cmd = { 'AerialToggle', 'AerialOpen', 'AerialNavToggle' },
    keys = {
      { '<leader>tt', '<cmd>AerialToggle! right<CR>', desc = 'Toggle symbol outline' },
    },
    opts = {
      backends = { "lsp", "treesitter", "markdown", "man" },
      default_direction = "prefer_right",
      lazy_load = true,
      filter_kind = {
        "Namespace",
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Method",
        "Struct",
        "Field",
        "Event",
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '[', '<cmd>AerialPrev<CR>', {buffer=bufnr})
        vim.keymap.set('n', ']', '<cmd>AerialNext<CR>', {buffer=bufnr})
      end
    },
  },
}
