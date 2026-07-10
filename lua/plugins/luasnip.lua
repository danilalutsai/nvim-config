local gh = require 'gh'

vim.pack.add {
  { src = gh('L3MON4D3/LuaSnip'), version = vim.version.range '2.*' },
  gh 'rafamadriz/friendly-snippets',
}
require('luasnip').setup {}
require('luasnip.loaders.from_vscode').lazy_load()
