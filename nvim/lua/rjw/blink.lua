-- blink.cmp configuration (returns the opts table consumed by the plugin spec)
return {
  keymap = {
    preset = 'none',
    -- j/k navigation
    ['<C-j>'] = { 'select_next', 'fallback' },
    ['<C-k>'] = { 'select_prev', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<Tab>'] = { 'select_next', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-Space>'] = { 'show', 'fallback' },
    ['<C-e>'] = { 'hide', 'fallback' },
    ['<q>'] = { 'hide', 'fallback' },
    ['<Esc>'] = { 'hide', 'fallback' },
    ['<CR>'] = { 'accept', 'fallback' },
  },
  completion = {
    menu = { border = 'rounded' },
    documentation = {
      auto_show = true,
      window = { border = 'rounded' },
    },
    ghost_text = { enabled = true },
    -- preselect, and <CR> replaces the word under the cursor on accept
    list = { selection = { preselect = true, auto_insert = false } },
  },
  sources = {
    default = { 'lazydev', 'lsp', 'path', 'buffer' },
    per_filetype = {
      org = { 'orgmode', 'path', 'buffer' },
    },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
      orgmode = {
        name = 'Orgmode',
        module = 'orgmode.org.autocompletion.blink',
        fallbacks = { 'buffer' },
      },
    },
  },
  cmdline = {
    keymap = { preset = 'cmdline' },
    completion = { menu = { auto_show = true } },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
}
