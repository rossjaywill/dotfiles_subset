return {
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    config = function()
      local Menu = require('org-modern.menu')
      require('orgmode').setup({
        org_agenda_files = '~/org/**/*',
        org_default_notes_file = '~/org/refile.org',
        ui = {
          menu = {
            handler = function(data)
              Menu:new({
                window = {
                  margin = { 1, 0, 1, 0 },
                  padding = { 0, 1, 0, 1 },
                  title_pos = 'center',
                  border = 'rounded',
                  zindex = 1000,
                },
                icons = {
                  separator = '➜',
                },
              }):open(data)
            end,
          },
        },
      })
    end,
    dependencies = {
      -- floating window menus for agenda/capture prompts, matching the
      -- rounded-border style used elsewhere in this config
      { 'danilshvalov/org-modern.nvim' },
    },
  },
  {
    -- concealed heading stars and pretty checkboxes, the org counterpart
    -- to what markview provides for markdown
    'nvim-orgmode/org-bullets.nvim',
    ft = 'org',
    opts = {},
  },
  {
    'lukas-reineke/headlines.nvim',
    ft = 'org',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      -- org only; markdown rendering is owned by markview
      markdown = {
        headline_highlights = false,
        codeblock_highlight = false,
        dash_highlight = false,
        quote_highlight = false,
      },
      rmd = {
        headline_highlights = false,
        codeblock_highlight = false,
        dash_highlight = false,
        quote_highlight = false,
      },
    },
  },
}
