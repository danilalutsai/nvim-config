vim.pack.add { { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' } }
require('blink.cmp').setup {
  keymap = {
    preset = 'default',
    -- macOS owns <C-space> (Input Sources > select previous), so the menu gets
    -- triggered from <C-n> instead. blink runs the list in order and skips a
    -- command that declines: closed menu -> show, open menu -> select_next,
    -- blink inactive -> Vim's own keyword completion.
    ['<C-n>'] = { 'show', 'select_next', 'fallback_to_mappings' },
    ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
  },
  appearance = {
    nerd_font_variant = 'mono',
    kind_icons = {
      Text = '󰉿',
      Method = '󰊕',
      Function = '󰊕',
      Constructor = '󰒓',
      Field = '󰜢',
      Variable = '󰆦',
      Property = '󰖷',
      Class = '󱡠',
      Interface = '󱡠',
      Struct = '󱡠',
      Module = '󰅩',
      Unit = '󰪚',
      Value = '󰦨',
      Enum = '󰦨',
      EnumMember = '󰦨',
      Keyword = '󰻾',
      Constant = '󰏿',
      Snippet = '󱄽',
      Color = '󰏘',
      File = '󰈔',
      Reference = '󰬲',
      Folder = '󰉋',
      Event = '󱐋',
      Operator = '󰪚',
      TypeParameter = '󰬛',
    },
  },
  completion = {
    -- Docs for the selected item open in their own window beside the menu.
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = {
        max_width = 80,
        max_height = 20,
        border = 'rounded',
        -- Prefer the right side, fall back to the left when there's no room.
        direction_priority = {
          menu_north = { 'e', 'w', 'n', 's' },
          menu_south = { 'e', 'w', 's', 'n' },
        },
      },
    },
    menu = {
      border = 'rounded',
      draw = {
        -- No padding columns: content starts right at the border.
        padding = 0,
        columns = {
          { 'kind_icon' },
          { 'label', 'label_description', gap = 1 },
          { 'kind' },
        },
      },
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}
