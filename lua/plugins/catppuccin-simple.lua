vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }

local palette = {
  base = '#1e1e2e',
  mantle = '#181825',
  crust = '#11111b',

  surface0 = '#313244',
  surface1 = '#45475a',
  surface2 = '#585b70',
  overlay0 = '#6c7086',
  overlay1 = '#7f849c',
  overlay2 = '#9399b2',

  subtext0 = '#cdd6f4',
  subtext1 = '#cdd6f4',
  text = '#cdd6f4',

  rosewater = '#f5e0dc',
  flamingo = '#f38ba8',
  pink = '#cdd6f4',
  mauve = '#cba6f7',
  red = '#f38ba8',
  maroon = '#cdd6f4',
  peach = '#fab387',
  yellow = '#f9e2af',
  green = '#a6e3a1',
  teal = '#94e2d5',
  sky = '#cdd6f4',
  sapphire = '#74c7ec',
  blue = '#89b4fa',
  lavender = '#cdd6f4',
}

require('catppuccin').setup {
  flavour = 'mocha',
  color_overrides = {
    mocha = palette,
  },
  transparent_background = true,
  no_italic = true,
  integrations = { blink_cmp = true },
  lsp_styles = {
    underlines = {
      errors = { 'undercurl' },
      warnings = { 'undercurl' },
      information = { 'undercurl' },
      hints = { 'undercurl' },
      ok = { 'undercurl' },
    },
  },
  custom_highlights = function(colors)
    local float = { bg = colors.base }
    local border = { fg = colors.surface1, bg = colors.base }
    local transparent = 'NONE'
    local tag = { fg = colors.base, bg = colors.red, style = { 'bold' } }
    local function tag_bg(bg) return { fg = colors.base, bg = bg, style = { 'bold' } } end

    return {
      Visual = { bg = colors.surface1, style = {} },
      VisualNOS = { bg = colors.surface1, style = {} },
      LineNr = { fg = colors.overlay1 },
      CursorLineNr = { fg = colors.text, style = { 'bold' } },
      Comment = { fg = colors.overlay1 },
      ['@comment'] = { fg = colors.overlay1 },
      ['@comment.todo'] = tag,
      ['@comment.error'] = tag,
      ['@comment.note'] = tag_bg(colors.green),
      ['@comment.warning'] = tag_bg(colors.yellow),
      ['@constant.comment'] = { fg = colors.mauve },
      ['@number.comment'] = { fg = colors.peach },
      Todo = tag,
      ['@tag'] = { fg = colors.text },
      ['@lsp.type.class'] = { fg = colors.yellow },
      -- ['@lsp.mod.defaultLibrary'] = { fg = colors.text },
      ['@lsp.typemod.member.defaultLibrary'] = { fg = colors.blue },
      ['@type'] = { fg = colors.text },
      ['@type.builtin'] = { fg = colors.yellow },
      ['@property.css'] = { fg = colors.text },
      ['@property.scss'] = { fg = colors.text },
      ['@variable.builtin'] = { fg = colors.red },

      -- ['@keyword.repeat'] = { fg = colors.yellow },
      -- ['@keyword.exception'] = { fg = colors.yellow },
      -- ['@keyword.conditional'] = { fg = colors.yellow },
      Underlined = { style = {} },
      markdownLinkText = { fg = colors.blue, style = {} },
      ['@string.special.url'] = { fg = colors.blue, style = {} },
      ['@markup.link.url'] = { fg = colors.blue, style = {} },
      ['@markup.underline'] = { style = {} },
      Pmenu = { fg = colors.text, bg = colors.base },
      PmenuSel = { bg = colors.surface0, style = {} },
      PmenuMatchSel = { style = {} },
      PmenuKindSel = { bg = colors.surface0, fg = colors.blue, style = {} },
      PmenuSbar = { bg = colors.base },
      PmenuThumb = { bg = colors.surface1 },

      BlinkCmpMenu = float,
      BlinkCmpMenuBorder = border,
      BlinkCmpMenuSelection = { bg = colors.surface0, style = {} },
      BlinkCmpScrollBarGutter = { bg = colors.base },
      BlinkCmpScrollBarThumb = { bg = colors.surface1 },

      BlinkCmpDoc = float,
      BlinkCmpDocBorder = border,
      BlinkCmpDocSeparator = border,

      BlinkCmpSignatureHelp = float,
      BlinkCmpSignatureHelpBorder = border,

      TelescopeNormal = { fg = colors.text, bg = transparent },
      TelescopePromptNormal = { fg = colors.text, bg = transparent },
      TelescopeResultsNormal = { fg = colors.text, bg = transparent },
      TelescopePreviewNormal = { fg = colors.text, bg = transparent },
      TelescopeBorder = { fg = colors.surface1, bg = transparent },
      TelescopePromptBorder = { fg = colors.surface1, bg = transparent },
      TelescopeResultsBorder = { fg = colors.surface1, bg = transparent },
      TelescopePreviewBorder = { fg = colors.surface1, bg = transparent },
      TelescopeTitle = { fg = colors.surface2, bg = transparent },

      -- The row under the cursor, in the results list and mirrored in the
      -- preview. surface1 rather than the surface0 these started on: the
      -- windows are transparent onto Ghostty's #0c0c12, and surface0 is only a
      -- few points off the surrounding rows, so the cursor row was hard to
      -- pick out while scrolling. surface2 is the next step up and overshoots --
      -- the row then reads as a bright band. Same value as OilCursorLine in
      -- plugins/oil.lua and QuickFixLine below, so the current row reads the
      -- same in all three lists.
      TelescopeSelection = { fg = colors.text, bg = colors.surface1, style = {} },
      TelescopeSelectionCaret = { fg = colors.green, bg = colors.surface1, style = {} },
      TelescopePreviewLine = { bg = colors.surface1 },
      -- Marked rows stay a step below the cursor row: they need to be visible
      -- at a glance, but not compete with where the cursor actually is.
      TelescopeMultiSelection = { fg = colors.text, bg = colors.surface0, style = {} },

      -- Quickfix's current entry. Catppuccin ships this as surface1 + bold; the
      -- bold re-renders the whole line in the bold face for no gain, and the
      -- background is spelled out here so it stays tied to the two groups above.
      QuickFixLine = { bg = colors.surface1, style = {} },
    }
  end,
}
-- The comment grammar makes the trailing colon optional, so nvim-treesitter's
-- bundled query lights up a bare WARN sitting in ordinary prose. Same patterns,
-- plus a predicate requiring the tag text to end in ":".
vim.treesitter.query.set(
  'comment',
  'highlights',
  [[
((tag (name) @comment.todo) @_t
  (#any-of? @comment.todo "TODO" "WIP" "ISSUE" )
  (#lua-match? @_t ":$"))

((tag (name) @comment.note) @_t
  (#any-of? @comment.note "NOTE" "XXX" "INFO" "DOCS" "PERF" "TEST" "SOLUTION")
  (#lua-match? @_t ":$"))

((tag (name) @comment.warning) @_t
  (#any-of? @comment.warning "HACK" "WARNING" "WARN" "FIX")
  (#lua-match? @_t ":$"))

((tag (name) @comment.error) @_t
  (#any-of? @comment.error "FIXME" "BUG" "ERROR")
  (#lua-match? @_t ":$"))

((tag (user) @constant.comment) @_t
  (#lua-match? @_t ":$"))
]]
)
vim.cmd.colorscheme 'catppuccin-mocha'
