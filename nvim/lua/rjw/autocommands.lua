local enter_file = {"BufEnter", "BufWinEnter", "BufRead", "BufNewFile"}
vim.api.nvim_create_autocmd(enter_file, {
  pattern = {"*.json", "*.jsonc"},
  command = "set conceallevel=0"
})
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"help", "man"},
  command = "wincmd L"
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.list = false
    vim.opt_local.shiftwidth = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
  callback = function()
    vim.opt_local.autoindent = true
    vim.opt_local.cindent = true
    vim.opt_local.smartindent = false
    vim.opt_local.indentexpr = ""
    if vim.uv.fs_stat(vim.uv.cwd() .. '/build/CMakeCache.txt') then
      vim.opt_local.makeprg = 'cmake --build build --parallel'
    end
  end,
})
-- log highlighting extensions
vim.api.nvim_create_autocmd("FileType", {
  pattern = "log",
  command = "syn keyword logLevelError Error | syn keyword logLevelWarning Warning | syn keyword logLevelInfo Info | syn keyword logLevelDebug Debug"
})

-- write all on buffer exit
vim.api.nvim_create_autocmd({"FocusLost"}, {
  pattern = "*",
  command = "silent! wa"
})
-- strip trailing whitespace before write, keeping cursor position
vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = "*",
    callback = function()
      local view = vim.fn.winsaveview()
      vim.cmd([[%s/\s\+$//e]])
      vim.fn.winrestview(view)
    end,
})

local gofmt_group = vim.api.nvim_create_augroup("GoFormat", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = gofmt_group,
  pattern = "*.go",
  callback = function(args)
    local view = vim.fn.winsaveview()
    local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, true)
    local formatted = vim.fn.systemlist("gofmt", lines)

    if vim.v.shell_error ~= 0 then
      vim.notify(table.concat(formatted, "\n"), vim.log.levels.ERROR)
      return
    end

    vim.api.nvim_buf_set_lines(args.buf, 0, -1, true, formatted)
    vim.fn.winrestview(view)
  end,
})

local wr_group = vim.api.nvim_create_augroup('WinResize', { clear = true })
vim.api.nvim_create_autocmd(
  'VimResized',
  {
    group = wr_group,
    pattern = '*',
    command = 'wincmd =',
    desc = 'Automatically resize windows when the host window size changes.'
  }
)

-- Auto-use codediff.nvim when launched as: nvim -d file1 file2
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if not vim.o.diff then
      return
    end

    local argv = vim.fn.argv()
    if #argv ~= 2 then
      return
    end

    local left = vim.fn.fnameescape(argv[1])
    local right = vim.fn.fnameescape(argv[2])

    -- Stop builtin diff layout created by -d
    pcall(vim.cmd, "windo diffoff")
    pcall(vim.cmd, "only")

    -- If you're using lazy.nvim and codediff.nvim is lazy-loaded, load it now
    pcall(function()
      require("lazy").load({ plugins = { "codediff.nvim" } })
    end)

    -- Try opening codediff using the two file paths
    local ok = pcall(vim.cmd, ("CodeDiff file %s %s"):format(left, right))
    if not ok then
      -- Fallback: open the files first, then run :CodeDiff with no args
      vim.cmd(("edit %s"):format(left))
      vim.cmd(("vsplit %s"):format(right))
      pcall(vim.cmd, "CodeDiff")
    end
  end,
})
