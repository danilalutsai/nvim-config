local gh = require "gh"

vim.pack.add {
  gh "stevearc/oil.nvim",
  gh "nvim-mini/mini.icons",
}

local oil = require "oil"

oil.setup({
  default_file_explorer = true,

  columns = {
    "icon",
  },

  view_options = {
    show_hidden = true,
  },

  win_options = {
    number = false,
    relativenumber = false,
    statuscolumn = "",
    signcolumn = "no",
    list = false,
  },

  preview_win = {
    update_on_cursor_moved = true,
    preview_method = "fast_scratch",
  },

  keymaps = {
    ["<CR>"] = "actions.select",

    ["<Tab>"] = "actions.select",
    ["<S-Tab>"] = "actions.parent",

    ["<C-v>"] = "actions.select_vsplit",
    ["<C-s>"] = "actions.select_split",
    ["v"] = false,
    ["V"] = false,

    ["<C-p>"] = "actions.preview",
    ["<C-h>"] = "<cmd><C-U>TmuxNavigateLeft<cr>",
    ["<C-j>"] = "<cmd><C-U>TmuxNavigateDown<cr>",
    ["<C-k>"] = "<cmd><C-U>TmuxNavigateUp<cr>",
    ["<C-l>"] = "<cmd><C-U>TmuxNavigateRight<cr>",
    ["q"] = "actions.close",
  },
})

-- Open Oil normally
vim.keymap.set("n", "<leader>cd", "<cmd>Oil<CR>", {
  desc = "Open Oil with preview",
})

vim.keymap.set("n", "-", "<cmd>Oil<CR>", {
  desc = "Open parent directory",
})

-- Automatically open Oil preview reliably
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("OilAutoPreview", { clear = true }),
  pattern = "OilEnter",
  callback = function(args)
    local oil = require("oil")
    local oil_buf = args.data and args.data.buf or vim.api.nvim_get_current_buf()
    local tries = 0
    local max_tries = 10

    local function open_preview_when_ready()
      tries = tries + 1

      -- Stop if you left the Oil buffer
      if not vim.api.nvim_buf_is_valid(oil_buf) or vim.api.nvim_get_current_buf() ~= oil_buf then
        return
      end

      -- Preview only works when Oil has a real file selected
      local entry = oil.get_cursor_entry()

      if entry and entry.type == "file" then
        oil.open_preview({})
        return
      end

      -- Oil may initially select ../ or a folder.
      -- Retry shortly while the directory finishes loading.
      if tries < max_tries then
        vim.defer_fn(open_preview_when_ready, 80)
      end
    end

    vim.defer_fn(open_preview_when_ready, 80)
  end,
})
