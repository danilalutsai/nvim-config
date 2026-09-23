-- Installed from HerdR's vim-herdr-navigation plugin.  Keep this after the
-- plugin setup so it owns Ctrl-h/j/k/l in both Neovim and HerdR.
local function nav(wincmd, dir)
  local previous_window = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. wincmd)
  if vim.api.nvim_get_current_win() ~= previous_window then
    return
  end

  if vim.env.HERDR_PANE_ID and vim.env.HERDR_PANE_ID ~= "" then
    local herdr = vim.env.HERDR_BIN_PATH
    if herdr == nil or herdr == "" then
      herdr = "herdr"
    end
    vim.fn.system({ herdr, "pane", "focus", "--direction", dir, "--pane", vim.env.HERDR_PANE_ID })
  elseif vim.env.TMUX and vim.env.TMUX ~= "" then
    local tmux_direction = { left = "Left", down = "Down", up = "Up", right = "Right" }
    pcall(vim.cmd, "TmuxNavigate" .. tmux_direction[dir])
  end
end

local function map(lhs, wincmd, dir)
  vim.keymap.set("n", lhs, function()
    nav(wincmd, dir)
  end, { silent = true, noremap = true, desc = "Navigate " .. dir .. " (vim/herdr)" })
end

map("<C-h>", "h", "left")
map("<C-j>", "j", "down")
map("<C-k>", "k", "up")
map("<C-l>", "l", "right")
