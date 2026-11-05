--   Review and replace: step through matches, accept them 
--   one by one or all at once.

--   <leader>rn  normal: active search (highlight on) if any, 
--   else word under cursor
--   visual: the selected text, literally
--
--   While reviewing (keys are read directly, no temporary mappings):

--   Ctrl+y accept
--   Ctrl+a all
--   Ctrl+n next
--   Ctrl+p / p back
--   Esc finish

local M = {}
local marks_ns = vim.api.nvim_create_namespace('SearchReplaceMarks')
local focus_ns = vim.api.nvim_create_namespace('SearchReplaceFocus')

local actions = {
  [vim.keycode('<C-y>')] = 'accept',
  [vim.keycode('<C-a>')] = 'all',
  [vim.keycode('<C-n>')] = 'next',
  [vim.keycode('<C-p>')] = 'back',
  p = 'back',
  [vim.keycode('<Esc>')] = 'stop',
}

-- Returns the pattern to search for and a readable label, or nil.
local function pick_pattern(text)
  if text then
    if text:find('\n') then
      vim.notify('Select text within a single line.', vim.log.levels.WARN)
      return nil
    end
    return [[\V]] .. vim.fn.escape(text, [[\]]), text
  end
  -- A search you can still see highlighted wins; after <Esc> clears it, the word under cursor.
  local search = vim.fn.getreg('/')
  if vim.v.hlsearch == 1 and search ~= '' then
    return search, '/' .. search
  end
  local word = vim.fn.expand('<cword>')
  if word == '' then return nil end
  return [[\V\<]] .. vim.fn.escape(word, [[\]]) .. [[\>]], word
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

local function review(buf, matches, replacement)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local index, left = nil, #matches
  for i, match in ipairs(matches) do
    -- Extmarks keep positions right as earlier matches on the line change length.
    match.mark = vim.api.nvim_buf_set_extmark(buf, marks_ns, match.lnum - 1, match.byteidx, {})
    -- Start at the match under the cursor, or the next one after it.
    if not index and (match.lnum > cursor[1]
      or (match.lnum == cursor[1] and match.byteidx + #match.text > cursor[2])) then
      index = i
    end
  end
  index = index or 1

  local function position(match)
    return vim.api.nvim_buf_get_extmark_by_id(buf, marks_ns, match.mark, {})
  end

  local function replace(match)
    local row, col = unpack(position(match))
    vim.api.nvim_buf_set_text(buf, row, col, row, col + #match.text, { replacement })
    match.done = true
    left = left - 1
  end

  local function step(direction)
    for _ = 1, #matches do
      index = (index - 1 + direction) % #matches + 1
      if not matches[index].done then return end
    end
  end

  while left > 0 do
    local match = matches[index]
    local row, col = unpack(position(match))
    vim.api.nvim_win_set_cursor(0, { row + 1, col })
    vim.cmd('normal! zv')
    vim.api.nvim_buf_set_extmark(buf, focus_ns, row, col, {
      end_col = col + #match.text, hl_group = 'IncSearch', priority = 250,
    })
    vim.cmd.redraw()
    vim.api.nvim_echo({ { ('Replace %d/%d → %s   ^Y accept  ^A all  ^N next  ^P/p back  Esc finish')
      :format(index, #matches, replacement) } }, false, {})

    -- Ctrl+c raises an interrupt: treat it like Esc.
    local ok, key = pcall(vim.fn.getcharstr)
    vim.api.nvim_buf_clear_namespace(buf, focus_ns, 0, -1)
    local action = ok and actions[key] or (not ok and 'stop')

    if action == 'accept' then
      replace(match)
      step(1)
    elseif action == 'all' then
      for _, item in ipairs(matches) do
        if not item.done then replace(item) end
      end
    elseif action == 'next' then
      step(1)
    elseif action == 'back' then
      step(-1)
    elseif action == 'stop' then
      break
    end
  end

  vim.api.nvim_buf_clear_namespace(buf, marks_ns, 0, -1)
  vim.api.nvim_echo({ { ('Replaced %d of %d.'):format(#matches - left, #matches) } }, false, {})
end

-- text: literal string to replace (from a visual selection); nil picks search or word.
function M.start(text)
  local buf = vim.api.nvim_get_current_buf()
  if not vim.bo[buf].modifiable then return end
  local pattern, label = pick_pattern(text)
  if not pattern then return end

  local ok, matches = pcall(collect, buf, pattern)
  if not ok then
    vim.notify(matches, vim.log.levels.WARN)
    return
  end
  if #matches == 0 then
    vim.notify(('No matches for %s.'):format(label), vim.log.levels.INFO)
    return
  end

  vim.ui.input({ prompt = ('Replace %s with: '):format(label) }, function(replacement)
    if replacement == nil or vim.api.nvim_get_current_buf() ~= buf then return end
    if replacement:find('[\r\n]') then
      vim.notify('Enter a single-line replacement.', vim.log.levels.WARN)
      return
    end
    review(buf, matches, replacement)
  end)
end

return M
