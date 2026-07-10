local gh = require 'gh'

vim.pack.add { gh 'folke/tokyonight.nvim' }

require('tokyonight').setup {
  style = 'moon',
  styles = {
    functions = {},
    variables = {},
  },
  on_colors = function(colors)
    colors.fg = '#b7c4eb'
    colors.orange = '#e08d6c'
    colors.green = '#aabf71'
    colors.green1 = '#5bb0a0'
    colors.yellow = '#d9b27e'
    colors.red = '#e07b83'
    colors.magenta = '#b08ee8'
    colors.purple = '#db95cb'
    colors.blue = '#7995d1'
    colors.blue1 = '#69bdd6'
    colors.blue5 = '#69bdd6'
    colors.cyan = '#69bdd6'
  end,
}

vim.cmd.colorscheme 'tokyonight-moon'

local function apply_custom_highlights()
  vim.api.nvim_set_hl(0, 'MatchParen', { fg = '#cbd154', bold = true })
  vim.api.nvim_set_hl(0, 'Folded', { fg = '#c8d3f5', bg = '#2f3549' })
  vim.api.nvim_set_hl(0, 'FoldArrow', { fg = '#c99e63', bg = '#2f3549' })

  for _, group in ipairs {
    '@lsp.typemod.class.defaultLibrary.javascript',
    '@lsp.typemod.class.defaultLibrary.javascriptreact',
    '@lsp.typemod.class.defaultLibrary.typescript',
    '@lsp.typemod.class.defaultLibrary.typescriptreact',
  } do
    vim.api.nvim_set_hl(0, group, { fg = '#b08ee8' })
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
