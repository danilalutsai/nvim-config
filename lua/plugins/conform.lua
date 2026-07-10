local gh = require 'gh'

vim.pack.add { gh 'stevearc/conform.nvim' }
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

vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  require('conform').format { async = true }
end, { desc = '[F]ormat buffer' })
