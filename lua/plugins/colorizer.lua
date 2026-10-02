vim.pack.add { 'https://github.com/catgoose/nvim-colorizer.lua' }

require('colorizer').setup {
  filetypes = { '*' }, -- Vue and every other filetype
  options = {
    parsers = {
      css = true, -- names, hex, rgb, hsl, oklch, css_var
      names = {
        enable = true,
        lowercase = true,
        camelcase = true,
        uppercase = true,
      },
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
