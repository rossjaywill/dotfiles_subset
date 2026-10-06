-- List tests from the project's test binary and debug the selection.
-- The binary comes from vim.g.test_binary (set per-project via .nvim.lua),
-- falling back to a prompt.

local function resolve_binary()
  if vim.g.test_binary and vim.g.test_binary ~= '' then
    return vim.g.test_binary
  end

  local bin = vim.fn.input('Path to test executable: ', vim.uv.cwd() .. '/build/', 'file')
  if bin ~= '' then
    vim.g.test_binary = bin
  end
  return bin
end

local function test_picker()
  local bin = resolve_binary()
  if bin == '' then
    return
  end

  vim.system({ bin, '--list-tests' }, { text = true }, vim.schedule_wrap(function(out)
    if out.code ~= 0 then
      vim.notify('Failed to list tests:\n' .. (out.stderr or ''), vim.log.levels.ERROR)
      return
    end

    local items = {}
    for _, line in ipairs(vim.split(out.stdout or '', '\n', { trimempty = true })) do
      table.insert(items, { text = line })
    end
    if #items == 0 then
      vim.notify('No tests found!', vim.log.levels.WARN)
      return
    end

    Snacks.picker.pick({
      title = 'unit tests',
      items = items,
      format = 'text',
      confirm = function(picker, item)
        picker:close()
        if not item then
          return
        end

        local dap = require('dap')
        local config = vim.deepcopy(dap.configurations.cpp[1])
        config.args = { '-n', item.text }
        dap.run(config)
      end,
    })
  end))
end

return test_picker
