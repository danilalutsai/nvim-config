local gh = require "gh"

vim.pack.add {
  gh "mbbill/undotree",
}

-- UndoTree layout settings
vim.g.undotree_WindowLayout = 1
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_SplitWidth = 32

-- Save undo history after closing Neovim
vim.opt.undofile = true

-- Automatically preview the selected undo state
vim.cmd([[
  function! g:Undotree_CustomMap() abort
    augroup UserUndotreeAutoPreview
      autocmd! * <buffer>
      autocmd CursorMoved <buffer> if exists('t:undotree') | silent! call t:undotree.ActionEnter() | endif
    augroup END
  endfunction
]])

-- Highlight the currently selected undo entry
vim.api.nvim_create_autocmd("FileType", {
  pattern = "undotree",
  callback = function()
    vim.wo.cursorline = true
  end,
})

-- Toggle UndoTree
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", {
  desc = "Toggle UndoTree",
})
