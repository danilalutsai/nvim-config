vim.pack.add { 'https://github.com/axvr/photon.vim' }

-- Photon is the dark scheme; Antiphoton is the light one. Edit these hex
-- values to recolor the groups below, then restart or run :colorscheme photon.
local palette = {
  background = '#262626',     -- editor background
  foreground = '#c6c6c6',     -- normal text, identifiers, operators, types
  deep_background = '#1c1c1c', -- folds, color column, quickfix line
  surface = '#303030',        -- cursor line, separators, menus, diff background
  selection = '#3a3a3a',      -- visual selection, active status line
  subtle = '#444444',         -- non-text, inactive visual selection
  comment = '#626262',        -- comments, line numbers
  muted = '#767676',          -- statements, preprocessors, secondary text
  purple = '#cba6f7',         -- constants, search, directory, active line
  red = '#d75f5f',            -- TODO, matching paren, incremental search
  error = '#af5f87',          -- errors, deleted diff, spelling errors
  warning = '#d7af5f',        -- warnings and changed diff text
  green = '#87af87',          -- added diff, capitalized spelling

  -- Neovim terminal ANSI colors (indices 0–15).
  terminal = {
    '#3a3a3a', '#ac2c2c', '#4e9a06', '#c4a000',
    '#1880bc', '#75507b', '#389aad', '#9e9e9e',
    '#444444', '#af5f87', '#87af87', '#d7af5f',
    '#369dd8', '#af87d7', '#34e2e2', '#b2b2b2',
  },
}

local function remove_text_styles()
  for _, group in ipairs(vim.fn.getcompletion('', 'highlight')) do
    local definition = vim.api.nvim_get_hl(0, { name = group, link = true })
    if not definition.link then
      local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
      local error_underline = group == 'DiagnosticUnderlineError' or group == 'SpellBad'
      local has_underline = hl.underline or hl.undercurl or hl.underdouble or hl.underdotted or hl.underdashed

      if hl.italic or (has_underline and not error_underline) then
        local cterm = vim.deepcopy(hl.cterm or {})
        cterm.italic = nil
        hl.italic = false

        if not error_underline then
          for _, style in ipairs({ 'underline', 'undercurl', 'underdouble', 'underdotted', 'underdashed' }) do
            hl[style] = false
            cterm[style] = nil
          end
        end

        hl.cterm = cterm
        hl.default = nil
        vim.api.nvim_set_hl(0, group, hl)
      end
    end
  end
end

local function apply_palette()
  if vim.g.colors_name ~= 'photon' then return end
  local p = palette

  -- The upstream Vimscript scheme defines these groups. Keeping their colors
  -- here makes every part of Photon editable without changing installed files.
  local highlights = {
    Normal = { fg = p.foreground, bg = p.background },
    NonText = { fg = p.subtle, bg = p.background },
    Comment = { fg = p.comment, bg = p.background },
    Conceal = { fg = p.comment, bg = p.background },
    Constant = { fg = p.purple, bg = p.background },
    Identifier = { fg = p.foreground, bg = p.background },
    Statement = { fg = p.muted, bg = p.background },
    Operator = { fg = p.foreground, bg = p.background },
    PreProc = { fg = p.muted, bg = p.background },
    Type = { fg = p.foreground, bg = p.background },
    Special = { fg = p.muted },
    Error = { fg = p.error },
    Warning = { fg = p.warning },
    ModeMsg = { fg = p.muted },
    Todo = { fg = p.red, bold = true },
    Underlined = { fg = p.foreground },
    StatusLine = { fg = p.purple, bg = p.selection },
    StatusLineNC = { fg = p.muted, bg = p.surface },
    WildMenu = { fg = p.red, bg = p.surface },
    VertSplit = { fg = p.surface, bg = p.surface },
    Title = { fg = p.foreground, bold = true },
    LineNr = { fg = p.comment },
    CursorLineNr = { fg = p.purple, bg = p.surface },
    Cursor = { fg = p.foreground, bg = p.purple },
    CursorLine = { bg = p.surface },
    ColorColumn = { bg = p.deep_background },
    SignColumn = { fg = p.muted },
    Visual = { bg = p.selection },
    VisualNOS = { bg = p.subtle },
    Pmenu = { bg = p.selection },
    PmenuSbar = { bg = p.surface },
    PmenuSel = { fg = p.purple, bg = p.surface },
    PmenuThumb = { bg = p.red },
    FoldColumn = { fg = p.comment },
    Folded = { fg = p.muted, bg = p.deep_background },
    SpecialKey = { fg = p.muted },
    IncSearch = { fg = p.background, bg = p.red },
    Search = { fg = p.background, bg = p.purple },
    Directory = { fg = p.purple },
    MatchParen = { fg = p.red, bold = true },
    SpellBad = { fg = p.error, underline = true, sp = p.error },
    SpellCap = { fg = p.green },
    SpellLocal = { fg = p.warning },
    QuickFixLine = { bg = p.deep_background },
    DiffAdd = { fg = p.green, bg = p.surface },
    DiffChange = { bg = p.surface },
    DiffDelete = { fg = p.error, bg = p.surface },
    DiffText = { fg = p.warning, bg = p.surface },
    helpHyperTextJump = { fg = p.purple, bg = p.background },

    -- Neovim groups not covered by the original Vimscript theme.
    WinSeparator = { link = 'VertSplit' },
    NormalFloat = { fg = p.foreground, bg = p.background },
    FloatBorder = { fg = p.comment, bg = p.background },
    FloatTitle = { fg = p.purple, bg = p.background },
    DiagnosticError = { fg = p.error },
    DiagnosticWarn = { fg = p.warning },
    DiagnosticInfo = { fg = p.purple },
    DiagnosticHint = { fg = p.muted },
    DiagnosticOk = { fg = p.green },
    DiagnosticUnderlineError = { undercurl = true, sp = p.error },
    DiagnosticUnderlineWarn = {},
    DiagnosticUnderlineInfo = {},
    DiagnosticUnderlineHint = {},
    DiagnosticUnderlineOk = {},
  }

  for group, spec in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  local links = {
    Character = 'Constant', Number = 'Constant', Float = 'Number',
    Boolean = 'Constant', String = 'Constant', Function = 'Identifier',
    Conditional = 'Statement', Repeat = 'Statement', Label = 'Statement',
    Keyword = 'Statement', Exception = 'Statement', Include = 'PreProc',
    Define = 'PreProc', Macro = 'PreProc', PreCondit = 'PreProc',
    StorageClass = 'Type', Structure = 'Type', Typedef = 'Type',
    SpecialChar = 'Special', Tag = 'Special', Delimiter = 'Special',
    SpecialComment = 'Special', Debug = 'Special', ErrorMsg = 'Error',
    WarningMsg = 'Warning', MoreMsg = 'ModeMsg', Question = 'ModeMsg',
    Ignore = 'NonText', StatusLineTerm = 'StatusLine',
    StatusLineTermNC = 'StatusLineNC', TabLine = 'StatusLineNC',
    TabLineFill = 'StatusLineNC', TabLineSel = 'StatusLine',
    CursorColumn = 'CursorLine', SpellRare = 'SpellLocal',
    diffAdded = 'DiffAdd', diffRemoved = 'DiffDelete',
    htmlTag = 'htmlTagName', htmlEndTag = 'htmlTag',
    gitcommitSummary = 'Title',
    DiagnosticSignError = 'DiagnosticError',
    DiagnosticSignWarn = 'DiagnosticWarn',
    DiagnosticSignInfo = 'DiagnosticInfo',
    DiagnosticSignHint = 'DiagnosticHint',
  }

  for group, target in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = target })
  end

  for index, color in ipairs(p.terminal) do
    vim.g['terminal_color_' .. (index - 1)] = color
  end

  remove_text_styles()
end

vim.o.termguicolors = true
vim.o.background = 'dark'
vim.cmd.colorscheme 'photon'
apply_palette()

-- Other plugins can add highlight groups during startup. Register the reload
-- handler at VimEnter so it also runs after their ColorScheme handlers.
local palette_group = vim.api.nvim_create_augroup('PhotonPalette', { clear = true })
local function register_reload_handler()
  vim.api.nvim_clear_autocmds({ group = palette_group, event = 'ColorScheme' })
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = palette_group,
    pattern = 'photon',
    callback = apply_palette,
  })
end

register_reload_handler()
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    apply_palette()
    register_reload_handler()
  end,
})

return { palette = palette, apply = apply_palette }
