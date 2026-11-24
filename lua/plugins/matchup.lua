-- Highlight matching brackets and tags; replaces Neovim's built-in matchparen.
-- Tags and words use MatchWord, which links to MatchParen, so photon.lua's
-- match colors cover both.
vim.g.matchup_matchparen_offscreen = {}
-- No "◀ function" hint after a closing bracket.
vim.g.matchup_treesitter_disable_virtual_text = true
-- Quotes are never a match: inside a string the enclosing tag or bracket
-- lights up instead.
vim.g.matchup_treesitter_enable_quotes = false
-- Needed for the surround highlight below.
vim.g.matchup_matchparen_deferred = 1

vim.pack.add {
  'https://github.com/andymass/vim-matchup',
}

local MARKUP = { html = true, xhtml = true, xml = true, vue = true }

-- Like MatchTagAlways: in markup, keep the enclosing tag pair highlighted
-- wherever the cursor is inside the element. Code buffers only highlight a
-- pair with the cursor on it.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('MatchupSurround', { clear = true }),
  pattern = vim.tbl_keys(MARKUP),
  callback = function()
    vim.b.matchup_matchparen_hi_surround_always = 1
  end,
})

-- Words (if/end, function/end) share MatchWord with tags. Keep it only in
-- markup, so code highlights brackets alone. matchup only draws in the
-- current window, so switching the global group on buffer enter is enough.
-- Scheduled, because FileType also fires for background buffers (LSP hover
-- and completion docs set filetype=markdown) with that buffer temporarily
-- current; checking afterwards reads the buffer actually on screen.
local function set_match_word()
  vim.schedule(function()
    local hl = MARKUP[vim.bo.filetype] and { link = 'MatchParen' } or {}
    vim.api.nvim_set_hl(0, 'MatchWord', hl)
  end)
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'FileType', 'ColorScheme' }, {
  group = vim.api.nvim_create_augroup('MatchupWordHighlight', { clear = true }),
  callback = set_match_word,
})
