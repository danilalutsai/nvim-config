local gh = require 'gh'

vim.pack.add {
  { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' },
}

vim.cmd.packadd('nvim-treesitter')

require('nvim-treesitter').setup {
  install_dir = vim.fn.stdpath('data') .. '/site',
}

local parsers = {
  'bash',
  'c',
  'css',
  'diff',
  'html',
  'javascript',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
}

require('nvim-treesitter').install(parsers)

local function treesitter_try_attach(buf, language)
  local ok = pcall(vim.treesitter.start, buf, language)
  if not ok then return end

  local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
  if has_indent_query then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('my-treesitter-start', { clear = true }),
  callback = function(args)
    local language = vim.treesitter.language.get_lang(args.match)
    if language then
      treesitter_try_attach(args.buf, language)
    end
  end,
})
