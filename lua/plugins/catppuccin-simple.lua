vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }

local palette = {
  -- `transparent_background` below leaves the editor background unpainted, so
  -- what shows behind text is Ghostty's `background` in ~/.config/ghostty/config
  -- -- keep the two the same. `base` is still painted directly on floats,
  -- popups and the completion menu, which is why it is spelled out here.
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
  pink = '#f5bae5',
  mauve = '#cba6f7',
  red = '#f5bae5',
  maroon = '#cdd6f4',
  peach = '#fab387',
  yellow = '#f9e2af',
  green = '#a6e3a1',
  teal = '#94e2d5',
  sky = '#89dceb',
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
    -- Shared look for the keyword tags inside a comment.
    local tag = { fg = colors.base, bg = colors.red, style = { 'bold' } }
    local function tag_bg(bg) return { fg = colors.base, bg = bg, style = { 'bold' } } end

    return {
      Visual = { bg = colors.surface1, style = {} },
      VisualNOS = { bg = colors.surface1, style = {} },
      -- Catppuccin puts the gutter on surface1 (#45475a), which is a background
      -- shade being used as a foreground -- readable against Mocha's own base,
      -- but not against the darker ground Ghostty actually paints. overlay1 is
      -- the first shade in the palette meant to be read as text.
      --
      -- `relativenumber` is on, so this is nearly the whole gutter; the current
      -- line keeps catppuccin's bright CursorLineNr and gains bold, which is
      -- what separates it now that the rest is no longer dim by comparison.
      LineNr = { fg = colors.overlay1 },
      CursorLineNr = { fg = colors.text, style = { 'bold' } },

      Comment = { fg = colors.overlay1 },
      ['@comment'] = { fg = colors.overlay1 },

      -- Keyword tags inside comments. These come from the `comment` parser,
      -- which nvim-treesitter injects into every language's comments -- it is
      -- in the install list in treesitter.lua, and without it installed none of
      -- these four ever match. Each capture covers a fixed set of words:
      --   @comment.todo    TODO WIP
      --   @comment.note    NOTE XXX INFO DOCS PERF TEST
      --   @comment.warning HACK WARNING WARN FIX
      --   @comment.error   FIXME BUG ERROR
      -- Text is `base` so it stays readable on the colored background, and the
      -- bg is a real color rather than NONE on purpose: these are meant to
      -- punch through transparent_background.
      ['@comment.todo'] = tag,
      ['@comment.error'] = tag,
      ['@comment.note'] = tag_bg(colors.green),
      ['@comment.warning'] = tag_bg(colors.yellow),
      -- The `(name)` in `TODO(danila):` and a bare `#123` issue reference, also
      -- from the comment parser. Left without a bg so only the tag itself is a
      -- block.
      ['@constant.comment'] = { fg = colors.mauve },
      ['@number.comment'] = { fg = colors.peach },
      -- Legacy syntax fallback: filetypes with no treesitter parser installed
      -- (or with treesitter off) highlight these words via their syntax file,
      -- which links to `Todo`. Keep it looking the same.
      Todo = tag,
      ['@tag'] = { fg = colors.text },
      ['@lsp.type.class'] = { fg = colors.yellow },
      ['@lsp.mod.defaultLibrary'] = { fg = colors.text },
      ['@lsp.typemod.member.defaultLibrary'] = { fg = colors.blue },
      ['@type'] = { fg = colors.text },
      ['@type.builtin'] = { fg = colors.yellow },
      ['@property.css'] = { fg = colors.text },
      ['@property.scss'] = { fg = colors.text },
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

      TelescopeSelection = { fg = colors.text, bg = colors.surface0, style = {} },
      TelescopeSelectionCaret = { fg = colors.green, bg = colors.surface0, style = {} },
      TelescopeMultiSelection = { fg = colors.text, bg = colors.surface0, style = {} },
      TelescopePreviewLine = { bg = colors.surface0 },
    }
  end,
}

vim.cmd.colorscheme 'catppuccin-mocha'
