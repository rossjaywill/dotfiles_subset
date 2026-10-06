local dap = require('dap')
local dlv = vim.fn.exepath('dlv')
if dlv == '' then
  dlv = vim.fn.expand('~/go/bin/dlv')
end

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-dap',
  name = 'lldb'
}

dap.adapters.go = {
  type = 'server',
  port = '${port}',
  executable = {
    command = dlv,
    args = { 'dap', '-l', '127.0.0.1:${port}' },
  },
}

-- Resolve the project's test binary: set vim.g.test_binary in a
-- per-project .nvim.lua (see 'exrc'), or get prompted as a fallback
local function test_program()
  if vim.g.test_binary and vim.g.test_binary ~= '' then
    return vim.g.test_binary
  end
  return vim.fn.input('Path to test executable: ', vim.uv.cwd() .. '/build/', 'file')
end

dap.configurations.cpp = {
  {
    name = 'Test Selection',
    type = 'lldb',
    request = 'launch',
    program = test_program,
    cwd = vim.fn.getcwd(),
    stopOnEntry = false,
    env = function()
      local variables = {}
      for k, v in pairs(vim.fn.environ()) do
        table.insert(variables, string.format("%s=%s", k, v))
      end
      return variables
    end,
    -- init_commands = {
    --   "command script import /home/rjw/.config/lldb_pretty/print_loader.py",
    -- }
  },
  {
    -- If you get an "Operation not permitted" error using this, try disabling YAMA:
    --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    name = "Attach to process",
    type = 'lldb',  -- Adjust this to match your adapter name (`dap.adapters.<name>`)
    request = 'attach',
    pid = require('dap.utils').pick_process,
    args = {},
    env = function()
      local variables = {}
      for k, v in pairs(vim.fn.environ()) do
        table.insert(variables, string.format("%s=%s", k, v))
      end
      return variables
    end,
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

dap.configurations.go = {
  {
    name = 'Debug file',
    type = 'go',
    request = 'launch',
    mode = 'debug',
    program = '${file}',
  },
  {
    name = 'Debug package',
    type = 'go',
    request = 'launch',
    mode = 'debug',
    program = '${fileDirname}',
  },
  {
    name = 'Debug test package',
    type = 'go',
    request = 'launch',
    mode = 'test',
    program = '${fileDirname}',
  },
  {
    name = 'Attach to process',
    type = 'go',
    request = 'attach',
    mode = 'local',
    processId = require('dap.utils').pick_process,
  },
}

vim.keymap.set('n', 'B',          dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>dl', dap.run_last)

dap.listeners.after.event_initialized["dapui_config"] = function()
  vim.lsp.enable(require('rjw.servers'), false)

  require('nvim-dap-virtual-text').setup({
    enabled = true,
    enabled_commands = true,
  })

  local dapui = require("dapui")
  dapui.setup()

  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  vim.lsp.enable(require('rjw.servers'), true)
  local dapui = require("dapui")
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  vim.lsp.enable(require('rjw.servers'), true)
  local dapui = require("dapui")
  dapui.close()
end

dap.listeners.after.event_initialized['me.dap.keys'] = function()
  local dapui = require("dapui")
  vim.keymap.set('n', 'C', dap.continue)
  vim.keymap.set('n', 'N', dap.step_over)
  vim.keymap.set('n', 'S', dap.step_out)
  vim.keymap.set('n', 's', dap.step_into)
  vim.keymap.set('n', 'T', dap.terminate)
  vim.keymap.set('n', 'U', dap.up)   -- up call stack frame
  vim.keymap.set('n', 'D', dap.down) -- down call stack frame
  vim.keymap.set('n', 'r', ":lua require('dap').repl.open({}, 'vsplit')<CR>")
  vim.keymap.set('n', 'R', dap.run_to_cursor)
  vim.keymap.set('n', 'I', ":lua require('dap.ui.widgets').hover()<CR>")
  vim.keymap.set('n', 'H', ":lua require('dap.ui.variables').visual_hover()<CR>")
  vim.keymap.set('n', 'E', ":lua require('dapui').eval()<CR>")
end
local reset_keys = function()
  pcall(vim.keymap.del, 'n', 'C')
  pcall(vim.keymap.del, 'n', 'N')
  pcall(vim.keymap.del, 'n', 'S')
  pcall(vim.keymap.del, 'n', 's')
  pcall(vim.keymap.del, 'n', 'T')
  pcall(vim.keymap.del, 'n', 'U')
  pcall(vim.keymap.del, 'n', 'D')
  pcall(vim.keymap.del, 'n', 'r')
  pcall(vim.keymap.del, 'n', 'R')
  pcall(vim.keymap.del, 'n', 'I')
  pcall(vim.keymap.del, 'n', 'H')
  pcall(vim.keymap.del, 'n', 'E')
end
dap.listeners.after.event_terminated['me.dap.keys'] = reset_keys
dap.listeners.after.disconnected['me.dap.keys'] = reset_keys

vim.fn.sign_define('DapBreakpoint',          { text='', texthl='DapBreakpoint', linehl='DapBreakpointLine', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text='', texthl='DapBreakpoint', linehl='DapBreakpointLine', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected',  { text='', texthl='DapBreakpoint', linehl='DapBreakpointLine', numhl= 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint',            { text='', texthl='DapLogPoint', linehl='DapLogPointLine', numhl= 'DapLogPoint' })
vim.fn.sign_define('DapStopped',             { text='', texthl='DapStopped', linehl='DapStoppedLine', numhl= 'DapStopped' })
