local gh = require "gh"

vim.pack.add {
  gh "NeogitOrg/neogit",
}

require("neogit").setup({
  kind = "replace",

highlight = {
  -- Added changes: same colors in every state
  -- green = "#a6e3a1",
  -- bg_green = "#a6e3a1",
  line_green = "#243b2a",
  inline_green = "#243b2a",

  -- Deleted changes: same colors in every state
  -- red = "#f38ba8",
  -- bg_red = "#f38ba8",
  line_red = "#432a35",
  inline_red = "#432a35",

  bold = false,
  italic = false,
},
  integrations = {
    telescope = true,
  },
})

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", {
  desc = "Open Neogit",
})
