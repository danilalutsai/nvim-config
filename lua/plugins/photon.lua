-- Original Photon palette: https://github.com/axvr/photon.vim/blob/master/colors/photon.vim
-- Alex Vear, MIT (2019).
vim.pack.add { 'https://github.com/axvr/photon.vim' }
vim.o.termguicolors = true
vim.o.background = 'dark'

-- Edit these values to customize Photon without changing the upstream theme.
local colors = {
  background =         '#0f0f0f',
  foreground =         '#d4d4d4',
  unused =             '#909090',
  types =              '#9697a3',
  deep_background =    '#1c1c1c',
  surface =            '#303030',
  selection =          '#3a3a3a',
  search =             '#9f72d4',
  search_foreground =  '#e6f4ff',
  current_search =     '#e3905d',
  visual =             '#49384f',
  subtle =             '#444444',
  match_paren =        '#6a6a6a',
  match_paren_bg =     '#3d62a8',
  match_paren_fg =     '#ffffff',
  comment =            '#626262',
  muted =              '#767676',
  yellow =             '#ded362',
  cursor =             '#ffab70',
  red =                '#d75f5f',
  error =              '#af5f87',
  warning =            '#d7af5f',
  green =              '#84c462',
  brown =              '#a88854',
  terminal = {
    '#3a3a3a', '#d75f5f', '#84c462', '#ded362',
    '#7f9fcf', '#9f72d4', '#74b8b0', '#b2b2b2',
    '#626262', '#e27d7d', '#a3d685', '#e8de85',
    '#9cb8e0', '#b892e0', '#95ccc6', '#e6e6e6',
  },
}

-- local function apply_text_weights()
--   if vim.g.colors_name ~= 'photon' then return end

--   -- Only matching pairs are bold; MatchTagAlways reuses MatchParen for tags.
--   local bold_groups = { MatchParen = true, MatchTag = true }
--   for group, spec in pairs(vim.api.nvim_get_hl(0, {})) do
--     -- Linked groups inherit their target's color and weight.
--     if not spec.link then
--       spec.default = nil
--       spec.bold = bold_groups[group] == true
--       spec.cterm = spec.cterm or {}
--       spec.cterm.bold = spec.bold
--       vim.api.nvim_set_hl(0, group, spec)
--     end
--   end
-- end

local function apply_colors()
  local c = colors
  local highlights = {
    ['@keyword'] = { fg = c.yellow }, -- return, yield
    -- ['@function'] = { fg = c.types }, -- functions
    ['@keyword.return'] = { fg = c.yellow }, -- return
    ['@keyword.conditional'] = { fg = c.yellow }, -- switch, case
    ['@keyword.conditional.ternary.typescript'] = { fg = c.foreground }, -- switch, case
    ['@comment'] = { fg = c.brown },
    -- ['@variable.parameter'] = { fg = c.types },
    ['@string'] = { fg = c.green },
    ['@number'] = { fg = c.foreground },
    ['@boolean'] = { fg = c.foreground },
    ['@number.float'] = { fg = c.foreground },
    ['@type'] = { fg = c.foreground },
    ['@type.builtin'] = { fg = c.foreground },
    ['@type.css'] = { fg = c.yellow },
    ['@punctuation'] = { fg = c.foreground},
    ['@punctuation.special'] = { fg = c.foreground},
    ['@string.vue'] = { fg = c.foreground},
    -- Keep standalone HTML templates consistent with the HTML template blocks
    -- in Vue files. The HTML parser has language-specific captures that do
    -- not inherit these generic Vue-facing overrides.
    ['@tag.html'] = { fg = c.types },
    ['@tag.delimiter.html'] = { fg = c.types },
    ['@tag.attribute.html'] = { fg = c.yellow },
    ['@string.html'] = { fg = c.foreground },
    ['@tag.attribute'] = { fg = c.yellow},
    ['@string.regexp'] = { fg = c.types},
    ['@nospell.comment'] = { fg = c.brown},
    ['@constant.builtin'] = { fg = c.yellow},
    ['@constructor'] = { fg = c.foreground},
    ['@constructor.javascript'] = { fg = c.yellow},
    ['@constructor.typescript'] = { fg = c.yellow},
    ['@lsp.type.class'] = { fg = c.foreground},
    ['@character.special'] = { fg = c.foreground},
    ['@label.typescript'] = { fg = c.foreground},
    Normal = { fg = c.foreground, bg = c.background },
    NonText = { fg = c.subtle, bg = c.background },
    Comment = { fg = c.comment, bg = c.background },
    Conceal = { fg = c.comment, bg = c.background },
    Constant = { fg = c.yellow, bg = c.background },
    Number = { fg = c.foreground },
    Float = { fg = c.foreground },
    Identifier = { fg = c.foreground, bg = c.background },
    Statement = { fg = c.muted, bg = c.background },
    Operator = { fg = c.foreground, bg = c.background },
    PreProc = { fg = c.red, bg = c.background },
    Type = { fg = c.types, bg = c.background },
    Special = { fg = c.types },
    Error = { fg = c.error },
    Warning = { fg = c.warning },
    DiagnosticUnnecessary = { fg = c.unused },
    ModeMsg = { fg = c.muted },
    Todo = { fg = c.red },
    Underlined = { fg = c.foreground },
    StatusLine = { fg = c.yellow, bg = c.selection },
    StatusLineNC = { fg = c.muted, bg = c.surface },
    WildMenu = { fg = c.red, bg = c.surface },
    WinSeparator = { fg = c.background, bg = c.background },
    VertSplit = { fg = c.background, bg = c.background },
    Title = { fg = c.foreground },
    LineNr = { fg = c.comment },
    CursorLineNr = { fg = c.yellow, bg = c.surface },
    Cursor = { fg = c.background, bg = c.cursor },
    lCursor = { fg = c.background, bg = c.cursor },
    TermCursor = { fg = c.background, bg = c.cursor },
    CursorLine = { bg = c.surface },
    ColorColumn = { bg = c.deep_background },
    SignColumn = { fg = c.muted },
    Visual = { bg = '#454545' },
    VisualNOS = { bg = '#454545' },
    Pmenu = { bg = c.selection },
    PmenuSbar = { bg = c.surface },
    PmenuSel = { fg = c.yellow, bg = c.surface },
    PmenuThumb = { bg = c.red },
    BlinkCmpDoc = { fg = c.foreground, bg = c.selection },
    BlinkCmpDocBorder = { fg = c.foreground, bg = c.selection },
    BlinkCmpDocSeparator = { fg = c.foreground, bg = c.selection },
    BlinkCmpSignatureHelp = { fg = c.foreground, bg = c.selection },
    BlinkCmpSignatureHelpBorder = { fg = c.foreground, bg = c.selection },
    FoldColumn = { fg = c.comment },
    Folded = { fg = c.muted, bg = c.deep_background },
    SpecialKey = { fg = c.muted },
    IncSearch = { fg = c.background, bg = c.current_search },
    CurSearch = { fg = c.background, bg = c.current_search },
    Search = { fg = c.search_foreground, bg = c.search },
    Directory = { fg = c.yellow },
    MatchParen = { fg = c.match_paren_fg, bg = c.match_paren_bg },
    SpellBad = { fg = c.error },
    SpellCap = { fg = c.green },
    SpellLocal = { fg = c.warning },
    QuickFixLine = { bg = c.visual },
    DiffAdd = { fg = c.green, bg = c.surface },
    DiffChange = { bg = c.surface },
    DiffDelete = { fg = c.error, bg = c.surface },
    DiffText = { fg = c.warning, bg = c.surface },
    helpHyperTextJump = { fg = c.yellow, bg = c.background },
  }

  for group, spec in pairs(highlights) do
    -- Preserve the upstream terminal colors alongside GUI colors.
    local original = vim.api.nvim_get_hl(0, { name = group, link = false })
    spec.ctermfg = original.ctermfg
    spec.ctermbg = original.ctermbg
    spec.cterm = original.cterm
    vim.api.nvim_set_hl(0, group, spec)
  end

  -- Clear inherited decorations before applying the requested text weights.
  local decorations = {
    'bold', 'italic', 'underline', 'undercurl',
    'underdouble', 'underdotted', 'underdashed',
  }
  for group, spec in pairs(vim.api.nvim_get_hl(0, {})) do
    if not spec.link then
      local changed = false
      for _, decoration in ipairs(decorations) do
        if spec[decoration] then
          spec[decoration] = nil
          changed = true
        end
        if spec.cterm and spec.cterm[decoration] then
          spec.cterm[decoration] = nil
          changed = true
        end
      end
      if changed then
        vim.api.nvim_set_hl(0, group, spec)
      end
    end
  end

  apply_text_weights()

  for index, color in ipairs(c.terminal) do
    vim.g['terminal_color_' .. (index - 1)] = color
  end
end

-- The upstream theme supplies syntax links and Neovim's inherited highlights.
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('PhotonPalette', { clear = true }),
  pattern = 'photon',
  callback = function()
    apply_colors()
    vim.schedule(apply_text_weights)
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  group = 'PhotonPalette',
  callback = function()
    vim.defer_fn(apply_text_weights, 0)
  end,
})

vim.cmd.colorscheme 'photon'
