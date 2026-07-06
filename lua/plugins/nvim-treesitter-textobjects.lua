local gh = require "gh"

vim.pack.add {
  gh "nvim-treesitter/nvim-treesitter-textobjects",
}

local move = require "nvim-treesitter-textobjects.move"

-- Jump to the start of functions
vim.keymap.set({ "n", "x", "o" }, "]f", function()
  move.goto_next_start("@function.outer", "textobjects")
end, {
  desc = "Next function",
})

vim.keymap.set({ "n", "x", "o" }, "[f", function()
  move.goto_previous_start("@function.outer", "textobjects")
end, {
  desc = "Previous function",
})

-- Jump to the end of functions
vim.keymap.set({ "n", "x", "o" }, "]F", function()
  move.goto_next_end("@function.outer", "textobjects")
end, {
  desc = "Next function end",
})

vim.keymap.set({ "n", "x", "o" }, "[F", function()
  move.goto_previous_end("@function.outer", "textobjects")
end, {
  desc = "Previous function end",
})
