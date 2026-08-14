
vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }

local function set_diffview_colors()
  local add_fg = "#164542"
  local add_bg = "#99cfc4"
  local delete_fg = "#471527"
  local delete_bg = "#de99ad"
  local change_bg = "#14131c"

  -- Added lines. No fg: treesitter/syntax colors show through, only bg is tinted.
  vim.api.nvim_set_hl(0, "DiffAdd", {
    bg = add_bg,
    fg = add_fg,
  })

  -- Deleted lines
  vim.api.nvim_set_hl(0, "DiffDelete", {
    bg = delete_bg,
    fg = delete_fg,
  })

  -- Deleted side of a two-way diff renders through diffview's own group.
  vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { bg = delete_bg })

  -- Changed lines / inline changed text
  vim.api.nvim_set_hl(0, "DiffChange", {
    bg = change_bg,
  })

  vim.api.nvim_set_hl(0, "DiffText", {
    bg = change_bg,
  })

  -- Fugitive expanded file diffs use git/diff syntax groups for +/- lines.
  vim.api.nvim_set_hl(0, "diffAdded", { fg = add_fg, bg = add_bg })
  vim.api.nvim_set_hl(0, "diffRemoved", { fg = delete_fg, bg = delete_bg })
  vim.api.nvim_set_hl(0, "Added", { fg = add_fg, bg = add_bg })
  vim.api.nvim_set_hl(0, "Removed", { fg = delete_fg, bg = delete_bg })

end

set_diffview_colors()

-- Re-apply after changing colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("DiffviewCatppuccinColors", { clear = true }),
  callback = set_diffview_colors,
})


vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', {
  desc = 'Open Git diff view',
})

vim.keymap.set('n', '<leader>gD', '<cmd>DiffviewClose<CR>', {
  desc = 'Close Git diff view',
})

vim.keymap.set("n", "<C-w>X", function()
  local diffview_tab = vim.fn.tabpagenr()

  vim.cmd("DiffviewClose")

  vim.schedule(function()
    local tab_count = vim.fn.tabpagenr("$")

    if tab_count > 1 and diffview_tab <= tab_count then
      vim.cmd("tabclose " .. diffview_tab)
    end
  end)
end, {
  desc = "Close Diffview tab completely",
})
