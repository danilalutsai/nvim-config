local gh = require 'gh'

vim.pack.add { { src = gh('saghen/blink.cmp'), version = vim.version.range '1.*' } }
require('blink.cmp').setup {
  keymap = {
    preset = 'default',
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
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
    menu = {
      draw = {
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
