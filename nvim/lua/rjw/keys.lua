-- reload current buffer as nvim conf
vim.keymap.set('n', '<leader>so', ':so %<CR>')

-- Switch header <-> impl
local clangd = require('rjw.clangd')
vim.api.nvim_create_user_command('ClangdSwitchSourceHeader', clangd.switch_source_header, {
  desc = 'Switch source/header',
  force = true,
})
vim.keymap.set('n', '<leader>sh', clangd.switch_source_header, { desc = 'Switch source/header' })

-- buffers
vim.keymap.set('n', '<C-c>',         ':bd<CR>')
vim.keymap.set('n', '<leader>cb',    ':bp|bd #<CR>')
vim.keymap.set('n', '<A-n>',         ':bn<CR>')
vim.keymap.set('n', '<A-p>',         ':bp<CR>')

-- split resize keymaps live in the smart-splits plugin spec;
-- <C-hjkl> navigation comes from tmux.nvim default keybindings

vim.keymap.set('n', 'gl', '$')
vim.keymap.set('n', 'gh', '^')
vim.keymap.set('v', 'gl', '$')
vim.keymap.set('v', 'gh', '^')

-- yank to system clipboard
vim.keymap.set({'n', 'x'}, '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+Y')

vim.keymap.set('n', '<leader>cl', ':set hls!<CR>') -- toggle search highlight

-- quickfix toggle
vim.keymap.set('n', '<leader>qq', function()
  if vim.fn.getqflist({winid = 0}).winid == 0 then
    vim.cmd('copen')
  else
    vim.cmd('cclose')
  end
end)
vim.keymap.set('n', '<leader>qn', '<cmd>cnext<CR>')
vim.keymap.set('n', '<leader>qp', '<cmd>cprev<CR>')

-- diff
vim.keymap.set('n', '<leader>vc', ':CodeDiff<CR>')

-- centre screen after jump commands
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv') -- centre and open folds, just incasey
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '{', '{zz')
vim.keymap.set('n', '}', '}zz')
vim.keymap.set('n', '%', '%zz')
vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', '#', '#zz')
vim.keymap.set('n', 'gg', 'ggzz')
vim.keymap.set('n', 'G', 'Gzz')

-- segment backspaces to logical positions
vim.keymap.set('i', ',', ',<c-g>u')
vim.keymap.set('i', '.', '.<c-g>u')
vim.keymap.set('i', '!', '!<c-g>u')
vim.keymap.set('i', '?', '?<c-g>u')
vim.keymap.set('i', '(', '(<c-g>u')
vim.keymap.set('i', ')', ')<c-g>u')
vim.keymap.set('i', '{', '{<c-g>u')
vim.keymap.set('i', '}', '}<c-g>u')

-- move lines or selections up/down keeping relative indenting
vim.keymap.set('v', 'J',         ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K',         ":m  '<-2<CR>gv=gv")
vim.keymap.set('i', '<C-j>',     "<esc>:m .+1<CR>==i")
vim.keymap.set('i', '<C-k>',     "<esc>:m .-2<CR>==i")
vim.keymap.set('n', '<leader>j', ":m .+1<CR>==<Esc>")
vim.keymap.set('n', '<leader>k', ":m .-2<CR>==<Esc>")

-- prettify/unprettify json
vim.keymap.set('n', '<leader>pp', ":%!jq<CR><CR>")
vim.keymap.set('n', '<leader>up', ":%!jq -c<CR><CR>")

vim.keymap.set('n','<leader>U', ":UndotreeToggle<CR>")

-- lazy package manager --
vim.keymap.set('n','<leader>du', ":Lazy sync<CR>")

-- folds + treesitter: close the treesitter fold under the cursor
-- (zf doesn't work with foldmethod=expr; zc also re-enables 'foldenable')
vim.keymap.set('n','<leader>zf', "zc")

-- async build into quickfix (vim-dispatch; makeprg set per filetype)
vim.keymap.set('n','<leader>bb', ":Make<CR>")

-- unbind f1 as help
vim.keymap.set('n','<F1>', '<nop>')

vim.keymap.set('n', '<leader>sn', function() Snacks.notifier.show_history() end, { noremap = true, silent = true })

-- cleanup cout lines
vim.keymap.set('n', '<leader>cd', ":%s/.*std::cout.*\\n//gc<CR>", { noremap = true, silent = true })
-- cleanup trailing whitespace
vim.keymap.set('n', '<leader>tw', ":%s/\\s\\+$//e<CR>", { noremap = true, silent = true })

-- lsp inlay hints
vim.keymap.set('n', '<leader>hh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { noremap = true, silent = true })

vim.keymap.set({'n', 'x'}, '<leader>sc', "<cmd>setlocal spell! spelllang=en_gb<CR>", { noremap = true, silent = true })
