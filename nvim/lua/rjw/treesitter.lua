local parsers = {
  "cpp", "c", "bash", "python", "java", "javascript", "typescript",
  "rust", "go", "comment", "cmake", "http", "json", "jsonc", "lua", "vim", "make",
  "ninja", "yaml", "regex", "dockerfile", "sql", "markdown", "markdown_inline",
  "jq", "toml", "html", "css", "zig", "cuda", "ini", "git_config", "git_rebase",
  "gitattributes", "gitcommit", "gitignore", "llvm", "latex", "nix", "asm",
  "proto", "templ",
}

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = { "c", "cpp", "objc", "objcpp", "cuda" },
  },
  ensure_installed = parsers,
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["al"] = "@initializer_list.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>na"] = "@parameter.inner",
        ["<leader>nm"] = "@property.outer",
        ["<leader>nf"] = "@function.outer",
      },
      swap_previous = {
        ["<leader>pa"] = "@parameter.inner",
        ["<leader>pm"] = "@property.outer",
        ["<leader>pf"] = "@function.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = { query = "@call.outer", desc = "Next function call start" },
        ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
        ["]o"] = { query = "@class.outer", desc = "Next class start" },
        ["]e"] = { query = "@conditional.outer", desc = "Next conditional start" },
        ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
      },
      goto_previous_start = {
        ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
        ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
        ["[o"] = { query = "@class.outer", desc = "Prev class start" },
        ["[e"] = { query = "@conditional.outer", desc = "Prev conditional start" },
        ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
      },
    },
  }
}

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

-- Vim motion repeat support for above treesitter-objects
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
-- Explicity add back default vim forward/back motions
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
