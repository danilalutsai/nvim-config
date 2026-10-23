vim.pack.add { 'https://github.com/stevearc/conform.nvim' }
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local enabled_filetypes = {}
    if enabled_filetypes[vim.bo[bufnr].filetype] then
      return { timeout_ms = 500 }
    else
      return nil
    end
  end,
  default_format_opts = {
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    json = { 'prettierd', 'prettier', stop_after_first = true },
    jsonc = { 'prettierd', 'prettier', stop_after_first = true },
    json5 = { 'prettierd', 'prettier', stop_after_first = true },
    html = { 'prettierd', 'prettier', stop_after_first = true },
    vue = { 'prettierd', 'prettier', stop_after_first = true },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    c = { 'clang_format' },
    -- ruff_organize_imports sorts, ruff_format rewrites. Both ship inside the
    -- same ruff binary mason installs for the LSP.
    python = { 'ruff_organize_imports', 'ruff_format' },
  },
}

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('JsonConformEqualFormat', { clear = true }),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function(event)
    local format = function()
      require('conform').format {
        bufnr = event.buf,
        async = true,
        lsp_format = 'fallback',
      }
    end

    vim.keymap.set({ 'n', 'x' }, '=', format, {
      buffer = event.buf,
      desc = 'Format JSON with Conform',
    })
  end,
})

vim.keymap.set('n', '<leader>f', function()
  require('conform').format { async = true }
end, { desc = '[F]ormat buffer' })

vim.keymap.set('x', '<leader>f', function()
  local mode = vim.api.nvim_get_mode().mode
  local start = vim.fn.getpos('v')
  local finish = vim.fn.getpos('.')
  local start_row, start_col = start[2], start[3]
  local end_row, end_col = finish[2], finish[3]

  if end_row < start_row or (end_row == start_row and end_col < start_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  if mode == 'V' then
    start_col = 1
    end_col = math.max(1, #vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, true)[1])
  end

  require('conform').format {
    async = true,
    range = {
      start = { start_row, start_col - 1 },
      ['end'] = { end_row, end_col - 1 },
    },
  }
end, { desc = 'Format selection' })
