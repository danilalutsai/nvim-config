
local gh = require 'gh'

vim.pack.add { gh 'sindrets/diffview.nvim' }
--
--

local colors = {
  base = '#0c0c12',
  surface = '#1f1d2e',
  overlay = '#26233a',
  muted = '#2d2c38',
  subtle = '#58556b',
  text = '#cbc7eb',
  love = '#db728e',
  gold = '#f5c06c',
  rose = '#e6a5a5',
  pine = '#697edb',
  foam = '#7cbfc4',
  iris = '#b395e6',
  leaf = '#95b1ac',
  highlight_low = '#21202e',
  highlight_med = '#403d52',
  highlight_high = '#524f67',
}

local function set_diffview_colors()
  local add_fg = "#88b7ae"
  local add_bg = "#14332f"
  local delete_fg = "#c88b9d"
  local delete_bg = "#471929"
  local change_bg = "#14131c"

  -- Added lines. No fg: treesitter/syntax colors show through, only bg is tinted.
  vim.api.nvim_set_hl(0, "DiffAdd", {
    bg = add_bg,
  })

  -- Deleted lines
  vim.api.nvim_set_hl(0, "DiffDelete", {
    bg = delete_bg,
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
