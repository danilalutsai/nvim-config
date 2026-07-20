local gh = require 'gh'

vim.pack.add { gh 'rose-pine/neovim' }

local colors = {
  base = '#0c0c12',
  surface = '#1f1d2e',
  hello = 'word',
  overlay = '#26233a',
  muted = '#2d2c38',
  subtle = '#58556b',
  text = '#cbc7eb',
  love = '#c27c91',
  -- Gold - #e8c189
  gold = '#c9a877',
  rose = '#c79595',
  pine = '#7f8bc9',
  foam = '#82babd',
  iris = '#a489cc',
  leaf = '#95b1ac',
  highlight_low = '#21202e',
  highlight_med = '#403d52',
  highlight_high = '#524f67',
}

require('rose-pine').setup {
  variant = 'main',
  dark_variant = 'main',
  palette = {
    main = colors,
  },
  styles = {
    bold = true,
    italic = false,
    transparency = false,
  },
}

vim.cmd.colorscheme 'rose-pine-main'

local function apply_custom_highlights()
  local line_nr = vim.api.nvim_get_hl(0, { name = 'LineNr', link = false })
  local quickfix_line = vim.api.nvim_get_hl(0, { name = 'QuickFixLine', link = false })

  vim.api.nvim_set_hl(0, 'Normal', { fg = colors.text, bg = colors.base })
  vim.api.nvim_set_hl(0, 'NormalNC', { fg = colors.text, bg = colors.base })
  vim.api.nvim_set_hl(0, 'NormalFloat', { fg = colors.text, bg = colors.surface })
  vim.api.nvim_set_hl(0, 'FloatBorder', { fg = colors.muted, bg = colors.surface })
  vim.api.nvim_set_hl(0, 'ColorColumn', { bg = colors.surface })
  vim.api.nvim_set_hl(0, 'Operator', { fg = "#9290ad" })
  vim.api.nvim_set_hl(0, '@keyword.operator.typescript', { fg = "#ad95cf" })
  vim.api.nvim_set_hl(0, '@keyword.operator.javascript', { fg = "#ad95cf" })
  vim.api.nvim_set_hl(0, '@operator', { fg = "#9290ad" })
  vim.api.nvim_set_hl(0, '@comment', { fg = "#626080" })
  vim.api.nvim_set_hl(0, '@keyword.operator', { fg = "#9290ad" })
  vim.api.nvim_set_hl(0, '@keyword', { fg = "#7f8bc9", italic = false })
  vim.api.nvim_set_hl(0, '@keyword.return', { fg = "#7f8bc9", italic = false })
  vim.api.nvim_set_hl(0, '@keyword.conditional', { fg = "#7f8bc9", italic = false })
  vim.api.nvim_set_hl(0, '@keyword.repeat', { fg = "#7f8bc9", italic = false })
  vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = "#9290ad" })
  vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = "#9290ad" })
  vim.api.nvim_set_hl(0, "@punctuation.optional", { fg = "#9290ad" })
  vim.api.nvim_set_hl(0, '@punctuation.special', { fg = '#9290ad' })
  vim.api.nvim_set_hl(0, 'Pmenu', { fg = "#9290ad", bg = colors.surface })
  vim.api.nvim_set_hl(0, 'BlinkCmpLabel', { fg = '#9290ad' })
  vim.api.nvim_set_hl(0, 'BlinkCmpLabelDeprecated', { fg = '#9290ad', strikethrough = true })
  vim.api.nvim_set_hl(0, 'BlinkCmpLabelDetail', { fg = '#9290ad' })
  vim.api.nvim_set_hl(0, 'BlinkCmpLabelDescription', { fg = '#9290ad' })
  vim.api.nvim_set_hl(0, 'BlinkCmpSource', { fg = '#9290ad' })
  vim.api.nvim_set_hl(0, 'BlinkCmpScrollBarThumb', { bg = '#9290ad' })
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = colors.base })
  vim.api.nvim_set_hl(0, 'EndOfBuffer', { fg = line_nr.fg, bg = colors.base })
  vim.api.nvim_set_hl(0, 'TelescopeNormal', { fg = colors.text, bg = colors.base })
  vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { fg = colors.text, bg = colors.base })
  vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { fg = colors.text, bg = colors.base })
  vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { fg = colors.text, bg = colors.base })
  vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = colors.muted, bg = colors.base })
  vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = colors.muted, bg = colors.base })
  vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { fg = colors.muted, bg = colors.base })
  vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { fg = colors.muted, bg = colors.base })
  vim.api.nvim_set_hl(0, 'QuickFixLine', vim.tbl_extend('force', quickfix_line, { bg = colors.overlay }))
  vim.api.nvim_set_hl(0, 'MatchParen', { fg = "#629bb3", bg = "#38354a", bold = true })
  vim.api.nvim_set_hl(0, 'Folded', { fg = colors.text, bg = 'none' })
  vim.api.nvim_set_hl(0, 'FoldArrow', { fg = colors.gold, bg = 'none' })
  vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#201d29' })
  vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#201d29' })
  vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#201d29' })
  vim.api.nvim_set_hl(0, 'Visual', { bg = '#4d475e' })
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#58556b" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#58556b", bold = true })
end

local function remove_bold_except_matchparen()
  ---@type string[]
  local highlight_groups = vim.fn.getcompletion('', 'highlight')

  for _, group in ipairs(highlight_groups) do
    if group ~= 'MatchParen' then
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
      if ok and type(hl) == 'table' and hl.bold then
        vim.api.nvim_set_hl(0, group, vim.tbl_extend('force', hl, { bold = false }))
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
