local gh = require 'gh'

vim.pack.add { gh 'navarasu/onedark.nvim' }

require('onedark').setup {
  style = 'warm',
  code_style = {
    comments = 'none',
    functions = 'none',
    variables = 'none',
    keywords = 'none',
    strings = 'none',
  }
}

vim.cmd.colorscheme 'onedark'

local function apply_custom_highlights()
  vim.api.nvim_set_hl(0, 'MatchParen', { fg = '#f7ff5c', bold = true })
  vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#f7ff5c' })
  vim.api.nvim_set_hl(0, 'FoldColumn', { fg = '#f7ff5c', bg = 'none' })
  vim.api.nvim_set_hl(0, 'Folded', { fg = '#abb2bf', bg = '#343a46' })

  for _, group in ipairs { 'Visual', 'VisualNOS' } do
    vim.api.nvim_set_hl(0, group, {
      bg = '#55452f',
      fg = 'none',
    })
  end
end

local function remove_bold_except_matchparen()
  for _, group in ipairs(vim.fn.getcompletion('', 'highlight')) do
    if group ~= 'MatchParen' then
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
      if ok and next(hl) ~= nil and hl.bold then
        hl.bold = false
        vim.api.nvim_set_hl(0, group, hl)
      end
    end
  end
end

apply_custom_highlights()
remove_bold_except_matchparen()

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    apply_custom_highlights()
    remove_bold_except_matchparen()
  end,
})
