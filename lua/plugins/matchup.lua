-- Highlight matching brackets and tags; replaces Neovim's built-in matchparen.
-- Tags and words use MatchWord, which links to MatchParen, so photon.lua's
-- match colors cover both.
vim.g.matchup_matchparen_offscreen = {}
-- No "◀ function" hint after a closing bracket.
vim.g.matchup_treesitter_disable_virtual_text = true
-- Needed for the surround highlight below.
vim.g.matchup_matchparen_deferred = 1

vim.pack.add {
  'https://github.com/andymass/vim-matchup',
}

-- Like MatchTagAlways: in markup, keep the enclosing tag pair highlighted
-- wherever the cursor is inside the element. Code buffers only highlight a
-- pair with the cursor on it.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('MatchupSurround', { clear = true }),
  pattern = { 'html', 'xhtml', 'xml', 'vue' },
  callback = function()
    vim.b.matchup_matchparen_hi_surround_always = 1
  end,
})
