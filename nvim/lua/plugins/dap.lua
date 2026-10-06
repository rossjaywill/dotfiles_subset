return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { 'B',          function() require('dap').toggle_breakpoint() end, desc = 'Toggle breakpoint' },
      { '<leader>dl', function() require('dap').run_last() end,          desc = 'DAP run last' },
      { '<leader>ut', function() require('rjw.unittest')() end,          desc = 'Pick and debug unit test' },
    },
    config = function()
      require('rjw.dap')
    end,
  },
}
