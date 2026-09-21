-- Highlight the tag opposite the cursor in HTML/XML only.
vim.g.mta_filetypes = { html = 1, xhtml = 1, xml = 1, vue = 1 }
vim.g.mta_use_matchparen_group = 0
vim.g.mta_set_default_matchtag_color = 0
vim.g.python3_host_prog = vim.fn.expand('~/.local/share/nvim-matchtag-venv/bin/python')

vim.api.nvim_set_hl(0, 'MatchTag', { bg = 'NONE', sp = '#f9e2af', undercurl = true })

vim.pack.add {
  'https://github.com/Valloric/MatchTagAlways',
}
