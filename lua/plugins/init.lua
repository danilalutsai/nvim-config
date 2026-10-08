local plugins = {
  'gitsigns',
  'milka-simple',
  'lualine',
  'mini',
  'surround',
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
  -- 'autopairs',
  'neogit',
  'diffview',
  'oil',
  'treesitter',
  'treesj',
  'nvim-treesitter-textobjects',
  'undotree',
  'fugitive',
  'vim-tmux-navigator',
  'markdown-preview',
  'colorizer',
  'match-tag-always',
}

for _, name in ipairs(plugins) do
	local ok, err = pcall(require, "plugins." .. name)
	if not ok then
		vim.notify(("Failed to load plugin %s: %s"):format(name, err), vim.log.levels.ERROR)
	end
end

