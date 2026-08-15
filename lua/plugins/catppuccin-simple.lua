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
  sapphire = '#f38ba8',
  blue = '#f9e2af',
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

    return {
      Visual = { bg = colors.surface1, style = {} },
      VisualNOS = { bg = colors.surface1, style = {} },
      Comment = { fg = colors.overlay1 },
      ['@comment'] = { fg = colors.overlay1 },
      ['@tag'] = { fg = colors.text },
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
