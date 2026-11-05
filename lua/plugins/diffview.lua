
vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }

local function set_diffview_colors()
  -- No backgrounds anywhere in diffs: changes are marked by text color only.
  local add_fg = "#84c462"
  local delete_fg = "#d75f5f"

  -- Side-by-side diffs (vimdiff, :Gvdiffsplit, diffview)
  vim.api.nvim_set_hl(0, "DiffAdd", { fg = add_fg })
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = delete_fg })
  -- Deleted side of a two-way diff renders through diffview's own group.
  vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { fg = delete_fg })
  -- Changed lines keep their syntax colors; only the changed text turns green.
  vim.api.nvim_set_hl(0, "DiffChange", {})
  vim.api.nvim_set_hl(0, "DiffText", { fg = add_fg })

  -- Fugitive expanded file diffs use git/diff syntax groups for +/- lines.
  vim.api.nvim_set_hl(0, "diffAdded", { fg = add_fg })
  vim.api.nvim_set_hl(0, "diffRemoved", { fg = delete_fg })
  vim.api.nvim_set_hl(0, "Added", { fg = add_fg })
  vim.api.nvim_set_hl(0, "Removed", { fg = delete_fg })

  -- Neogit hunks
  vim.api.nvim_set_hl(0, "NeogitDiffAdd", { fg = add_fg })
  vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", { fg = add_fg })
  vim.api.nvim_set_hl(0, "NeogitDiffDelete", { fg = delete_fg })
  vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", { fg = delete_fg })

  -- Gitsigns column markers: colored sign only, no line tint.
  vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = add_fg })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = delete_fg })
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
