local gh = require 'gh'

vim.pack.add { gh 'nvim-mini/mini.nvim' }

if vim.g.have_nerd_font then
  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()
end

require('mini.ai').setup {
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  n_lines = 500,
}

require('mini.surround').setup()
-- require('mini.pairs').setup()

local statusline = require('mini.statusline')
statusline.section_location = function()
  return '%2l:%-2v'
end

local function sync_location_highlight(mode_hl)
  local mode = vim.api.nvim_get_hl(0, { name = mode_hl })
  local location = vim.api.nvim_get_hl(0, { name = 'MiniStatuslineFileinfo' })
  location.fg = mode.fg
  location.bg = mode.bg
  location.bold = true
  vim.api.nvim_set_hl(0, 'MiniStatuslineLocation', location)
end

statusline.setup {
  content = {
    active = function()
      local mode, mode_hl = statusline.section_mode { trunc_width = math.huge }
      sync_location_highlight(mode_hl)
      local git = statusline.section_git { trunc_width = 40 }
      local diff = statusline.section_diff { trunc_width = 75 }
      local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
      local lsp = statusline.section_lsp { trunc_width = 75 }
      local filename = statusline.section_filename { trunc_width = 140 }
      local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
      local location = statusline.section_location { trunc_width = 75 }
      local search = statusline.section_searchcount { trunc_width = 75 }

      return statusline.combine_groups {
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
        '%<',
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=',
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = 'MiniStatuslineLocation', strings = { search, location } },
      }
    end,
  },
  use_icons = vim.g.have_nerd_font,
}

local mode_groups = {
  'MiniStatuslineModeNormal',
  'MiniStatuslineModeInsert',
  'MiniStatuslineModeVisual',
  'MiniStatuslineModeReplace',
  'MiniStatuslineModeCommand',
  'MiniStatuslineModeOther',
}

for _, group in ipairs(mode_groups) do
  vim.api.nvim_set_hl(0, group, vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = group }), { bold = true }))
end
