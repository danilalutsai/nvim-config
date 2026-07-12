local gh = require 'gh'

vim.pack.add { gh 'folke/tokyonight.nvim' }

require('tokyonight').setup {
  style = 'moon',
  styles = {
    functions = {},
    variables = {},
  },
  on_colors = function(colors)
    colors.bg = '#1a1b26'
    colors.bg_dark = '#1a1b26'
    colors.fg = '#b7c4eb'
    colors.orange = '#e08d6c'
    colors.green = '#aabf71'
    colors.green1 = '#5bb0a0'
    colors.yellow = '#d9b27e'
    colors.red = '#d9868d'
    colors.magenta = '#b08ee8'
    colors.purple = '#d494c5'
    colors.blue = '#7291d4'
    colors.blue1 = '#77bcd1'
    colors.blue5 = '#77bcd1'
    colors.cyan = '#77bcd1'
  end,
}

vim.cmd.colorscheme 'tokyonight-moon'

local function apply_custom_highlights()
  vim.api.nvim_set_hl(0, 'Normal', { bg = '#1a1b26' })
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = '#1a1b26' })
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#1a1b26' })
  vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = '#1a1b26' })
  vim.api.nvim_set_hl(0, 'MatchParen', { fg = '#cbd154', bold = true })
  vim.api.nvim_set_hl(0, 'Folded', { fg = '#c8d3f5', bg = '#2f3549' })
  vim.api.nvim_set_hl(0, 'FoldArrow', { fg = '#c99e63', bg = '#2f3549' })

  for _, group in ipairs {
    '@constructor.javascript',
    '@constructor.javascriptreact',
    '@constructor.typescript',
    '@constructor.typescriptreact',
    '@type.builtin.javascript',
    '@type.builtin.javascriptreact',
    '@type.builtin.typescript',
    '@type.builtin.typescriptreact',
    '@lsp.typemod.class.defaultLibrary.javascript',
    '@lsp.typemod.class.defaultLibrary.javascriptreact',
    '@lsp.typemod.class.defaultLibrary.typescript',
    '@lsp.typemod.class.defaultLibrary.typescriptreact',
    '@lsp.typemod.interface.defaultLibrary.javascript',
    '@lsp.typemod.interface.defaultLibrary.javascriptreact',
    '@lsp.typemod.interface.defaultLibrary.typescript',
    '@lsp.typemod.interface.defaultLibrary.typescriptreact',
    '@lsp.typemod.type.defaultLibrary.javascript',
    '@lsp.typemod.type.defaultLibrary.javascriptreact',
    '@lsp.typemod.type.defaultLibrary.typescript',
    '@lsp.typemod.type.defaultLibrary.typescriptreact',
  } do
    vim.api.nvim_set_hl(0, group, { fg = '#77bcd1' })
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
