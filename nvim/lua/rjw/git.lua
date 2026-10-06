require('gitsigns').setup()

-- git
vim.keymap.set('n', '<leader>gb', ':Gitsigns blame<CR>')
vim.keymap.set('n', '<leader>gB', ':Gitsigns toggle_current_line_blame<CR>')
vim.keymap.set('n', '<leader>gq', ':Gitsigns setqflist<CR>')

vim.keymap.set('n', '<leader>n', ':Gitsigns next_hunk<CR>')
vim.keymap.set('n', '<leader>p', ':Gitsigns prev_hunk<CR>')
