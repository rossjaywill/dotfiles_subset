-- fzf + lsp i.e. find tings --
vim.keymap.set('n', '<leader>ff', Snacks.picker.files)
vim.keymap.set('n', '<leader>fg', function() Snacks.picker.grep({ find_command = { 'rg', '--hidden', '-n', '-l', '-S' } }) end)
vim.keymap.set('n', '<leader>fG', function() Snacks.picker.grep({ find_command = { 'rg', '--hidden', '-n', '-l', '-S' }, grep_open_files = true }) end)
vim.keymap.set('n', '<leader>fc', function() Snacks.picker.grep({ cwd = vim.fn.stdpath('config') }) end)
vim.keymap.set('n', '<leader>fn', function() Snacks.picker.files({ cwd = '~/notes' }) end)
vim.keymap.set('n', '<leader>fr', Snacks.picker.git_files) -- whole repo, not just from nvim root
vim.keymap.set('n', '<leader>fh', Snacks.picker.recent)
vim.keymap.set('n', '<leader>fw', function() Snacks.picker.grep({ search = vim.fn.expand('<cword>') }) end)
vim.keymap.set('n', '<leader>fb', Snacks.picker.buffers)
vim.keymap.set('n', '<leader>fl', Snacks.picker.resume) -- resume last search
vim.keymap.set('n', '<leader>fs', Snacks.picker.search_history) -- search previous searches
vim.keymap.set('n', '<leader>fj', Snacks.picker.jumps)
vim.keymap.set('n', '<leader>fe', Snacks.picker.diagnostics_buffer)
vim.keymap.set('n', '<leader>f?', Snacks.picker.help)
vim.keymap.set('n', '<leader>fm', Snacks.picker.man)

-- commands --
vim.keymap.set('n', '<leader>ch', Snacks.picker.command_history)
vim.keymap.set('n', '<leader>cc', Snacks.picker.commands)
vim.keymap.set('n', '<leader>kk', Snacks.picker.keymaps)
