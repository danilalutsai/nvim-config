vim.pack.add {
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-mini/mini.icons",
}

local oil = require "oil"

-- Resolved lazily on first render: mini.icons must finish setup first.
local icon_provider

-- Keep the listing neutral; use purple for the parent icon and confirmation border.
local colors = {
  foreground = "#c6c6c6",
  surface = "#303030",
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
local CONFIRM_NORMAL_HL = "OilConfirmNormal"
local CONFIRM_BORDER_HL = "OilConfirmBorder"

local function set_oil_highlights()
  vim.api.nvim_set_hl(0, DEFAULT_DIR_HL, { fg = colors.muted })
  vim.api.nvim_set_hl(0, DEFAULT_FILE_HL, { fg = colors.foreground })
  vim.api.nvim_set_hl(0, DIR_ICON_HL, { fg = colors.muted })
  vim.api.nvim_set_hl(0, FILE_ICON_HL, { fg = colors.comment })
  vim.api.nvim_set_hl(0, PARENT_ICON_HL, { fg = colors.purple })
  vim.api.nvim_set_hl(0, CURSOR_LINE_HL, { bg = colors.selection })
  vim.api.nvim_set_hl(0, CONFIRM_NORMAL_HL, { fg = colors.foreground, bg = colors.surface })
  vim.api.nvim_set_hl(0, CONFIRM_BORDER_HL, { fg = colors.purple, bg = colors.surface })
end

set_oil_highlights()

-- A colorscheme load wipes custom groups, so re-register on every switch.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("OilDefaultDirHl", { clear = true }),
  callback = set_oil_highlights,
})

local FILE_LIST_WIDTH = 36

local function resize_preview_split()
  local preview_win = require("oil.util").get_preview_win()

  if not preview_win or not vim.api.nvim_win_is_valid(preview_win) then
    return
  end

  local oil_win = vim.w[preview_win].oil_source_win or vim.api.nvim_get_current_win()
  if not vim.api.nvim_win_is_valid(oil_win)
    or vim.bo[vim.api.nvim_win_get_buf(oil_win)].filetype ~= "oil"
    or vim.api.nvim_win_get_config(oil_win).relative ~= ""
    or vim.api.nvim_win_get_config(preview_win).relative ~= ""
    or vim.api.nvim_win_get_position(oil_win)[2] == vim.api.nvim_win_get_position(preview_win)[2]
  then
    return
  end

  local total_width = vim.api.nvim_win_get_width(oil_win) + vim.api.nvim_win_get_width(preview_win)
  -- Leave room for the preview when the terminal is unusually narrow.
  local list_width = math.max(1, math.min(FILE_LIST_WIDTH, total_width - 20))
  if vim.api.nvim_win_get_width(oil_win) ~= list_width then
    vim.api.nvim_win_set_width(oil_win, list_width)
  end
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

  -- Review the full list of pending filesystem changes on every save.
  skip_confirm_for_simple_edits = false,

  confirmation = {
    border = "rounded",
    win_options = {
      winblend = 0,
      winhighlight = "Normal:" .. CONFIRM_NORMAL_HL
        .. ",NormalFloat:" .. CONFIRM_NORMAL_HL
        .. ",FloatBorder:" .. CONFIRM_BORDER_HL,
    },
  },

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

    -- Stage a deletion; Oil applies it only after :w and confirmation.
    ["D"] = { '"_dd', mode = "n", desc = "Stage file deletion" },

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
    -- Oil maps these by default; let the global vim/HerdR navigation handle them.
    ["<C-h>"] = false,
    ["<C-l>"] = false,
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

-- Keep the file list width stable when navigating or resizing the terminal.
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("OilAutoPreview", { clear = true }),
  pattern = "OilEnter",
  callback = function()
    vim.schedule(resize_preview_split)
  end,
})

vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
  group = "OilAutoPreview",
  callback = function()
    vim.schedule(resize_preview_split)
  end,
})
