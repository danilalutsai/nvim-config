local M = {}
local ns = vim.api.nvim_create_namespace('SearchReplaceReview')
local session
local keys = { '<C-n>', '<C-p>', '<C-y>', '<Esc>' }

function M.stop()
  if not session then return end
  local previous = session
  session = nil
  vim.api.nvim_del_augroup_by_id(previous.group)
  if vim.api.nvim_buf_is_valid(previous.buf) then
    vim.api.nvim_buf_clear_namespace(previous.buf, ns, 0, -1)
    vim.api.nvim_buf_clear_namespace(previous.buf, previous.focus_ns, 0, -1)
    for _, key in ipairs(keys) do
      pcall(vim.keymap.del, 'n', key, { buffer = previous.buf })
      local mapping = previous.maps[key]
      if mapping then
        vim.api.nvim_buf_call(previous.buf, function()
          vim.fn.mapset('n', false, mapping)
        end)
      end
    end
  end
  vim.api.nvim_echo({ { 'Replacement review finished; accepted changes kept.' } }, false, {})
end

local function valid()
  if not session then return false end
  if vim.api.nvim_get_current_buf() ~= session.buf
    or vim.api.nvim_buf_get_changedtick(session.buf) ~= session.tick then
    M.stop()
    return false
  end
  return true
end

local function show()
  local item = session.matches[session.index]
  local position = vim.api.nvim_buf_get_extmark_by_id(session.buf, ns, item.mark, {})
  vim.api.nvim_win_set_cursor(0, { position[1] + 1, position[2] })
  vim.cmd('normal! zv')
  vim.api.nvim_buf_clear_namespace(session.buf, session.focus_ns, 0, -1)
  vim.api.nvim_buf_set_extmark(session.buf, session.focus_ns, position[1], position[2], {
    end_row = position[1], end_col = position[2] + #item.text,
    hl_group = 'IncSearch', priority = 250,
  })
  vim.api.nvim_echo({ { ('Replace %d/%d → %s   Ctrl+y accept · Ctrl+n next · Ctrl+p back · Esc finish')
    :format(session.index, #session.matches, session.replacement) } }, false, {})
end

local function move(direction)
  if not valid() then return end
  for _ = 1, #session.matches do
    session.index = (session.index - 1 + direction) % #session.matches + 1
    if not session.matches[session.index].done then
      show()
      return
    end
  end
  M.stop()
end

local function accept()
  if not valid() then return end
  local item = session.matches[session.index]
  local position = vim.api.nvim_buf_get_extmark_by_id(session.buf, ns, item.mark, {})
  vim.api.nvim_buf_set_text(session.buf, position[1], position[2], position[1],
    position[2] + #item.text, { session.replacement })
  item.done = true
  session.tick = vim.api.nvim_buf_get_changedtick(session.buf)
  move(1)
end

-- Use Vim's search engine to respect ignorecase, smartcase, and search regexes.
-- matchbufline supplies exact byte ranges, including \zs / \ze and UTF-8.
local function collect(buf, pattern)
  local by_position = {}
  for _, match in ipairs(vim.fn.matchbufline(buf, pattern, 1, '$')) do
    by_position[match.lnum .. ':' .. match.byteidx] = match
  end
  local matches = {}
  local view = vim.fn.winsaveview()
  local ok, err = pcall(function()
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    while true do
      local position = vim.fn.searchpos(pattern, 'cW', 0, 200)
      if position[1] == 0 then break end
      local match = by_position[position[1] .. ':' .. (position[2] - 1)]
      if not match or match.text == '' then
        error('Review supports nonempty matches within a single line. Use :%s//replacement/gc for multiline or empty matches.', 0)
      end
      matches[#matches + 1] = match
      local next_col = match.byteidx + #match.text
      if next_col < #vim.fn.getline(match.lnum) then
        vim.api.nvim_win_set_cursor(0, { match.lnum, next_col })
      elseif match.lnum < vim.api.nvim_buf_line_count(buf) then
        vim.api.nvim_win_set_cursor(0, { match.lnum + 1, 0 })
      else
        break
      end
    end
  end)
  vim.fn.winrestview(view)
  if not ok then error(err, 0) end
  return matches
end

function M.start()
  M.stop()
  local buf = vim.api.nvim_get_current_buf()
  if not vim.bo[buf].modifiable then return end
  local pattern = vim.fn.getreg('/')
  if pattern == '' then
    local word = vim.fn.expand('<cword>')
    if word == '' then return end
    pattern = [[\V\<]] .. vim.fn.escape(word, [[\]]) .. [[\>]]
  end
  local ok, matches = pcall(collect, buf, pattern)
  if not ok then
    vim.notify(matches, vim.log.levels.WARN)
    return
  end
  if #matches == 0 then
    vim.notify('No search matches in this buffer.', vim.log.levels.INFO)
    return
  end
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.ui.input({ prompt = ('Replace /%s/ with (Esc cancels): '):format(pattern) }, function(replacement)
    if replacement == nil then return end
    if vim.api.nvim_get_current_buf() ~= buf or vim.api.nvim_buf_get_changedtick(buf) ~= tick then return end
    if replacement:find('[\r\n]') then
      vim.notify('Enter a single-line replacement.', vim.log.levels.WARN)
      return
    end
    local focus_ns = vim.api.nvim_create_namespace('SearchReplaceCurrent')
    session = {
      buf = buf, tick = tick, matches = matches, replacement = replacement,
      index = 1, maps = {}, focus_ns = focus_ns,
      group = vim.api.nvim_create_augroup('SearchReplaceReview', { clear = true }),
    }
    for _, match in ipairs(matches) do
      match.mark = vim.api.nvim_buf_set_extmark(buf, ns, match.lnum - 1, match.byteidx, {})
    end
    for index, match in ipairs(matches) do
      if match.lnum > cursor[1] or (match.lnum == cursor[1] and match.byteidx >= cursor[2]) then
        session.index = index
        break
      end
    end
    for _, key in ipairs(keys) do
      local mapping = vim.fn.maparg(key, 'n', false, true)
      if mapping.buffer == 1 then session.maps[key] = mapping end
    end
    local opts = { buffer = buf, silent = true }
    vim.keymap.set('n', '<C-n>', function() move(1) end, opts)
    vim.keymap.set('n', '<C-p>', function() move(-1) end, opts)
    vim.keymap.set('n', '<C-y>', accept, opts)
    vim.keymap.set('n', '<Esc>', M.stop, opts)
    vim.api.nvim_create_autocmd({ 'BufLeave', 'BufWipeout', 'InsertEnter' }, {
      group = session.group, buffer = buf, callback = M.stop,
    })
    show()
  end)
end

return M
