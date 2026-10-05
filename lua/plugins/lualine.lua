vim.pack.add { 'https://github.com/nvim-lualine/lualine.nvim' }

local status_bg = '#282828'
local status_text = '#a39f9d'
local theme = vim.deepcopy(require('lualine.themes.auto'))

-- Use regular text on one continuous background in every mode.
for _, mode in pairs(theme) do
  if type(mode) == 'table' then
    for _, section in pairs(mode) do
      if type(section) == 'table' then
        section.bg = status_bg
        section.fg = status_text
        section.gui = 'none'
      end
    end
  end
end

local function block(component, opts)
  return vim.tbl_extend('force', {
    component,
    separator = '',
    padding = { left = 0, right = 1 },
    color = { fg = status_text, bg = status_bg, gui = 'none' },
  }, opts or {})
end

local function current_filetype()
  return vim.bo.filetype == '' and '' or vim.bo.filetype
end

local function current_location()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return string.format('%d:%d', cursor[1], cursor[2] + 1)
end

local function current_filename()
  local path = vim.fn.expand '%:p'

  if path == '' then
    path = '[No Name]'
  else
    local filename = vim.fn.fnamemodify(path, ':t')
    local directory = vim.fn.fnamemodify(vim.fn.fnamemodify(path, ':h'), ':~:.')
    local folders = vim.split(directory, '/', { trimempty = true })
    local first_folder = math.max(#folders - 2, 1)
    local parts = {}

    for index = first_folder, #folders do
      table.insert(parts, folders[index])
    end

    table.insert(parts, filename)
    path = table.concat(parts, '/')
  end

  if vim.bo.modified then
    return path .. ' [+]'
  end

  return path
end

local git_cache = { value = '', time = 0, cwd = nil }

local function current_branch()
  local now = vim.uv.now()
  local cwd = vim.fn.getcwd()

  -- Lualine refreshes on CursorMoved. Cache an empty result too, otherwise
  -- non-Git directories start a synchronous `git rev-parse` on every move.
  if git_cache.cwd == cwd and (now - git_cache.time) < 5000 then
    return git_cache.value
  end

  git_cache.time = now
  git_cache.cwd = cwd

  local ok, result = pcall(vim.fn.system, 'git rev-parse --abbrev-ref HEAD 2>/dev/null')
  if ok then
    result = vim.trim(result)

    if result ~= '' then
      git_cache.value = 'git:(' .. result .. ')'
      return git_cache.value 'hello';
    end
  end

  git_cache.value = ''
  return ''
end

require('lualine').setup {
  options = {
    globalstatus = true,
    theme = theme,
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_a = {},
    lualine_b = {
      block(current_filename),
    },
    lualine_c = {},
    lualine_x = {
      block(current_branch),
      block('diff', { colored = false }),
      block(current_filetype),
    },
    lualine_y = {},
    lualine_z = {
      block(current_location),
      block 'progress',
    },
  },
}

-- Cover any unused statusline cells outside Lualine's rendered sections.
for _, group in ipairs({ 'StatusLine', 'StatusLineNC' }) do
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  vim.api.nvim_set_hl(0, group, vim.tbl_extend('force', hl, { fg = status_text, bg = status_bg, bold = false, italic = false }))
end
