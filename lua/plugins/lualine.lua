local gh = require 'gh'

vim.pack.add { gh 'nvim-lualine/lualine.nvim' }

local colors = {
  base = '#191724',
  status = '#1f1d2e',
  muted = '#6e6a86',
  text = '#908caa',
  love = '#eb6f92',
  gold = '#f6c177',
  rose = '#ebbcba',
  pine = '#31748f',
  foam = '#9ccfd8',
  iris = '#c4a7e7',
}

local rose_pine_status = {
  normal = {
    a = { fg = colors.base, bg = colors.rose, gui = 'bold' },
    b = { fg = colors.text, bg = colors.status },
    c = { fg = colors.text, bg = colors.status },
  },
  insert = {
    a = { fg = colors.base, bg = colors.foam, gui = 'bold' },
    b = { fg = colors.text, bg = colors.status },
    c = { fg = colors.text, bg = colors.status },
  },
  visual = {
    a = { fg = colors.base, bg = colors.iris, gui = 'bold' },
    b = { fg = colors.text, bg = colors.status },
    c = { fg = colors.text, bg = colors.status },
  },
  replace = {
    a = { fg = colors.base, bg = colors.love, gui = 'bold' },
    b = { fg = colors.text, bg = colors.status },
    c = { fg = colors.text, bg = colors.status },
  },
  command = {
    a = { fg = colors.base, bg = colors.gold, gui = 'bold' },
    b = { fg = colors.text, bg = colors.status },
    c = { fg = colors.text, bg = colors.status },
  },
  inactive = {
    a = { fg = colors.muted, bg = colors.status },
    b = { fg = colors.muted, bg = colors.status },
    c = { fg = colors.muted, bg = colors.status },
  },
}

local function block(component, opts)
  return vim.tbl_extend('force', {
    component,
    separator = '',
    padding = { left = 0, right = 1 },
  }, opts or {})
end

local function current_filetype()
  return vim.bo.filetype == '' and '' or vim.bo.filetype
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
    return ' ' .. path .. ' [+]'
  end

  return ' ' .. path
end

local git_cache = { value = '', time = 0 }

local function current_branch()
  local now = vim.uv.now()

  if git_cache.value ~= '' and (now - git_cache.time) < 5000 then
    return git_cache.value
  end

  git_cache.time = now

  local ok, result = pcall(vim.fn.system, 'git rev-parse --abbrev-ref HEAD 2>/dev/null')
  if ok then
    result = vim.trim(result)

    if result ~= '' then
      git_cache.value = 'git:(' .. result .. ')'
      return git_cache.value
    end
  end

  git_cache.value = ''
  return ''
end

require('lualine').setup {
  options = {
    globalstatus = true,
    theme = rose_pine_status,
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_a = {},
    lualine_b = {
      block(current_filename, { color = { fg = colors.text, bg = colors.status } }),
    },
    lualine_c = {},
    lualine_x = {
      block(current_branch),
      block 'diff',
      block(current_filetype),
    },
    lualine_y = {},
    lualine_z = {
      block('progress', { color = { fg = colors.text, bg = colors.status } }),
      block('location', { padding = { left = 0, right = 1 }, color = { fg = colors.text, bg = colors.status } }),
    },
  },
}
