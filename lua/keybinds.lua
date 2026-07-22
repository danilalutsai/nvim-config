do
  -- Visual mode:
  -- Select lines, then Space + Tab creates a manual fold.
  vim.keymap.set("x", "<leader><Tab>", "zf", {
    noremap = true,
    silent = true,
    desc = "Fold selected lines",
  })

  -- Folding current automatic code block
  vim.keymap.set("n", "<leader><Tab>", "za", {
    noremap = true,
    silent = true,
    desc = "Toggle current code fold",
  })

  vim.keymap.set("n", "<leader>z", "zM", {
    noremap = true,
    silent = true,
    desc = "Close all folds",
  })

  vim.keymap.set("n", "<leader>Z", "zR", {
    noremap = true,
    silent = true,
    desc = "Open all folds",
  })

  vim.keymap.set("n", "]j", "<C-i>", {
    noremap = true,
    silent = true,
    desc = "Jump forward",
  })

  vim.keymap.set("n", "[j", "<C-o>", {
    noremap = true,
    silent = true,
    desc = "Jump backward",
  })

  -- Ctrl-w, then c: close current buffer but keep Neovim open
  vim.keymap.set("n", "<C-w>c", "<cmd>bdelete<CR>", {
    noremap = true,
    silent = true,
    desc = "Delete current buffer",
  })

  -- clear search highlights when pressing <esc>
  vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')

  -- indent/outdent in visual mode
  vim.keymap.set('v', '<tab>', '>gv')
  vim.keymap.set('v', '<s-tab>', '<gv')
  vim.keymap.set('n', '<tab>', '>>')
  vim.keymap.set('n', '<s-tab>', '<<')

  -- Move current line or selected text
  vim.keymap.set('n', '<C-S-j>', '<cmd>move .+1<CR>==', { desc = 'Move line down' })
  vim.keymap.set('n', '<C-S-k>', '<cmd>move .-2<CR>==', { desc = 'Move line up' })
  vim.keymap.set('x', '<C-S-j>', ":move '>+1<CR>gv=gv", { desc = 'Move selection down' })
  vim.keymap.set('x', '<C-S-k>', ":move '<-2<CR>gv=gv", { desc = 'Move selection up' })

  local function get_visual_selection()
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.fn.getline(start_pos[2], end_pos[2])

    if #lines == 0 then return '' end

    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])

    return table.concat(lines, '\n')
  end

  local function rename_matches(mode)
    local old_name = mode == 'x' and get_visual_selection() or vim.fn.getreg('/')

    if old_name == '' and mode == 'n' then
      old_name = vim.fn.expand('<cword>')
    end

    if old_name == '' then return end

    local new_name = vim.fn.input(('Rename "%s" to: '):format(old_name))

    if new_name == '' then return end

    local pattern = vim.fn.escape(old_name, [[\/]])

    if mode == 'x' or vim.fn.getreg('/') ~= old_name then
      pattern = [[\V]] .. pattern
    end

    local replacement = vim.fn.escape(new_name, [[\&/]])

    vim.cmd(('keeppatterns %%s/%s/%s/g'):format(pattern, replacement))
  end

  vim.keymap.set('n', '<C-r>n', function()
    rename_matches('n')
  end, { desc = 'Rename word in buffer' })

  vim.keymap.set('n', '<leader>rn', function()
    rename_matches('n')
  end, { desc = 'Rename search matches in buffer' })

  vim.keymap.set('x', '<C-r>n', function()
    rename_matches('x')
  end, { desc = 'Rename selection in buffer' })

  -- Line navigation
  vim.keymap.set('n', '<S-l>', '$', { desc = 'Go to end of line' })
  vim.keymap.set('n', '<S-h>', toggle_line_start, { desc = 'Toggle line start' })
  vim.keymap.set('x', '<S-l>', '$', { desc = 'Select to end of line' })
  vim.keymap.set('x', '<S-h>', toggle_line_start_motion, {
    expr = true,
    desc = 'Select to toggled line start',
  })
  vim.keymap.set('o', '<S-l>', '$', { desc = 'To end of line' })
  vim.keymap.set('o', '<S-h>', toggle_line_start_motion, {
    expr = true,
    desc = 'To toggled line start',
  })

  -- Window commands
  vim.keymap.set('n', '<C-w>v', '<cmd>vnew<CR>', { desc = 'Open new vertical window' })
  vim.keymap.set('n', '<C-w>s', '<cmd>new<CR>', { desc = 'Open new horizontal window' })
  vim.keymap.set('n', '<C-w>x', '<cmd>close<CR>', { desc = 'Close current window' })
  vim.keymap.set('n', 'N', '<cmd>bnext<CR>', { desc = 'Go to next buffer' })
  vim.keymap.set('n', 'P', '<cmd>bprevious<CR>', { desc = 'Go to previous buffer' })
  vim.keymap.set('n', '<C-n>', 'n', { desc = 'Next search result' })
  vim.keymap.set('n', '<C-p>', 'N', { desc = 'Previous search result' })
  vim.keymap.set('n', 'zz', 'zt', { desc = 'Place current line at top' })
  -- netrw: navigate with h/l (like Oil)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'netrw',
    callback = function(event)
      vim.keymap.set('n', 'l', '<CR>', { buffer = event.buf, remap = true, desc = 'Open file or folder' })
      vim.keymap.set('n', 'h', '-', { buffer = event.buf, remap = true, desc = 'Go up folder' })
    end,
  })

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
  vim.keymap.set('n', '<leader>d', function()
    vim.diagnostic.open_float(nil, { scope = 'cursor' })
  end, { desc = 'Show diagnostic message' })

  -- Exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Jump between functions
  vim.keymap.set("n", "]f", "]m", { desc = "Next function" })
  vim.keymap.set("n", "[f", "[m", { desc = "Previous function" })

  -- Merge conflicts: choose left/ours or right/theirs
  vim.keymap.set("n", "grch", "<cmd>diffget //2<CR>", {
    desc = "Choose left conflict version",
    silent = true,
  })

  vim.keymap.set("n", "grcl", "<cmd>diffget //3<CR>", {
    desc = "Choose right conflict version",
    silent = true,
  })

  -- Merge conflicts: choose the entire file
  vim.keymap.set("n", "grcH", "<cmd>Gread //2<CR>", {
    desc = "Choose entire file from ours/left",
    silent = true,
  })

  vim.keymap.set("n", "grcL", "<cmd>Gread //3<CR>", {
    desc = "Choose entire file from theirs/right",
    silent = true,
  })

end
