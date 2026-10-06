return {
  {
    'williamboman/mason.nvim',
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      -- servers are enabled manually from lsp/<name>.lua configs;
      -- auto-enable targets lspconfig names that don't exist here
      automatic_enable = false,
      ensure_installed = {
        'clangd',
        'bashls',
        'pylsp',
        'lua_ls',
        'rust_analyzer',
        'cmake',
        'zls',
        'gopls',
      }
    },
  },
  {
    'SmiteshP/nvim-navic',
    opts = {
      lsp = {
        auto_attach = true,
      },
      separator = " | ",
    },
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv'} } -- load libuv globals
      }
    }
  },
  {
    'saghen/blink.cmp',
    version = '*',
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = function()
      return require('rjw.blink')
    end,
  },
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = { 'LspAttach', 'DiagnosticChanged', 'BufEnter' },
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup({
        options = {
          overwrite_events = { 'LspAttach', 'DiagnosticChanged', 'BufEnter' },
          show_source = {
            enabled = true,
            if_many = false,
          }
        }
      })
      vim.diagnostic.config({ virtual_text = false })
    end
  },
}
