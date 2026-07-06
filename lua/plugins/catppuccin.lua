local gh = require 'gh'

vim.pack.add {
  { src = gh 'catppuccin/nvim', name = 'catppuccin' },
}

require('catppuccin').setup {
  flavour = 'mocha',
  no_italic = true,
}

-- Disabled in favor of onedark
-- vim.cmd.colorscheme 'catppuccin'

-- for _, group in ipairs(vim.fn.getcompletion('', 'highlight')) do
--   local hl = vim.api.nvim_get_hl(0, { name = group })
--   if hl.italic then
--     hl.italic = false
--     vim.api.nvim_set_hl(0, group, hl)
--   end
-- end
