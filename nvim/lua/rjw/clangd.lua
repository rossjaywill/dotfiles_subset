local M = {}

local header_extensions = {
  h = true,
  hh = true,
  hpp = true,
  hxx = true,
}

local source_extensions = {
  c = true,
  cc = true,
  cpp = true,
  cxx = true,
  ["c++"] = true,
  m = true,
  mm = true,
}

local header_candidates = { "h", "hh", "hpp", "hxx" }
local source_candidates = { "c", "cc", "cpp", "cxx", "c++", "m", "mm" }
local root_markers = { ".git", ".clangd", "compile_commands.json", "compile_flags.txt" }

local function normalize(path)
  return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local function extension(path)
  return vim.fn.fnamemodify(path, ":e"):lower()
end

local function basename_without_extension(path)
  return vim.fn.fnamemodify(path, ":t:r")
end

local function add_root(roots, seen, root)
  if not root or root == "" then
    return
  end

  local normalized = normalize(root)
  if seen[normalized] then
    return
  end

  seen[normalized] = true
  table.insert(roots, normalized)
end

local function project_roots(bufnr)
  local roots = {}
  local seen = {}
  local current_file = vim.api.nvim_buf_get_name(bufnr)

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })) do
    add_root(roots, seen, client.root_dir)

    for _, folder in ipairs(client.workspace_folders or {}) do
      add_root(roots, seen, vim.uri_to_fname(folder.uri))
    end
  end

  local marker = vim.fs.find(root_markers, {
    path = current_file ~= "" and vim.fs.dirname(current_file) or vim.uv.cwd(),
    upward = true,
  })[1]
  if marker then
    add_root(roots, seen, vim.fs.dirname(marker))
  end

  add_root(roots, seen, vim.uv.cwd())

  return roots
end

local function alternate_filenames(path)
  local ext = extension(path)
  local stem = basename_without_extension(path)
  local candidates

  if header_extensions[ext] then
    candidates = source_candidates
  elseif source_extensions[ext] then
    candidates = header_candidates
  else
    return {}
  end

  local names = {}
  for _, candidate_ext in ipairs(candidates) do
    table.insert(names, ("%s.%s"):format(stem, candidate_ext))
  end

  return names
end

local function path_score(path)
  local score = 0
  local lower = path:lower()

  if lower:find("/include/", 1, true) or lower:find("/inc/", 1, true) then
    score = score + 20
  end

  if lower:find("/src/", 1, true) or lower:find("/source/", 1, true) then
    score = score + 10
  end

  if lower:find("/build/", 1, true) or lower:find("/cmake%-build", 1, false) then
    score = score - 30
  end

  return score
end

local function fallback_switch(bufnr)
  local current_file = vim.api.nvim_buf_get_name(bufnr)
  if current_file == "" then
    vim.notify("No file name for current buffer", vim.log.levels.WARN)
    return
  end

  local current = normalize(current_file)
  local names = alternate_filenames(current)
  if #names == 0 then
    vim.notify("Current file is not a known C/C++ source or header", vim.log.levels.WARN)
    return
  end

  local matches = {}
  local seen = {}
  for _, root in ipairs(project_roots(bufnr)) do
    for _, match in ipairs(vim.fs.find(names, { path = root, type = "file", limit = 100 })) do
      local normalized = normalize(match)
      if normalized ~= current and not seen[normalized] then
        seen[normalized] = true
        table.insert(matches, normalized)
      end
    end
  end

  if #matches == 0 then
    vim.notify("No matching source/header found", vim.log.levels.WARN)
    return
  end

  table.sort(matches, function(left, right)
    local left_score = path_score(left)
    local right_score = path_score(right)
    if left_score == right_score then
      return left < right
    end
    return left_score > right_score
  end)

  vim.cmd.edit(vim.fn.fnameescape(matches[1]))
end

function M.switch_source_header()
  local bufnr = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(bufnr)
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })[1]

  if not client or current_file == "" then
    fallback_switch(bufnr)
    return
  end

  client:request("textDocument/switchSourceHeader", {
    uri = vim.uri_from_bufnr(bufnr),
  }, function(err, result)
    if err then
      vim.notify(err.message or "clangd source/header switch failed", vim.log.levels.WARN)
      vim.schedule(function()
        fallback_switch(bufnr)
      end)
      return
    end

    if result and result ~= vim.NIL then
      local path = vim.uri_to_fname(result)
      if path and path ~= "" then
        vim.schedule(function()
          vim.cmd.edit(vim.fn.fnameescape(path))
        end)
        return
      end
    end

    vim.schedule(function()
      fallback_switch(bufnr)
    end)
  end, bufnr)
end

return M
