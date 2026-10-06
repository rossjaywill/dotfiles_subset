require('scrollbar').setup({
  handlers = {
    diagnostics = true,
    -- gitsigns = true,
  },
})

require('tabline').setup {
  enable = true,
  options = {
    show_tabs_always = true,
    show_devicons = true,
    show_bufnr = false,
    show_filename_only = true,
    section_separators = { '', '' },
    component_separators = { '/', '/' },
  }
}

local navic = require('nvim-navic')

local theme = require('lualine.themes.rose-pine')
theme.normal, theme.visual = theme.visual, theme.normal

local function neotest_status()
  local ok, neotest = pcall(require, 'neotest')
  if not ok or not neotest.state then
    return ''
  end

  local passed = 0
  local failed = 0
  local running = 0

  for _, adapter_id in ipairs(neotest.state.adapter_ids()) do
    local counts = neotest.state.status_counts(adapter_id)
    if counts then
      passed = passed + counts.passed
      failed = failed + counts.failed
      running = running + counts.running
    end
  end

  if passed == 0 and failed == 0 and running == 0 then
    return ''
  end

  local normal_hl = '%#lualine_b_normal#'
  local parts = {
    '%#RjwLualineNeotestPassed# ' .. passed,
  }

  if failed > 0 then
    table.insert(parts, '%#RjwLualineNeotestFailed#✗ ' .. failed)
  end

  if running > 0 then
    table.insert(parts, '%#RjwLualineNeotestRunning# ' .. running)
  end

  return table.concat(parts) .. normal_hl
end

local function set_neotest_lualine_highlights()
  local lualine_b = vim.api.nvim_get_hl(0, { name = 'lualine_b_normal' })
  local passed = vim.api.nvim_get_hl(0, { name = 'NeotestPassed' })
  local failed = vim.api.nvim_get_hl(0, { name = 'NeotestFailed' })
  local running = vim.api.nvim_get_hl(0, { name = 'NeotestRunning' })

  vim.api.nvim_set_hl(0, 'RjwLualineNeotestPassed', { fg = passed.fg, bg = lualine_b.bg })
  vim.api.nvim_set_hl(0, 'RjwLualineNeotestFailed', { fg = failed.fg, bg = lualine_b.bg })
  vim.api.nvim_set_hl(0, 'RjwLualineNeotestRunning', { fg = running.fg, bg = lualine_b.bg })
end

require('lualine').setup {
  options = {
    theme = theme,
    section_separators = { left='', right='' },
    component_separators = { left='|', right='|' },
    globalstatus = true,
  },
  sections = {
    lualine_b = {
      'branch',
      'diff',
      'diagnostics',
      neotest_status,
    },
    lualine_c = {
      {
        function()
          return navic.get_location()
        end,
        cond = function()
          return navic.is_available()
        end,
      },
    },
    lualine_x = {
      {
        'filename',
        path = 1,
      },
      'encoding',
      {
        'filetype',
        icon_only = true,
      }
    },
    lualine_z = {
      'location',
    }
  },
  tabline = {
    lualine_c = { require'tabline'.tabline_buffers },
    lualine_x = { require'tabline'.tabline_tabs },
  }
}

set_neotest_lualine_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = set_neotest_lualine_highlights,
})

vim.cmd[[hi Normal guibg=NONE]]
vim.cmd[[hi NormalFloat guibg=NONE]]
vim.cmd[[hi WinSeparator guibg=NONE guifg=#c4a7e7]]
vim.cmd[[hi GitGutterChangeLineNr guibg=NONE ctermbg=NONE]]
vim.cmd[[hi CursorLineNr guifg=#c4a7e7 guibg=NONE ctermbg=NONE]]

vim.cmd[[hi DiffText guifg=#000000 guibg=#e78284 ctermbg=NONE ctermfg=NONE cterm=NONE]]
vim.cmd[[hi String guifg=#98bb7c guibg=NONE ctermbg=NONE ctermfg=NONE cterm=NONE]]

vim.cmd[[hi FloatBorder guibg=NONE ctermbg=NONE ctermfg=NONE cterm=NONE]]
vim.cmd[[hi FloatTitle guibg=NONE ctermbg=NONE ctermfg=NONE cterm=NONE]]
vim.cmd[[hi FloatFooter guibg=NONE ctermbg=NONE ctermfg=NONE cterm=NONE]]
vim.cmd[[hi NormalFloat guibg=NONE ctermbg=NONE ctermfg=NONE cterm=NONE]]
vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'SnacksPicker', { bg = 'NONE' })
vim.api.nvim_set_hl(0, '@property', { fg = '#e0def4' })

-- vim.cmd[[hi @keyword.operator guifg=#e78284 guibg=NONE]] -- new/delete => red
-- vim.cmd[[hi @parameter guifg=#c6a4e6]]
-- vim.cmd[[hi @function.call.cpp guifg=#c4a7e7]]
-- vim.cmd[[hi @function.method.call.cpp guifg=#c4a7e7]]
-- vim.cmd[[hi @variable.member.cpp guifg=#d6d0d0]]

vim.cmd[[hi DiagnosticVirtualTextWarn guibg=NONE]]
vim.cmd[[hi DiagnosticVirtualTextError guibg=NONE]]
vim.cmd[[hi DiagnosticVirtualTextInfo guibg=NONE]]
vim.cmd[[hi DiagnosticVirtualTextHint guibg=NONE]]
