vim.pack.add {
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-mini/mini.icons",
}

local oil = require "oil"

-- Resolved lazily on first render: mini.icons must finish setup first.
local icon_provider

-- Keep the listing in Photon's neutral palette; use purple only for the
-- parent-directory icon.
local colors = {
  foreground = "#c6c6c6",
  selection = "#3a3a3a",
  comment = "#626262",
  muted = "#767676",
  purple = "#cba6f7",
}

local DEFAULT_DIR_HL = "OilDefaultDir"
local DEFAULT_FILE_HL = "OilDefaultFile"
local DIR_ICON_HL = "OilDirIcon"
local FILE_ICON_HL = "OilFileIcon"
local PARENT_ICON_HL = "OilParentIcon"

-- Cursor line background, scoped to oil windows through winhighlight below.
-- Scoped on purpose: `cursorline` is off globally (lua/options.lua), so this
-- must not become a plain CursorLine override or every code buffer picks up a
-- highlighted line.
local CURSOR_LINE_HL = "OilCursorLine"

local function set_oil_highlights()
  vim.api.nvim_set_hl(0, DEFAULT_DIR_HL, { fg = colors.muted })
  vim.api.nvim_set_hl(0, DEFAULT_FILE_HL, { fg = colors.foreground })
  vim.api.nvim_set_hl(0, DIR_ICON_HL, { fg = colors.muted })
  vim.api.nvim_set_hl(0, FILE_ICON_HL, { fg = colors.comment })
  vim.api.nvim_set_hl(0, PARENT_ICON_HL, { fg = colors.purple })
  vim.api.nvim_set_hl(0, CURSOR_LINE_HL, { bg = colors.selection })
end

set_oil_highlights()

-- A colorscheme load wipes custom groups, so re-register on every switch.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("OilDefaultDirHl", { clear = true }),
  callback = set_oil_highlights,
})

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
  local preview_width = math.max(1, math.floor(total_width * 0.78))

  vim.api.nvim_win_set_width(preview_win, preview_width)
end

local function open_oil_preview()
  oil.open_preview({}, function(err)
    if not err then
      resize_preview_split()
    end
  end)
end

-- Keep mini.icons' glyphs, but use Photon's neutral colors in Oil.
local oil_columns = require "oil.columns"
local oil_constants = require "oil.constants"

local FIELD_NAME = oil_constants.FIELD_NAME
local FIELD_TYPE = oil_constants.FIELD_TYPE
local FIELD_META = oil_constants.FIELD_META

oil_columns.register("icon_uncolored_default", {
  render = function(entry, conf)
    icon_provider = icon_provider or require("oil.util").get_icon_provider()
    if not icon_provider then
      return nil
    end

    local field_type = entry[FIELD_TYPE]
    local name = entry[FIELD_NAME]
    local meta = entry[FIELD_META]

    -- Links render as whatever they point at, same as the built-in column.
    if field_type == "link" and meta then
      if meta.link then
        name = meta.link
      end
      if meta.link_stat then
        field_type = meta.link_stat.type
      end
    end
    if meta and meta.display_name then
      name = meta.display_name
    end

    local icon = icon_provider(field_type, name, conf)

    if not conf or conf.add_padding ~= false then
      icon = icon .. " "
    end

    if name == ".." then
      return { icon, PARENT_ICON_HL }
    end
    return { icon, field_type == "directory" and DIR_ICON_HL or FILE_ICON_HL }
  end,

  parse = function(line, _conf)
    return line:match("^(%S+)%s+(.*)$")
  end,
})

oil.setup({
  default_file_explorer = true,

  -- Hidden oil buffers would otherwise be wiped after 2s, taking any pending
  -- dd with them. Keeps a cut alive while navigating to the target directory.
  cleanup_delay_ms = false,

  columns = {
    "icon_uncolored_default",
  },

  view_options = {
    show_hidden = true,
    -- Give names neutral colors independently of mini.icons' glyph colors.
    highlight_filename = function(entry, is_hidden, _is_link_target, is_link_orphan)
      -- Dotfiles stay dimmed, orphan links keep their error color.
      if is_hidden or is_link_orphan then
        return nil
      end
      return entry.type == "directory" and DEFAULT_DIR_HL or DEFAULT_FILE_HL
    end,
  },

  win_options = {
    number = false,
    relativenumber = false,
    signcolumn = "no",
    statuscolumn = "  ",
    list = false,
    cursorline = true,
    winhighlight = "CursorLine:" .. CURSOR_LINE_HL,
  },

  preview_win = {
    update_on_cursor_moved = true,
    preview_method = "fast_scratch",
    win_options = {
      -- Absolute numbers only: the cursor stays in the listing, so the global
      -- relativenumber would just count from whatever line the preview opened
      -- on. An empty statuscolumn falls back to Neovim's built-in number
      -- column; the "  " the listing uses would blank the numbers out.
      number = true,
      relativenumber = false,
      signcolumn = "no",
      statuscolumn = "",
    },
  },

  keymaps = {
    ["<CR>"] = "actions.select",

    ["<Tab>"] = "actions.select",
    ["<S-Tab>"] = "actions.parent",

    ["<C-v>"] = "actions.select_vsplit",
    ["<C-b>"] = "actions.select_split",
    ["<C-s>"] = "actions.select_split",
    ["v"] = false,
    ["V"] = false,

    ["<C-p>"] = open_oil_preview,

    -- y/p/x stay unmapped so plain Vim editing drives file moves: dd a line,
    -- navigate, p it, then :w. Oil keeps the entry's hidden id through the
    -- register, so that round trip is a move and not a delete plus create.
    -- The system-clipboard actions move to g-prefixed keys.
    ["gy"] = "actions.copy_to_system_clipboard",
    ["gp"] = "actions.paste_from_system_clipboard",
    ["gP"] = { "actions.paste_from_system_clipboard", opts = { delete_original = true } },
    ["<BS>"] = tmux_navigate("TmuxNavigateLeft"),
    ["<C-h>"] = tmux_navigate("TmuxNavigateLeft"),
    ["<C-j>"] = tmux_navigate("TmuxNavigateDown"),
    ["<C-k>"] = tmux_navigate("TmuxNavigateUp"),
    ["<C-l>"] = tmux_navigate("TmuxNavigateRight"),
    ["q"] = "actions.close",
  },
})

-- Open Oil with the preview split already up. oil.open takes the preview opts
-- itself and runs the callback once the buffer has loaded, so there's no need
-- to poll for the cursor entry.
vim.keymap.set("n", "<leader>cd", function()
  oil.open(nil, { preview = { vertical = true } }, function(err)
    if not err then
      resize_preview_split()
    end
  end)
end, {
  desc = "Open Oil with preview",
})

vim.keymap.set("n", "-", "<cmd>Oil<CR>", {
  desc = "Open parent directory",
})

-- Keep the preview split at 70% while moving around inside an Oil buffer.
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("OilAutoPreview", { clear = true }),
  pattern = "OilEnter",
  callback = function()
    vim.schedule(resize_preview_split)
  end,
})
