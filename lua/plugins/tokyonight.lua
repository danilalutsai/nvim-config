local gh = require 'gh'
local bg = '#222436'
local unused_ns = vim.api.nvim_create_namespace 'custom-unused-values'

vim.pack.add { gh 'folke/tokyonight.nvim' }

require('tokyonight').setup {
    style = 'moon',
    styles = {
      functions = {},
      variables = {},
    },
    on_colors = function(colors)
      colors.bg = bg
      colors.bg_dark = bg
      colors.bg_float = bg
      colors.bg_popup = bg
      colors.bg_sidebar = bg
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
    on_highlights = function() end,
  }

vim.cmd.colorscheme 'tokyonight-moon'

local function apply_custom_highlights()
  local line_nr = vim.api.nvim_get_hl(0, { name = 'LineNr', link = false })

  vim.api.nvim_set_hl(0, 'Normal', { bg = bg })
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = bg })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = bg })
  vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#444a73', bg = bg })
  vim.api.nvim_set_hl(0, 'Pmenu', { bg = bg })
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = bg })
  vim.api.nvim_set_hl(0, 'EndOfBuffer', { fg = line_nr.fg, bg = bg })
  vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = bg })
  vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = bg })
  vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { bg = bg })
  vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { bg = bg })
  vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = '#444a73', bg = bg })
  vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = '#444a73', bg = bg })
  vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { fg = '#444a73', bg = bg })
  vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { fg = '#444a73', bg = bg })
  vim.api.nvim_set_hl(0, 'MatchParen', { fg = '#cbd154', bg = '#4b5173', bold = true })
  vim.api.nvim_set_hl(0, 'Folded', { fg = '#c8d3f5', bg = '#2f3549' })
  vim.api.nvim_set_hl(0, 'FoldArrow', { fg = '#c99e63', bg = '#2f3549' })
  vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', {
    fg = '#545c7e',
    sp = '#545c7e',
    underline = false,
    undercurl = false,
  })
  vim.api.nvim_set_hl(0, 'UnusedValue', { fg = '#545c7e' })


  for _, group in ipairs {
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

  for _, group in ipairs {
    '@type.builtin.javascript',
    '@type.builtin.javascriptreact',
    '@type.builtin.typescript',
    '@type.builtin.typescriptreact',
    '@boolean.javascript',
    '@boolean.javascriptreact',
    '@boolean.typescript',
    '@boolean.typescriptreact',
    '@constant.builtin.javascript',
    '@constant.builtin.javascriptreact',
    '@constant.builtin.typescript',
    '@constant.builtin.typescriptreact',
    '@lsp.typemod.class.defaultLibrary.javascript',
    '@lsp.typemod.class.defaultLibrary.javascriptreact',
    '@lsp.typemod.class.defaultLibrary.typescript',
    '@lsp.typemod.class.defaultLibrary.typescriptreact',
  } do
    vim.api.nvim_set_hl(0, group, { fg = '#b08ee8' })
  end
end

local function diagnostic_is_unnecessary(diagnostic)
  local tags = diagnostic.tags

  if not tags and diagnostic.user_data and diagnostic.user_data.lsp then
    tags = diagnostic.user_data.lsp.tags
  end

  if type(tags) ~= 'table' then return false end

  for _, tag in ipairs(tags) do
    if tag == 1 or tag == 'unnecessary' then
      return true
    end
  end

  return false
end

local function apply_unused_diagnostic_highlights(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end

  vim.api.nvim_buf_clear_namespace(bufnr, unused_ns, 0, -1)

  for _, diagnostic in ipairs(vim.diagnostic.get(bufnr)) do
    if diagnostic_is_unnecessary(diagnostic) then
      local start_line = diagnostic.lnum
      local end_line = diagnostic.end_lnum or diagnostic.lnum

      for line = start_line, end_line do
        local line_text = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1] or ''
        local start_col = line == start_line and diagnostic.col or 0
        local end_col = line == end_line and diagnostic.end_col or #line_text

        if end_col > start_col then
          vim.api.nvim_buf_set_extmark(bufnr, unused_ns, line, start_col, {
            end_col = end_col,
            hl_group = 'UnusedValue',
            priority = 200,
          })
        end
      end
    end
  end
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

vim.api.nvim_create_autocmd('LspTokenUpdate', {
  callback = function(ev)
    local token = ev.data.token
    if token.modifiers and token.modifiers.unused then
      vim.lsp.semantic_tokens.highlight_token(token, ev.buf, ev.data.client_id, 'UnusedValue')
    end
  end,
})

vim.api.nvim_create_autocmd({ 'DiagnosticChanged', 'BufEnter' }, {
  callback = function(ev)
    apply_unused_diagnostic_highlights(ev.buf)
  end,
})
