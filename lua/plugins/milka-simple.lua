vim.pack.add { 'https://github.com/axvr/photon.vim' }
vim.o.termguicolors = true

-- Photon defaults. Edit these values to recolor the matching groups below.
local colors = {
  white = '#cecfd6',
  background = '#262626',
  foreground = '#a39f9d',
  bracket = '#767676',
  deep_background = '#1c1c1c',
  surface = '#303030',
  selection = '#3a3a3a',
  subtle = '#444444',
  comment = '#626262',
  muted = '#767676',
  string = '#9c9c9c',
  purple = '#cba6f7', -- Photon default: #af87d7
  red = '#f38ba8',
  error = '#f38ba8',
  warning = '#d7af5f',
  green = '#87af87',

  -- Neovim terminal ANSI colors, indices 0 through 15.
  terminal = {
    '#3a3a3a', '#ac2c2c', '#4e9a06', '#c4a000',
    '#1880bc', '#75507b', '#389aad', '#9e9e9e',
    '#444444', '#af5f87', '#87af87', '#d7af5f',
    '#369dd8', '#cba6f7', '#34e2e2', '#b2b2b2',
  },
}

local underline_styles = { 'underline', 'undercurl', 'underdouble', 'underdotted', 'underdashed' }

local function remove_underlines()
  if vim.g.colors_name ~= 'photon' then return end

  for _, group in ipairs(vim.fn.getcompletion('', 'highlight')) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    local changed = false

    for _, style in ipairs(underline_styles) do
      if hl[style] or (hl.cterm and hl.cterm[style]) then
        hl[style] = false
        if hl.cterm then hl.cterm[style] = nil end
        changed = true
      end
    end

    if changed then
      hl.default = nil
      vim.api.nvim_set_hl(0, group, vim.tbl_extend('force', {}, hl))
    end
  end
end

local function apply_colors()
  if vim.g.colors_name ~= 'photon' then return end

  local c = colors
  local highlights = {
    Normal = { fg = c.foreground, bg = 'NONE' },
    NormalNC = { fg = c.foreground, bg = 'NONE' },
    NormalFloat = { fg = c.foreground, bg = c.background },
    FloatBorder = { fg = c.muted, bg = c.background },
    FloatTitle = { fg = c.foreground, bg = c.background },
    FloatFooter = { fg = c.muted, bg = c.background },
    NonText = { fg = c.subtle },
    Comment = { fg = c.comment },
    ['@string.special.url.comment'] = { link = 'Comment' },
    Conceal = { fg = c.comment },
    Constant = { fg = c.purple },
    Identifier = { fg = c.foreground },
    Statement = { fg = c.muted },
    Operator = { fg = c.foreground },
    PreProc = { fg = c.muted },
    Type = { fg = c.foreground },
    Special = { fg = c.muted },
    Delimiter = { fg = c.bracket },
    ['@punctuation.delimiter'] = { fg = c.foreground },
    ['@punctuation.bracket'] = { fg = c.bracket },
    ['@tag.delimiter'] = { fg = c.bracket },
    ['@type.builtin'] = { fg = c.bracket },
    ['@type.milka_error'] = { fg = c.purple },
    ['@constant.builtin'] = { fg = c.purple }, -- undefined, null
    ['@boolean'] = { fg = c.purple },          -- true, false
    ['@keyword.return'] = { fg = c.purple }, -- return, yield
    ['@constructor.javascript'] = { fg = c.purple },
    ['@constructor.typescript'] = { fg = c.purple },
    ['@variable.milka_console'] = { fg = c.white },
      Number = { fg = c.purple },
      Float = { fg = c.purple },
    ['@number'] = { fg = c.purple },         -- numeric literals
    ['@number.float'] = { fg = c.purple },
    ['@string'] = { fg = c.purple },
    ['@booleaboolean'] = { fg = c.purple },
    rustBracket = { fg = c.bracket },
    -- Error ranges must preserve the code's syntax colors.
    Error = {},
    ErrorMsg = { fg = c.red },
    ['@error'] = {},
    DiagnosticError = { fg = c.red },
    DiagnosticSignError = { fg = c.red },
    DiagnosticVirtualTextError = { fg = c.red },
    DiagnosticVirtualLinesError = { fg = c.red },
    DiagnosticFloatingError = { fg = c.red },
    DiagnosticUnderlineError = {},
    Warning = { fg = c.warning },
    ModeMsg = { fg = c.muted },
    Todo = { fg = c.red, bold = true },
    Underlined = { fg = c.foreground },
    StatusLine = { fg = c.purple, bg = c.selection },
    StatusLineNC = { fg = c.muted, bg = c.surface },
    WildMenu = { fg = c.red, bg = c.surface },
    WinSeparator = { fg = c.surface, bg = 'NONE' },
    VertSplit = { fg = c.surface, bg = 'NONE' },
    Title = { fg = c.foreground, bold = true },
    LineNr = { fg = c.comment },
    CursorLineNr = { fg = c.purple, bg = c.surface },
    Cursor = { fg = c.foreground, bg = c.purple },
    CursorLine = { bg = c.surface },
    ColorColumn = { bg = '#37353b' },
    SignColumn = { fg = c.muted },
    Visual = { fg =  c.deep_background, bg = c.purple, },
    VisualNOS = { bg = c.subtle },
    Pmenu = { bg = c.selection },
    PmenuSbar = { bg = c.surface },
    PmenuSel = { fg = c.purple, bg = c.surface },
    PmenuThumb = { bg = c.red },
    TelescopeNormal = { fg = c.foreground, bg = c.background },
    TelescopePromptNormal = { fg = c.foreground, bg = c.background },
    TelescopeResultsNormal = { fg = c.foreground, bg = c.background },
    TelescopePreviewNormal = { fg = c.foreground, bg = c.background },
    TelescopeBorder = { fg = c.comment, bg = c.background },
    TelescopePromptBorder = { fg = c.comment, bg = c.background },
    TelescopeResultsBorder = { fg = c.comment, bg = c.background },
    TelescopePreviewBorder = { fg = c.comment, bg = c.background },
    FoldColumn = { fg = c.comment },
    Folded = { fg = c.muted, bg = c.deep_background },
    SpecialKey = { fg = c.muted },
    IncSearch = { fg = c.background, bg = c.red },
    Search = { fg = c.background, bg = c.purple },
    Directory = { fg = c.purple },
    MatchParen = { fg = c.red, bold = true },
    SpellBad = { fg = c.error },
    SpellCap = { fg = c.green },
    SpellLocal = { fg = c.warning },
    QuickFixLine = { bg = c.deep_background },
    DiffAdd = { fg = c.green, bg = c.surface },
    DiffChange = { bg = c.surface },
    DiffDelete = { fg = c.error, bg = c.surface },
    DiffText = { fg = c.warning, bg = c.surface },
    helpHyperTextJump = { fg = c.green },
  }

  for group, spec in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  for index, color in ipairs(c.terminal) do
    vim.g['terminal_color_' .. index - 1] = color
  end

  remove_underlines()
end

vim.cmd.colorscheme 'photon'
apply_colors()

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'photon',
  callback = function()
    apply_colors()
    vim.schedule(remove_underlines)
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.schedule(remove_underlines)
  end,
})

-- Vim's Rust syntax owns some delimiters (for example derive(...) and strings),
-- so a window-local match keeps every Rust bracket at the same foreground.
local function update_rust_brackets()
  local match_id = vim.w.milka_rust_brackets
  if match_id then
    pcall(vim.fn.matchdelete, match_id)
    vim.w.milka_rust_brackets = nil
  end

  if vim.bo.filetype == 'rust' then
    vim.w.milka_rust_brackets = vim.fn.matchadd('rustBracket', '[\\[\\]{}()]', 20)
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'FileType' }, {
  group = vim.api.nvim_create_augroup('MilkaRustBrackets', { clear = true }),
  callback = update_rust_brackets,
})
