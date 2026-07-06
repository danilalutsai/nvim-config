local gh = require "gh"

vim.pack.add {
  gh "tpope/vim-fugitive",
}

-- Open Fugitive Git status
vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", {
  desc = "Fugitive Git status",
})

-- Open a side-by-side diff for the current file
vim.keymap.set("n", "<leader>gf", "<cmd>Gvdiffsplit<CR>", {
  desc = "Fugitive vertical diff",
})

-- Show Git blame for the current file
vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", {
  desc = "Fugitive blame",
})

-- Stage the current file
vim.keymap.set("n", "<leader>ga", "<cmd>Gwrite<CR>", {
  desc = "Stage current file",
})

-- Restore the current file from Git
vim.keymap.set("n", "<leader>gr", "<cmd>Gread<CR>", {
  desc = "Restore current file",
})

-- Show Git log for the current file
vim.keymap.set("n", "<leader>gl", "<cmd>Git log --follow -- %<CR>", {
  desc = "Git log current file",
})

vim.keymap.set("n", "<leader>gL", "<cmd>Git log --oneline -30<CR>", {
  desc = "Git log all commits",
})

vim.api.nvim_create_autocmd("User", {
  pattern = "FugitiveCommit",
  callback = function(event)
    vim.keymap.set("n", "gb", "<cmd>b#<CR>", {
      buffer = event.buf,
      silent = true,
      desc = "Back to Git log",
    })
  end,
})
