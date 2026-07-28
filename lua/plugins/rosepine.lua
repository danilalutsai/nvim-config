local gh = require 'gh'

vim.pack.add { gh 'rose-pine/neovim' }

local colors = {
  base = '#0c0c12',
  surface = '#1f1d2e',
  overlay = '#26233a',
  muted = '#2d2c38',
  subtle = '#666666',
  text = '#cbc7eb',
  love = '#ed809e',
  gold = '#e0bb79',
  rose = '#e39a86',
  pine = '#798fed',
  foam = '#80c2a6',
  iris = '#ae95de',
  leaf = '#759e8d',
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
    transparency = true,
  },
}

vim.cmd.colorscheme 'rose-pine-main'

local function apply_custom_highlights()
  local line_nr = vim.api.nvim_get_hl(0, { name = 'LineNr', link = false })
  local quickfix_line = vim.api.nvim_get_hl(0, { name = 'QuickFixLine', link = false })

  -- Transparent: no bg means the terminal shows through (see Ghostty's
  -- background-opacity). Floats and menus below stay opaque for readability.
  vim.api.nvim_set_hl(0, 'Normal', { fg = colors.text, bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'NormalNC', { fg = colors.text, bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { fg = colors.text, bg = colors.surface })
  vim.api.nvim_set_hl(0, 'FloatBorder', { fg = colors.muted, bg = colors.surface })
  vim.api.nvim_set_hl(0, 'ColorColumn', { bg = colors.surface })
  vim.api.nvim_set_hl(0, 'Operator', { fg = "#9290ad" })
  vim.api.nvim_set_hl(0, '@keyword.operator.typescript', { fg = "#8194e6" })
  vim.api.nvim_set_hl(0, '@keyword.operator.javascript', { fg = "#8194e6" })
  vim.api.nvim_set_hl(0, '@operator', { fg = "#9290ad" })
  vim.api.nvim_set_hl(0, '@comment', { fg = "#666666" })
  vim.api.nvim_set_hl(0, '@keyword.operator', { fg = "#9290ad" })
  vim.api.nvim_set_hl(0, '@keyword', { fg = "#8194e6", italic = false })
  vim.api.nvim_set_hl(0, '@keyword.return', { fg = "#8194e6", italic = false })
  vim.api.nvim_set_hl(0, '@keyword.conditional', { fg = "#8194e6", italic = false })
  vim.api.nvim_set_hl(0, '@keyword.conditional.ternary', { fg = "#9290ad", italic = false })
  vim.api.nvim_set_hl(0, '@keyword.import', { fg = "#8194e6", italic = false })
  vim.api.nvim_set_hl(0, '@keyword.repeat', { fg = "#8194e6", italic = false })
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
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'EndOfBuffer', { fg = line_nr.fg, bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopeNormal', { fg = colors.text, bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { fg = colors.text, bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { fg = colors.text, bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { fg = colors.text, bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = colors.muted, bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = colors.muted, bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { fg = colors.muted, bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { fg = colors.muted, bg = 'NONE' })
  -- Selected row needs a solid bg to stand out now that the rest is transparent.
  vim.api.nvim_set_hl(0, 'TelescopeSelection', { fg = colors.text, bg = colors.highlight_med })
  vim.api.nvim_set_hl(0, 'TelescopeSelectionCaret', { fg = colors.gold, bg = colors.highlight_med })
  vim.api.nvim_set_hl(0, 'TelescopeMultiSelection', { fg = colors.text, bg = colors.highlight_low })
  vim.api.nvim_set_hl(0, 'TelescopePreviewLine', { bg = colors.highlight_low })
  vim.api.nvim_set_hl(0, 'QuickFixLine', vim.tbl_extend('force', quickfix_line, { bg = colors.overlay }))
  vim.api.nvim_set_hl(0, 'MatchParen', { fg = "#e8e34d", bg = "#38354a", bold = true })
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
