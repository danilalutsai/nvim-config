-- Highlight the matching enclosing tag in markup buffers, including Vue SFC
-- templates.  Use MatchParen because the active theme gives it a clearly
-- visible foreground/background; the old MatchTag-only colour was too subtle
-- to distinguish from the editor background.
vim.g.mta_filetypes = { html = 1, xhtml = 1, xml = 1, vue = 1 }
vim.g.mta_use_matchparen_group = 1
vim.g.python3_host_prog = vim.fn.expand('~/.local/share/nvim-matchtag-venv/bin/python')

vim.pack.add {
  'https://github.com/Valloric/MatchTagAlways',
}
