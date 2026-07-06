local plugins = {
  'guess-indent',
  'gitsigns',
  -- 'which-key',
  'catppuccin',
  'onedark',
  'mini',
  'plenary',
  'telescope-ui-select',
  'telescope',
  'fidget',
  'mason',
  'mason-lspconfig',
  'nvim-lspconfig',
  'mason-tool-installer',
  'lsp',
  'conform',
  'luasnip',
  'blink-cmp',
  'neogit',
  'diffview',
  'oil',
  'treesitter',
  'nvim-treesitter-textobjects',
  'undotree',
  'fugitive',
}

for _, name in ipairs(plugins) do
  local ok, err = pcall(require, 'plugins.' .. name)
  if not ok then
    vim.notify(('Failed to load plugin %s: %s'):format(name, err), vim.log.levels.ERROR)
  end
end
