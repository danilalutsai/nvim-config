local gh = require "gh"

vim.pack.add {
  gh "stevearc/oil.nvim",
  gh "nvim-mini/mini.icons",
}

local oil = require "oil"

local function tmux_navigate(command)
  return function()
    vim.cmd(command)
  end
end

local function resize_preview_split()
  local preview_win = require("oil.util").get_preview_win()

  if not preview_win or not vim.api.nvim_win_is_valid(preview_win) then
    return
  end

  local oil_win = vim.api.nvim_get_current_win()
  local total_width = vim.api.nvim_win_get_width(oil_win) + vim.api.nvim_win_get_width(preview_win)
  local preview_width = math.max(1, math.floor(total_width * 0.7))

  vim.api.nvim_win_set_width(preview_win, preview_width)
end

local function open_oil_preview()
  oil.open_preview({}, function(err)
    if not err then
      resize_preview_split()
    end
  end)
end

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
    signcolumn = "no",
    statuscolumn = "  ",
    list = false,
  },

  preview_win = {
    update_on_cursor_moved = true,
    preview_method = "fast_scratch",
    win_options = {
      number = false,
      relativenumber = false,
      signcolumn = "no",
      statuscolumn = "  ",
    },
  },

  keymaps = {
    ["<CR>"] = "actions.select",

    ["<Tab>"] = "actions.select",
    ["<S-Tab>"] = "actions.parent",

    ["<C-v>"] = "actions.select_vsplit",
    ["<C-s>"] = "actions.select_split",
    ["v"] = false,
    ["V"] = false,

    ["<C-p>"] = open_oil_preview,
    ["y"] = "actions.copy_to_system_clipboard",
    ["p"] = "actions.paste_from_system_clipboard",
    ["x"] = { "actions.paste_from_system_clipboard", opts = { delete_original = true } },
    ["<BS>"] = tmux_navigate("TmuxNavigateLeft"),
    ["<C-h>"] = tmux_navigate("TmuxNavigateLeft"),
    ["<C-j>"] = tmux_navigate("TmuxNavigateDown"),
    ["<C-k>"] = tmux_navigate("TmuxNavigateUp"),
    ["<C-l>"] = tmux_navigate("TmuxNavigateRight"),
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
        open_oil_preview()
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
