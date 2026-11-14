vim.pack.add {
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-mini/mini.icons",
}

local oil = require "oil"

-- Keep filenames neutral; icons use mini.icons colors.
local colors = {
  foreground = "#c6c6c6",
  surface = "#1c1c1c",
  selection = "#3a3a3a",
  muted = "#767676",
  purple = "#cba6f7",
}

local DEFAULT_DIR_HL = "OilDefaultDir"
local DEFAULT_FILE_HL = "OilDefaultFile"

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
    vim.api.nvim_win_resize(oil_win, list_width, -1, {})
  end
end

local function open_oil_preview()
  oil.open_preview({ vertical = true }, function(err)
    if not err then
      resize_preview_split()
    end
  end)
end

-- Oil opens with the preview already up (see the keymaps and startup hook
-- below). <leader>p closes it, or brings it back. Once open it follows the
-- cursor (update_on_cursor_moved).
local function toggle_oil_preview()
  local preview_win = require("oil.util").get_preview_win()
  if preview_win then
    vim.api.nvim_win_close(preview_win, true)
    return
  end
  open_oil_preview()
end

-- Oil's own clipboard actions go through the macOS clipboard, which only
-- carries one file and rejects visual selections. This one keeps the copied
-- oil lines instead. Each line starts with the entry's hidden id ("/12 name"),
-- so pasting it into another oil buffer stages a copy, and also removing it
-- from the source buffer stages a move. Nothing touches disk until :w.
local file_clipboard = { lines = {}, source = nil }

local function entry_id(line)
  return line:match("^/(%d+)")
end

local function clipboard_copy()
  local first, last = vim.fn.line("."), vim.fn.line(".")
  local mode = vim.api.nvim_get_mode().mode
  if mode == "v" or mode == "V" or mode == "\22" then
    first, last = vim.fn.line("v"), vim.fn.line(".")
    if first > last then first, last = last, first end
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = {}
  for lnum = first, last do
    local entry = oil.get_entry_on_line(bufnr, lnum)
    local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, true)[1]
    if entry and entry.name ~= ".." and entry_id(line) then
      table.insert(lines, line)
    end
  end
  if #lines == 0 then
    vim.notify("Oil: nothing to copy here", vim.log.levels.WARN)
    return
  end

  file_clipboard = { lines = lines, source = bufnr }
  vim.notify(("Oil: copied %d %s"):format(#lines, #lines == 1 and "entry" or "entries"))
end

local function clipboard_paste(move)
  local lines = file_clipboard.lines
  if #lines == 0 then
    vim.notify("Oil: clipboard is empty, copy with gy first", vim.log.levels.WARN)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local source = file_clipboard.source
  if bufnr == source then
    vim.notify("Oil: already in the source folder, open the destination first", vim.log.levels.WARN)
    return
  end
  if move and not (source and vim.api.nvim_buf_is_loaded(source)) then
    vim.notify("Oil: source folder is no longer open, can't move", vim.log.levels.ERROR)
    return
  end

  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(bufnr, row, row, true, lines)

  if move then
    local ids = {}
    for _, line in ipairs(lines) do ids[entry_id(line)] = true end
    local source_lines = vim.api.nvim_buf_get_lines(source, 0, -1, true)
    for i = #source_lines, 1, -1 do
      if ids[entry_id(source_lines[i]) or ""] then
        vim.api.nvim_buf_set_lines(source, i - 1, i, true, {})
      end
    end
    -- The originals are gone from the source; pasting them again would copy.
    file_clipboard = { lines = {}, source = nil }
  end

  vim.notify(("Oil: %s %d %s staged, :w to apply"):format(
    move and "move of" or "copy of", #lines, #lines == 1 and "entry" or "entries"))
end

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
    "icon",
  },

  view_options = {
    show_hidden = true,
    -- macOS protects ~/.Trash; keep Oil's automatic preview out of it.
    is_always_hidden = function(name, bufnr)
      if name ~= ".Trash" or vim.fn.has("macunix") ~= 1 then
        return false
      end
      local dir = oil.get_current_dir(bufnr)
      local home_dir = vim.fn.expand("~"):gsub("/+$", "")
      return dir ~= nil and dir:gsub("/+$", "") == home_dir
    end,
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

    ["<leader>p"] = { callback = toggle_oil_preview, desc = "Toggle preview" },
    -- Oil's default preview key; drop it so the global <C-p> (previous search
    -- result) works in Oil too.
    ["<C-p>"] = false,

    -- y/p/x stay unmapped so plain Vim editing drives file moves: dd a line,
    -- navigate, p it, then :w. Oil keeps the entry's hidden id through the
    -- register, so that round trip is a move and not a delete plus create.
    -- gy/gp/gP: oil's own file clipboard (see clipboard_copy above). Works on
    -- a visual selection: gy, go to the destination, gp copies, gP moves.
    ["gy"] = { callback = clipboard_copy, mode = { "n", "x" }, desc = "Copy entries" },
    ["gp"] = { callback = function() clipboard_paste(false) end, desc = "Paste copied entries" },
    ["gP"] = { callback = function() clipboard_paste(true) end, desc = "Move copied entries here" },
    -- macOS clipboard, for Finder and other apps (one file at a time).
    -- Paste is on v (as in Cmd+V) because <leader>p toggles the preview.
    ["<leader>y"] = "actions.copy_to_system_clipboard",
    ["<leader>v"] = "actions.paste_from_system_clipboard",
    ["<leader>V"] = { "actions.paste_from_system_clipboard", opts = { delete_original = true } },
    -- Oil maps these by default; let the global vim/HerdR navigation handle them.
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["q"] = "actions.close",
  },
})

-- Open Oil with the preview split already up. oil.open takes the preview opts
-- itself and runs the callback once the buffer has loaded, so there's no need
-- to poll for the cursor entry.
local function open_oil_with_preview()
  oil.open(nil, { preview = { vertical = true } }, function(err)
    if not err then
      resize_preview_split()
    end
  end)
end

vim.keymap.set("n", "<leader>c", open_oil_with_preview, {
  desc = "Open Oil with preview",
})

vim.keymap.set("n", "-", open_oil_with_preview, {
  desc = "Open parent directory with preview",
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

-- `nvim .` (or any single directory argument) lands in Oil through
-- default_file_explorer. Open the preview for that first listing too.
-- oil.setup above has already rewritten a directory argument to an oil:// URL
-- by the time this runs.
local startup_arg = vim.fn.argc() == 1 and vim.fn.argv(0) or ""
if startup_arg:match("^oil://") or vim.fn.isdirectory(startup_arg) == 1 then
  vim.api.nvim_create_autocmd("VimEnter", {
    group = "OilAutoPreview",
    once = true,
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      if vim.bo[bufnr].filetype ~= "oil" then
        return
      end
      -- Waits for the listing to render, or runs now if it already has.
      require("oil.util").run_after_load(bufnr, open_oil_preview)
    end,
  })
end
