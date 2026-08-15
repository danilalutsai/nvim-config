
-- Repo dir is named `nvim`, so name it explicitly to keep the pack entry and the
-- `require` below matching.
vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }

-- The full Mocha palette, verbatim from the plugin's own palettes/mocha.lua.
-- Edit any hex here and it propagates everywhere: `color_overrides` below feeds
-- it back into the flavour, so the theme's own groups, every integration, and
-- the `colors` argument to `custom_highlights` all rebuild from these values.
--
-- These 26 names are the whole vocabulary — catppuccin has no others, and a key
-- that is not in this list is silently ignored rather than reported.
--
-- Shared with ~/.config/ghostty/config, the @ctp_* options in
-- ~/.config/tmux/tmux.conf and the palette table in ~/.config/starship.toml.
-- Those three are separate copies, so a change here is not picked up by them.
local palette = {
  -- Backgrounds, darkest last. `base` is the editor background, but
  -- transparent_background below leaves it unpainted, so on screen it is
  -- Ghostty's `background = #0c0c12` that shows instead.
  base = '#1e1e2e',
  mantle = '#181825',
  crust = '#11111b',

  -- Greys, lightest last. surface* are backgrounds (visual selection, the
  -- selected completion row); overlay* are foregrounds (comments, borders).
  surface0 = '#313244',
  surface1 = '#45475a',
  surface2 = '#585b70',
  overlay0 = '#6c7086',
  overlay1 = '#7f849c',
  overlay2 = '#9399b2',

  -- Foregrounds. `text` is ordinary code; subtext* are the dimmer two steps.
  subtext0 = '#a6adc8',
  subtext1 = '#cdd6f4',
  text = '#cdd6f4',

  -- Accents. These carry the syntax highlighting and the diagnostic severities:
  -- red = error, yellow = warn, sky = info, teal = hint, green = ok.
  rosewater = '#f5e0dc',
  flamingo = '#f2cdcd',
  pink = '#f5c2e7',
  mauve = '#cba6f7',
  red = '#f38ba8',
  maroon = '#eba0ac',
  peach = '#fab387',
  yellow = '#f9e2af',
  green = '#a6e3a1',
  teal = '#94e2d5',
  sky = '#89dceb',
  sapphire = '#74c7ec',
  blue = '#89b4fa',
  lavender = '#b4befe',
}

require('catppuccin').setup {
  flavour = 'mocha',
  -- Keyed by flavour, so only `mocha` is overridden — the other three keep
  -- their upstream values, which matters if `flavour` above ever changes.
  color_overrides = {
    mocha = palette,
  },
  -- Terminal already draws the background, so panes stay transparent instead of
  -- painting a bg.
  transparent_background = true,
  no_italic = true,
  integrations = { blink_cmp = true },
  -- Wavy underline under diagnostics instead of catppuccin's flat `underline`,
  -- which is hard to tell apart from a real underline in the text. The color is
  -- the severity color via `sp`, which catppuccin already sets.
  --
  -- Needs the terminal to support the Smulx capability. Ghostty's own
  -- xterm-ghostty terminfo has it, but tmux-256color does not, so inside tmux
  -- this renders flat unless the Smulx/Setulc overrides in
  -- ~/.config/tmux/tmux.conf are in place.
  lsp_styles = {
    underlines = {
      errors = { 'undercurl' },
      warnings = { 'undercurl' },
      information = { 'undercurl' },
      hints = { 'undercurl' },
      ok = { 'undercurl' },
    },
  },
  -- Completion popups opt out of the transparency above: text scrolling behind a
  -- floating menu makes it unreadable. Runs after the integrations, so these win
  -- over the transparent Pmenu/BlinkCmp* the integration would otherwise set.
  custom_highlights = function(colors)
    local float = { bg = colors.base }
    local border = { fg = colors.surface1, bg = colors.base }
    -- Literal rather than colors.none: `none` is attached to the palette by
    -- catppuccin's own mapper, not by the flavour table, so it is not guaranteed
    -- to be present on the table handed to this function.
    local transparent = 'NONE'

    return {
      -- Catppuccin ships Visual/VisualNOS as `style = { "bold" }`, so a visual
      -- selection re-renders every glyph in the bold face. Background alone
      -- marks the selection.
      Visual = { bg = colors.surface1, style = {} },
      VisualNOS = { bg = colors.surface1, style = {} },

      -- Catppuccin puts comments on overlay2 (#9399b2), only a little below the
      -- #cdd6f4 of ordinary text, so they read as loud as code. surface2 drops
      -- them well under it. @comment is spelled out because treesitter's default
      -- link to Comment is not guaranteed once an LSP pushes semantic tokens.
      --
      -- Dimmer still, in order: overlay0 #6c7086, surface2 #585b70,
      -- surface1 #45475a. Below surface1 they stop being legible on this
      -- background, which is #0c0c12, not mocha's own #1e1e2e.
      Comment = { fg = colors.overlay1 },
      ['@comment'] = { fg = colors.overlay1 },

      -- No DiagnosticUnderline* entries here on purpose. Catppuccin's
      -- groups/lsp.lua already sets each one's `sp` to the matching severity
      -- color, which is exactly the wanted underline color, and naming `fg`
      -- alongside it would repaint the token itself — diagnostic extmarks sit
      -- at priority 150, above treesitter's 100 and semantic tokens' 125, so
      -- the syntax color would lose.
      --
      -- Keeping the token's own color means the underline rides on `sp` alone,
      -- and `sp` reaches the screen only as SGR 58. Inside tmux that depends on
      -- the `usstyle` terminal-feature in ~/.config/tmux/tmux.conf; without it
      -- the terminal draws the curl in the cell's foreground instead.

      -- Every *Sel group below carries an explicit `style = {}`. Catppuccin
      -- defines the selected row as `{ bg = ..., style = { "bold" } }`, and
      -- custom_highlights is merged into that rather than replacing it, so an
      -- entry naming only `bg` leaves the bold in place. Same trap as Visual.
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

      -- Telescope goes the other way from the completion popups above: it stays
      -- transparent onto the terminal background, as it did under rose-pine.
      -- Catppuccin links TelescopeNormal to NormalFloat and TelescopeBorder to
      -- FloatBorder, both of which the `float`/`border` locals paint opaque for
      -- blink's sake, so telescope has to name its own backgrounds to escape
      -- that. Every window is spelled out rather than left to the link.
      TelescopeNormal = { fg = colors.text, bg = transparent },
      TelescopePromptNormal = { fg = colors.text, bg = transparent },
      TelescopeResultsNormal = { fg = colors.text, bg = transparent },
      TelescopePreviewNormal = { fg = colors.text, bg = transparent },
      TelescopeBorder = { fg = colors.surface1, bg = transparent },
      TelescopePromptBorder = { fg = colors.surface1, bg = transparent },
      TelescopeResultsBorder = { fg = colors.surface1, bg = transparent },
      TelescopePreviewBorder = { fg = colors.surface1, bg = transparent },
      TelescopeTitle = { fg = colors.surface2, bg = transparent },

      -- The selected row keeps a background — it is the only thing marking the
      -- cursor in the list — but loses catppuccin's bold and its flamingo fg.
      TelescopeSelection = { fg = colors.text, bg = colors.surface0, style = {} },
      TelescopeSelectionCaret = { fg = colors.green, bg = colors.surface0, style = {} },
      TelescopeMultiSelection = { fg = colors.text, bg = colors.surface0, style = {} },
      TelescopePreviewLine = { bg = colors.surface0 },
    }
  end,
}

vim.cmd.colorscheme 'catppuccin-mocha'
