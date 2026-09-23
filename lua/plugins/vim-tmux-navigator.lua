-- HerdR's navigator provides these mappings when running in HerdR and falls
-- back to this plugin when Neovim is running inside tmux.
vim.g.tmux_navigator_no_mappings = 1

vim.pack.add {
  "https://github.com/christoomey/vim-tmux-navigator",
}

-- vim-herdr-navigation has no equivalent "previous pane" action; preserve
-- vim-tmux-navigator's existing tmux-only binding for normal tmux sessions.
vim.keymap.set("n", "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>")
