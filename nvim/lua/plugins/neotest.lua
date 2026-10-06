return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-neotest/neotest-go',
    },
    keys = {
      { '<leader>tr', function() require('neotest').run.run() end, desc = 'Run nearest test' },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Run file tests' },
      { '<leader>ta', function() require('neotest').run.run({ suite = true }) end, desc = 'Run all project tests' },
      { '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end, desc = 'Debug nearest test' },
      { '<leader>to', function() require('neotest').summary.toggle() end, desc = 'Toggle test summary' },
      -- { '<leader>to', function() require('neotest').output.open({ enter = true, auto_close = true }) end, desc = 'Open test output' },
      -- { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Toggle test output panel' },
    },
    opts = function()
      return {
        adapters = {
          require('neotest-go')({
            recursive_run = true,
          }),
        },
        consumers = {
          lualine = function(client)
            local refresh = function()
              vim.schedule(function()
                pcall(require('lualine').refresh, { place = { 'statusline' } })
              end)
            end

            client.listeners.run = refresh
            client.listeners.results = refresh
          end,
        },
      }
    end,
  },
}
