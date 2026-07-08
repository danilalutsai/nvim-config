local gh = require "gh"

vim.pack.add {
  gh "iamcco/markdown-preview.nvim",
}

vim.g.mkdp_filetypes = { "markdown" }

vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", {
  desc = "Toggle Markdown Preview",
})
