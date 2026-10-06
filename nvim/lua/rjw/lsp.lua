-- override lsp ui borders to be rounded
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- setup lsp keybinds.
vim.keymap.set('n', '<leader>gt', Snacks.picker.lsp_type_definitions)
vim.keymap.set('n', '<leader>gd', Snacks.picker.lsp_definitions)
vim.keymap.set('n', '<leader>gi', Snacks.picker.lsp_implementations)
vim.keymap.set('n', '<leader>gf', Snacks.picker.git_status)
vim.keymap.set('n', '<leader>ge', Snacks.picker.diagnostics)
vim.keymap.set('n', '<leader>gr', Snacks.picker.lsp_references)

vim.keymap.set('n', 'K',          vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>sd', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<leader>sa', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>se', vim.diagnostic.open_float)
-- clang-format (via clangd) / LSP formatting; formats selection in visual mode
vim.keymap.set({'n', 'x'}, '<leader>cf', function() vim.lsp.buf.format({ async = true }) end, { desc = 'Format buffer/range (LSP)' })

-- lsp progress notifier
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    }
  },
  -- virtual_lines = { current_line = true },
  update_in_insert = false,
})

vim.lsp.log.set_level(vim.log.levels.ERROR)

-- advertise blink.cmp's completion capabilities to every server
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

vim.lsp.enable(require('rjw.servers'))
