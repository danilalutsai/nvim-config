-- ============================================================
-- SECTION 1: OPTIONS
-- ============================================================
do
  vim.loader.enable()

  vim.g.netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  vim.g.have_nerd_font = false

  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.mouse = 'a'
  vim.o.showmode = false

  vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
  end)

  vim.o.breakindent = true
  vim.o.undofile = true
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.signcolumn = 'no'
  vim.o.updatetime = 250
  vim.o.timeoutlen = 300
  vim.o.splitright = true
  vim.o.splitbelow = true
  vim.o.list = true

  vim.opt.listchars = {
    tab = '» ',
    leadmultispace = '» ',
    trail = '·',
    nbsp = '␣',
  }

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

  vim.o.inccommand = 'split'
  vim.o.cursorline = false
  vim.o.scrolloff = 6
  vim.o.confirm = true
end

-- Ctrl-w, then c: close current buffer but keep Neovim open
vim.keymap.set("n", "<C-w>c", "<cmd>bdelete<CR>", {
  noremap = true,
  silent = true,
  desc = "Delete current buffer",
})

-- ============================================================
-- SECTION 2: KEYMAPS
-- ============================================================
do
  -- Clear search highlights when pressing <Esc>
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')


  -- Indent/outdent in visual mode
  vim.keymap.set('v', '<Tab>', '>gv')
  vim.keymap.set('v', '<S-Tab>', '<gv')
  vim.keymap.set('n', '<Tab>', '>>')
  vim.keymap.set('n', '<S-Tab>', '<<')

  -- Buffer navigation
  vim.keymap.set('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
  vim.keymap.set('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })

  -- Close window
  vim.keymap.set('n', '<C-w>x', '<cmd>close<CR>', { desc = 'Close current window' })

  -- netrw: navigate with h/l (like Oil)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'netrw',
    callback = function(event)
      vim.keymap.set('n', 'l', '<CR>', { buffer = event.buf, remap = true, desc = 'Open file or folder' })
      vim.keymap.set('n', 'h', '-', { buffer = event.buf, remap = true, desc = 'Go up folder' })
    end,
  })

  -- Diagnostic config
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_text = true,
    virtual_lines = false,
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Window navigation
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- Jump between functions
vim.keymap.set("n", "]f", "]m", { desc = "Next function" })
vim.keymap.set("n", "[f", "[m", { desc = "Previous function" })

  -- Highlight when yanking text
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.hl.on_yank()
    end,
  })
end

-- ============================================================
-- SECTION 3: PLUGIN BUILD HOOKS
-- vim.pack auto-build for telescope-fzf, LuaSnip, treesitter
-- ============================================================
do
  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then
          run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
        end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
      end
    end,
  })
end


-- ============================================================
-- SECTION 4: PLUGIN LOADER
-- Each plugin's add + setup lives in lua/plugins/<name>.lua
-- ============================================================
require('plugins')

