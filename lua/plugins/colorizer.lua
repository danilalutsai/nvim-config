local gh = require 'gh'

vim.pack.add { gh 'catgoose/nvim-colorizer.lua' }

require('colorizer').setup {
  options = {
    parsers = {
      css = true, -- names, hex, rgb, hsl, oklch, css_var
      tailwind = {
        enable = true, -- built-in palette: bg-red-500, text-sky-300, ...
        lsp = { enable = true }, -- exact colors from tailwindcss-language-server
        update_names = true, -- feed LSP colors back into the name cache
      },
    },
    display = {
      mode = 'virtualtext',
      virtualtext = {
        char = '■',
        position = 'after',
      },
    },
  },
}
