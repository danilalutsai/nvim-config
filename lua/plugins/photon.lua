vim.pack.add { 'https://github.com/axvr/photon.vim' }
vim.o.termguicolors = true
vim.o.background = 'dark'

-- Edit these values to customize Photon without changing the upstream theme.
local colors = {
  background =         '#0f0f0f',
  foreground =         '#d4d4d4',
  unused =             '#909090',
  types =              '#8f8f8f',
  deep_background =    '#1c1c1c',
  surface =            '#303030',
  selection =          '#3a3a3a',
  search =             '#9f72d4',
  search_foreground =  '#e6f4ff',
  current_search =     '#e3905d',
  visual =             '#49384f',
  subtle =             '#444444',
  match_paren =        '#6a6a6a',
  match_paren_bg =     '#0f0f0f',
  match_paren_fg =     '#d75f5f',
  comment =            '#626262',
  muted =              '#767676',
  yellow =             '#ded362',
  cursor =             '#ffab70',
  red =                '#d75f5f',
  error =              '#af5f87',
  warning =            '#d7af5f',
  green =              '#84c462',
  brown =              '#a88854',

  -- Diff lines: regular foreground text on a dark green/red tint. diffview.lua
  -- sets the same values, so the result no longer depends on which file
  -- applies its colors last.
  diff_add =           '#022800',
  diff_delete =        '#3d0101',
}

-- :terminal takes its 16 ANSI colors from the Ghostty config, so terminal
-- colors are set in one place: the `palette = N=#rrggbb` lines there.
local function ghostty_palette()
  local config_home = vim.env.XDG_CONFIG_HOME or vim.fn.expand('~/.config')
  local path = config_home .. '/ghostty/config'
  local palette = {}
  if vim.fn.filereadable(path) == 0 then return palette end

  for _, line in ipairs(vim.fn.readfile(path)) do
    local index, color = line:match('^%s*palette%s*=%s*(%d+)%s*=%s*(#%x%x%x%x%x%x)')
    if index and tonumber(index) <= 15 then
      palette[tonumber(index)] = color
    end
  end
  return palette
end

local function apply_text_weights()
  if vim.g.colors_name ~= 'photon' then return end

  -- Only matching pairs are bold; vim-matchup's MatchWord links to MatchParen.
  local bold_groups = { MatchParen = true }
  for group, spec in pairs(vim.api.nvim_get_hl(0, {})) do
    -- Linked groups inherit their target's color and weight.
    if not spec.link then
      spec.default = nil
      spec.bold = bold_groups[group] == true
      spec.cterm = spec.cterm or {}
      spec.cterm.bold = spec.bold
      vim.api.nvim_set_hl(0, group, spec)
    end
  end
end

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
    -- Markdown: headings yellow, text white, syntax markers gray.
    ['@markup.heading'] = { fg = c.yellow },
    ['@markup.strong'] = { fg = c.foreground },
    ['@markup.italic'] = { fg = c.foreground },
    ['@markup.strikethrough'] = { fg = c.types },
    ['@markup.raw'] = { fg = c.types },
    ['@markup.raw.markdown_inline'] = { fg = c.green }, -- `inline code`
    ['@markup.raw.block'] = { fg = c.types },
    ['@markup.link'] = { fg = c.foreground },
    ['@markup.link.label'] = { fg = c.foreground },
    ['@markup.link.url'] = { fg = c.types },
    ['@markup.list'] = { fg = c.types },
    ['@markup.list.checked'] = { fg = c.foreground },
    ['@markup.list.unchecked'] = { fg = c.types },
    ['@markup.quote'] = { fg = c.types },
    ['@label.markdown'] = { fg = c.types }, -- code fence language
    ['@punctuation.special.markdown'] = { fg = c.types },
    ['@punctuation.delimiter.markdown'] = { fg = c.types },
    ['@punctuation.delimiter.markdown_inline'] = { fg = c.types },
    ['@string.escape.markdown_inline'] = { fg = c.types },
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
    Pmenu = { bg = c.deep_background },
    PmenuSbar = { bg = c.surface },
    PmenuSel = { fg = c.yellow, bg = c.surface },
    PmenuThumb = { bg = c.red },
    BlinkCmpDoc = { fg = c.foreground, bg = c.deep_background },
    BlinkCmpDocBorder = { fg = c.foreground, bg = c.deep_background },
    BlinkCmpDocSeparator = { fg = c.foreground, bg = c.deep_background },
    BlinkCmpSignatureHelp = { fg = c.foreground, bg = c.deep_background },
    BlinkCmpSignatureHelpBorder = { fg = c.foreground, bg = c.deep_background },
    TelescopeSelection = { bg = c.surface },
    TelescopeSelectionCaret = { fg = c.yellow, bg = c.surface },
    TelescopePreviewLine = { bg = c.surface },
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
    DiffAdd = { fg = c.foreground, bg = c.diff_add },
    -- Changed lines keep their syntax colors; only the changed text is tinted.
    DiffChange = {},
    DiffDelete = { fg = c.foreground, bg = c.diff_delete },
    DiffText = { fg = c.foreground, bg = c.diff_add },
    diffAdded = { fg = c.foreground, bg = c.diff_add },
    diffRemoved = { fg = c.foreground, bg = c.diff_delete },
    DiffviewDiffAddAsDelete = { fg = c.foreground, bg = c.diff_delete },
    helpHyperTextJump = { fg = c.yellow, bg = c.background },
    -- Neovim's built-in Info, Hint and Changed groups are cyan and light blue.
    -- Diagnostics, gitsigns, Oil, diffs and mini.icons all link to them.
    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.yellow },
    DiagnosticInfo = { fg = c.brown },
    DiagnosticHint = { fg = c.brown },
    DiagnosticOk = { fg = c.green },
    DiagnosticUnderlineError = { sp = c.red },
    DiagnosticUnderlineWarn = { sp = c.yellow },
    DiagnosticUnderlineInfo = { sp = c.brown },
    DiagnosticUnderlineHint = { sp = c.brown },
    DiagnosticUnderlineOk = { sp = c.green },
    Added = { fg = c.foreground, bg = c.diff_add },
    Changed = { fg = c.yellow },
    Removed = { fg = c.foreground, bg = c.diff_delete },
    -- File and folder icons in Oil, Telescope and blink.
    MiniIconsAzure = { fg = c.foreground },
    MiniIconsBlue = { fg = c.foreground },
    MiniIconsCyan = { fg = c.foreground },
    MiniIconsGreen = { fg = c.green },
    MiniIconsOrange = { fg = c.brown },
    MiniIconsPurple = { fg = c.yellow },
    MiniIconsRed = { fg = c.red },
    MiniIconsYellow = { fg = c.yellow },
    OilCreate = { fg = c.green },
    OilCopy = { fg = c.green },
    OilRestore = { fg = c.green },
    -- gitsigns derives these from Changed before this theme loads.
    GitSignsStagedChange = { fg = c.brown },
    GitSignsStagedChangeCul = { fg = c.brown },
    GitSignsStagedChangeNr = { fg = c.brown },
    GitSignsStagedChangedelete = { fg = c.brown },
    GitSignsStagedChangedeleteCul = { fg = c.brown },
    GitSignsStagedChangedeleteNr = { fg = c.brown },
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

  -- Replace upstream photon's terminal colors with Ghostty's. A color missing
  -- from the Ghostty config falls back to Neovim's default for that slot.
  local palette = ghostty_palette()
  for index = 0, 15 do
    vim.g['terminal_color_' .. index] = palette[index]
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
