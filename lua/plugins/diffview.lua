
vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }

local function set_diffview_colors()
  -- Colors sampled from Claude Code's dark theme diff view.
  local add_fg = "#72c560"
  local add_bg = "#0e2705"
  local add_word_bg = "#1d460f"
  local delete_fg = "#cc625e"
  local delete_bg = "#370603"
  local delete_word_bg = "#540d06"
  local text_fg = "#f8f8f3"

  -- Added lines. No fg: treesitter/syntax colors show through, only bg is tinted.
  vim.api.nvim_set_hl(0, "DiffAdd", { bg = add_bg })

  -- Deleted lines
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = delete_fg, bg = delete_bg })

  -- Deleted side of a two-way diff renders through diffview's own group.
  vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { bg = delete_bg })

  -- Changed lines / inline changed text
  vim.api.nvim_set_hl(0, "DiffChange", { bg = add_bg })
  vim.api.nvim_set_hl(0, "DiffText", { bg = add_word_bg })

  -- Fugitive expanded file diffs use git/diff syntax groups for +/- lines.
  vim.api.nvim_set_hl(0, "diffAdded", { fg = text_fg, bg = add_bg })
  vim.api.nvim_set_hl(0, "diffRemoved", { fg = text_fg, bg = delete_bg })
  vim.api.nvim_set_hl(0, "Added", { fg = text_fg, bg = add_bg })
  vim.api.nvim_set_hl(0, "Removed", { fg = text_fg, bg = delete_bg })

  -- Neogit hunks
  vim.api.nvim_set_hl(0, "NeogitDiffAdd", { fg = text_fg, bg = add_bg })
  vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", { fg = text_fg, bg = add_word_bg })
  vim.api.nvim_set_hl(0, "NeogitDiffDelete", { fg = text_fg, bg = delete_bg })
  vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", { fg = text_fg, bg = delete_word_bg })

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
