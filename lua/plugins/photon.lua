-- Original Photon palette: https://github.com/axvr/photon.vim/blob/master/colors/photon.vim
-- Alex Vear, MIT (2019).
vim.pack.add { 'https://github.com/axvr/photon.vim' }
vim.o.termguicolors = true
vim.o.background = 'dark'

-- Edit these values to customize Photon without changing the upstream theme.
local colors = {
  background = '#262626',
  foreground = '#c6c6c6',
  deep_background = '#1c1c1c',
  surface = '#303030',
  selection = '#3a3a3a',
  subtle = '#444444',
  comment = '#626262',
  muted = '#767676',
  purple = '#af87d7',
  red = '#d75f5f',
  error = '#af5f87',
  warning = '#d7af5f',
  green = '#87af87',
  terminal = {
    '#3a3a3a', '#ac2c2c', '#4e9a06', '#c4a000',
    '#1880bc', '#75507b', '#389aad', '#9e9e9e',
    '#444444', '#af5f87', '#87af87', '#d7af5f',
    '#369dd8', '#af87d7', '#34e2e2', '#b2b2b2',
  },
}

local function apply_colors()
  local c = colors
  local highlights = {
    Normal = { fg = c.foreground, bg = c.background },
    NonText = { fg = c.subtle, bg = c.background },
    Comment = { fg = c.comment, bg = c.background },
    Conceal = { fg = c.comment, bg = c.background },
    Constant = { fg = c.purple, bg = c.background },
    Identifier = { fg = c.foreground, bg = c.background },
    Statement = { fg = c.muted, bg = c.background },
    Operator = { fg = c.foreground, bg = c.background },
    PreProc = { fg = c.muted, bg = c.background },
    Type = { fg = c.foreground, bg = c.background },
    Special = { fg = c.muted },
    Error = { fg = c.error },
    Warning = { fg = c.warning },
    ModeMsg = { fg = c.muted },
    Todo = { fg = c.red, bold = true },
    Underlined = { fg = c.foreground, underline = true },
    StatusLine = { fg = c.purple, bg = c.selection },
    StatusLineNC = { fg = c.muted, bg = c.surface },
    WildMenu = { fg = c.red, bg = c.surface },
    VertSplit = { fg = c.surface, bg = c.surface },
    Title = { fg = c.foreground, bold = true },
    LineNr = { fg = c.comment },
    CursorLineNr = { fg = c.purple, bg = c.surface },
    Cursor = { fg = c.foreground, bg = c.purple },
    CursorLine = { bg = c.surface },
    ColorColumn = { bg = c.deep_background },
    SignColumn = { fg = c.muted },
    Visual = { bg = c.selection },
    VisualNOS = { bg = c.subtle },
    Pmenu = { bg = c.selection },
    PmenuSbar = { bg = c.surface },
    PmenuSel = { fg = c.purple, bg = c.surface },
    PmenuThumb = { bg = c.red },
    FoldColumn = { fg = c.comment },
    Folded = { fg = c.muted, bg = c.deep_background },
    SpecialKey = { fg = c.muted },
    IncSearch = { fg = c.background, bg = c.red },
    Search = { fg = c.background, bg = c.purple },
    Directory = { fg = c.purple },
    MatchParen = { fg = c.red, bold = true },
    SpellBad = { fg = c.error, underline = true },
    SpellCap = { fg = c.green, underline = true },
    SpellLocal = { fg = c.warning, underline = true },
    QuickFixLine = { bg = c.deep_background },
    DiffAdd = { fg = c.green, bg = c.surface },
    DiffChange = { bg = c.surface },
    DiffDelete = { fg = c.error, bg = c.surface },
    DiffText = { fg = c.warning, bg = c.surface },
    helpHyperTextJump = { fg = c.purple, bg = c.background },
  }

  for group, spec in pairs(highlights) do
    -- Preserve the upstream terminal colors and styles alongside GUI colors.
    local original = vim.api.nvim_get_hl(0, { name = group, link = false })
    spec.ctermfg = original.ctermfg
    spec.ctermbg = original.ctermbg
    spec.cterm = original.cterm
    vim.api.nvim_set_hl(0, group, spec)
  end

  for index, color in ipairs(c.terminal) do
    vim.g['terminal_color_' .. (index - 1)] = color
  end
end

-- The upstream theme supplies syntax links and Neovim's inherited highlights.
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('PhotonPalette', { clear = true }),
  pattern = 'photon',
  callback = apply_colors,
})

vim.cmd.colorscheme 'photon'
