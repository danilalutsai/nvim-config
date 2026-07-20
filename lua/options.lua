  do
  vim.loader.enable()

    vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"

    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    vim.g.have_nerd_font = true

  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.numberwidth = 4
  vim.o.statuscolumn = ' %{v:virtnum == 0 ? (v:relnum == 0 ? v:lnum : " ") : ""}%=%{v:virtnum == 0 && v:relnum != 0 ? v:relnum : ""} '

  local function clear_special_buffer_columns()
    local filetype = vim.bo.filetype:lower()
    local bufname = vim.api.nvim_buf_get_name(0):lower()

    if (vim.bo.buftype == "help" or filetype == "help") and bufname:find("fugitive", 1, true) then
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.statuscolumn = " "
    end
  end

  vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter", "WinEnter" }, {
    group = vim.api.nvim_create_augroup("SpecialBufferColumns", { clear = true }),
    callback = function()
      vim.schedule(clear_special_buffer_columns)
    end,
  })

  vim.o.textwidth = 0
  vim.o.colorcolumn = '81'
  vim.opt.formatoptions:remove({ 't', 'c' })

  vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("DisableAutoTextWrap", { clear = true }),
    callback = function()
      vim.opt_local.textwidth = 0
      vim.opt_local.formatoptions:remove({ 't', 'c' })
    end,
  })

  vim.o.mouse = 'a'
  vim.o.showmode = false
  vim.opt.guicursor = 'n-v-c-sm:block-blinkon0-blinkoff0,i-ci-ve:ver25-blinkon0-blinkoff0,r-cr-o:hor20-blinkon0-blinkoff0,t:block-blinkon0-blinkoff0-TermCursor'

  -- Smart automatic code folding using Tree-sitter
  function _G.treesitter_foldexpr()
    local bufnr = vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(bufnr) then
      return "0"
    end

    local ok, result = pcall(vim.treesitter.foldexpr)
    return ok and result or "0"
  end

  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "v:lua.treesitter_foldexpr()"
  vim.o.foldenable = true
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.foldcolumn = "0"
  vim.o.foldminlines = 1
  vim.o.foldtext = 'v:lua.fold_text()'
  vim.opt.fillchars:append({ fold = ' ' })

  function _G.fold_text()
    local line = vim.fn.getline(vim.v.foldstart):gsub('^%s+', '')
    local folded_lines = vim.v.foldend - vim.v.foldstart + 1

    return {
      { line .. '  ', 'Folded' },
      { 'ᐅ  ', 'FoldArrow' },
      { ('%d lines folded'):format(folded_lines), 'Folded' },
    }
  end

  function _G.toggle_line_start()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local first_non_blank = line:find('%S')

    if first_non_blank == nil then
      vim.api.nvim_win_set_cursor(0, { row, 0 })
      return
    end

    local first_non_blank_col = first_non_blank - 1
    local target_col = col == first_non_blank_col and 0 or first_non_blank_col

    vim.api.nvim_win_set_cursor(0, { row, target_col })
  end

  function _G.toggle_line_start_motion()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.fn.getline(row)
    local first_non_blank = line:find('%S')

    if first_non_blank == nil then
      return '0'
    end

    local first_non_blank_col = first_non_blank - 1

    return col == first_non_blank_col and '0' or '^'
  end

  vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
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
  vim.o.autoindent = true
  vim.o.smartindent = true
  vim.o.expandtab = true
  vim.o.tabstop = 2
  vim.o.softtabstop = 2
  vim.o.shiftwidth = 2

  vim.opt.listchars = {
    tab = '» ',
    leadmultispace = '» ',
    trail = '·',
    nbsp = '␣',
  }

  vim.o.inccommand = 'split'
  vim.o.cursorline = false
  vim.o.scrolloff = 10

  vim.o.confirm = true
end
