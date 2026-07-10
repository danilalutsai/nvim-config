local gh = require "gh"

vim.g.surround_no_mappings = 1
vim.g.surround_40 = "(\r)"
vim.g.surround_60 = "<\r>"
vim.g.surround_91 = "[\r]"
vim.g.surround_123 = "{\r}"

vim.pack.add {
  gh "tpope/vim-surround",
}


vim.keymap.set("n", "yss", "<Plug>Yssurround", {
  remap = true,
  silent = true,
  desc = "Add surround to current line",
})

vim.keymap.set("n", "ds", "<Plug>Dsurround", {
  remap = true,
  silent = true,
  desc = "Delete surround",
})

vim.keymap.set("n", "cs", "<Plug>Csurround", {
  remap = true,
  silent = true,
  desc = "Change surround",
})

vim.keymap.set("x", "S", "<Plug>VSurround", {
  remap = true,
  silent = true,
  desc = "Surround selection",
})
