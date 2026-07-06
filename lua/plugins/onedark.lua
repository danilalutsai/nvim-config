local gh = require 'gh'

vim.pack.add { gh 'navarasu/onedark.nvim' }

require('onedark').setup {
  style = 'warm',
}

vim.cmd.colorscheme 'onedark'

vim.api.nvim_set_hl(0, 'MatchParen', { fg = '#e06c75', bold = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.api.nvim_set_hl(0, 'MatchParen', { fg = '#e06c75', bold = true })
  end,
})

-- Disable italics and bold in all current highlight groups
local function disable_italic_and_bold()
  for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, {
      name = group,
      link = false,
    })

    if ok and hl then
      hl.italic = false
      hl.bold = false
      hl.cterm = nil
    end
  end
end

disable_italic_and_bold()

-- Re-apply after any colorscheme or plugin changes highlight groups
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("DisableItalicAndBold", { clear = true }),
  callback = function()
    vim.schedule(disable_italic_and_bold)
  end,
})

vim.api.nvim_set_hl(0, "Visual", {
  bg = "#6c7086",
  fg = "#cdd6f4",
})

vim.api.nvim_set_hl(0, "VisualNOS", {
  bg = "#585b70",
  fg = "#cdd6f4",
})
