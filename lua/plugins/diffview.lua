
vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }

local function set_diffview_colors()
  -- Changes are marked by photon's regular foreground on a dark green/red
  -- background. photon.lua sets the same values; keep the two in sync.
  local add = { fg = "#d4d4d4", bg = "#022800" }
  local delete = { fg = "#d4d4d4", bg = "#3d0101" }

  -- Side-by-side diffs (vimdiff, :Gvdiffsplit, diffview)
  vim.api.nvim_set_hl(0, "DiffAdd", add)
  vim.api.nvim_set_hl(0, "DiffDelete", delete)
  -- Deleted side of a two-way diff renders through diffview's own group.
  vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", delete)
  -- Changed lines keep their syntax colors; only the changed text turns green.
  vim.api.nvim_set_hl(0, "DiffChange", {})
  vim.api.nvim_set_hl(0, "DiffText", add)

  -- Fugitive expanded file diffs use git/diff syntax groups for +/- lines.
  vim.api.nvim_set_hl(0, "diffAdded", add)
  vim.api.nvim_set_hl(0, "diffRemoved", delete)
  vim.api.nvim_set_hl(0, "Added", add)
  vim.api.nvim_set_hl(0, "Removed", delete)

  -- Neogit hunks
  vim.api.nvim_set_hl(0, "NeogitDiffAdd", add)
  vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", add)
  vim.api.nvim_set_hl(0, "NeogitDiffDelete", delete)
  vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", delete)

  -- Gitsigns column markers: colored sign only, no line tint.
  vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#84c462" })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#d75f5f" })
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
