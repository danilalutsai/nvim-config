# Neovim config

My personal Neovim setup. It started from kickstart and is not a distribution.
It targets Neovim 0.13-dev and uses the built-in `vim.pack` manager, with
versions pinned in `nvim-pack-lock.json`.

## Layout

- `init.lua`: diagnostics, yank highlight and plugin build hooks
- `lua/options.lua`: editor options, hybrid line numbers, Tree-sitter folds
- `lua/keybinds.lua`: global mappings
- `lua/plugins/init.lua`: the list of active plugins, one file each
- `after/`: query overrides and Ctrl-h/j/k/l navigation across Neovim, HerdR and tmux

## Plugins

- **Theme and UI:** photon.vim with custom colors, lualine, fidget, mini.icons, nvim-colorizer
- **LSP:** Mason and native `vim.lsp` for TypeScript, Vue, Tailwind, HTML, CSS, Emmet, Python and Lua
- **Completion:** blink.cmp, LuaSnip, friendly-snippets
- **Formatting:** conform, run manually with `<leader>f`
- **Syntax and editing:** Tree-sitter, textobjects, treesj, mini.ai, vim-surround, MatchTagAlways
- **Git:** fugitive, Neogit, diffview, gitsigns
- **Navigation:** oil, Telescope, undotree, vim-tmux-navigator
- **Docs:** markdown-preview

## Handy keys

Leader is Space.

| Key | Action |
| --- | --- |
| `<leader>c` | Oil with preview |
| `<leader>sf` / `<leader>sg` | Find files / live grep |
| `<leader>rn` | Review and replace matches one by one |
| `<leader>gg` / `<leader>gs` | Neogit / Fugitive status |
| `<leader>gd` | Diffview |
| `<leader>u` | Undotree |
| `N` / `P` | Next / previous buffer |
| `<C-n>` / `<C-p>` | Next / previous search result |

Extra color schemes live in `lua/plugins/`. To switch, change the theme entry in
`lua/plugins/init.lua`.
