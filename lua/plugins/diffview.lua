
local gh = require 'gh'

vim.pack.add { gh 'sindrets/diffview.nvim' }
--
--
-- Catppuccin Mocha colors for Diffview changes
local function set_diffview_colors()
  -- Added lines
  vim.api.nvim_set_hl(0, "DiffAdd", {
    -- fg = "#a6e3a1",
    bg = "#243b2a",
  })

  -- Deleted lines
  vim.api.nvim_set_hl(0, "DiffDelete", {
    -- fg = "#f38ba8",
    bg = "#432a35",
  })

  -- Changed lines / inline changed text
  vim.api.nvim_set_hl(0, "DiffChange", {
    fg = "#cdd6f4",
    bg = "#313244",
  })

  vim.api.nvim_set_hl(0, "DiffText", {
    fg = "#cdd6f4",
    bg = "#45475a",
  })
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
