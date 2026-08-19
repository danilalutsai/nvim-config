vim.pack.add { 'https://github.com/windwp/nvim-autopairs' }

require('nvim-autopairs').setup {
  -- Consult the treesitter tree before pairing, so a `"` typed inside a comment
  -- or an existing string does not open a new pair. Needs a parser for the
  -- buffer's language; filetypes without one fall back to the plain behavior.
  check_ts = true,

  -- Skip the closing pair when the cursor is directly before one of these,
  -- rather than inserting a second one. The default is `%w` -- any word
  -- character -- which also refuses to pair before a letter, so typing `(` in
  -- front of an existing word would insert a lone `(`.
  ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],

  -- <CR> between a just-opened pair splits it across three lines with the
  -- cursor indented on the middle one.
  map_cr = true,

  -- <BS> on the inside of an empty pair deletes both halves.
  map_bs = true,
}
