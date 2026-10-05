vim.pack.add {
  'https://github.com/Wansmer/treesj',
}

vim.cmd.packadd('treesj')

local treesj = require('treesj')
local lang_utils = require('treesj.langs.utils')

-- Current TypeScript parsers use interface_body rather than object_type.
-- Keep JavaScript's array/object declaration targets alongside TypeScript's.
local typescript = {
  interface_body = lang_utils.set_preset_for_dict({
    both = { separator = ';', last_separator = true },
  }),
  interface_declaration = { target_nodes = { 'interface_body', 'object_type' } },
  lexical_declaration = {
    target_nodes = { 'array', 'object', 'object_type', 'statement_block' },
  },
  export_statement = {
    target_nodes = { 'export_clause', 'array', 'object', 'object_type', 'interface_body', 'statement_block' },
  },
}

treesj.setup {
  -- Default Space m/j/s mappings overlap with Markdown and search shortcuts.
  use_default_keymaps = false,
  langs = {
    typescript = vim.deepcopy(typescript),
    tsx = vim.deepcopy(typescript),
  },
}

-- Vue directives inject TypeScript trees whose parents stop at the expression.
-- If that expression has no TreeSJ target, continue from its enclosing Vue tag.
-- Hook node selection so commands, mappings, and dot-repeat share the fallback.
local format = require('treesj.format')
format._vue_original_get_node_at_cursor = format._vue_original_get_node_at_cursor or format.get_node_at_cursor
local get_node_at_cursor = format._vue_original_get_node_at_cursor
format.get_node_at_cursor = function(parser)
  local node = get_node_at_cursor(parser)
  if parser:lang() ~= 'vue' or not node then return node end

  local configured = pcall(require('treesj.search').get_configured_node, node)
  if configured then return node end

  local outer = vim.treesitter.get_node({ ignore_injections = true })
  while outer do
    if outer:type() == 'start_tag' or outer:type() == 'self_closing_tag' then
      return outer
    end
    outer = outer:parent()
  end
  return node
end

vim.keymap.set('n', '<leader>tm', treesj.toggle, { desc = 'Toggle split/join code block' })
vim.keymap.set('n', '<leader>ts', treesj.split, { desc = 'Split code block' })
vim.keymap.set('n', '<leader>tj', treesj.join, { desc = 'Join code block' })
vim.keymap.set('n', '<leader>tM', function()
  treesj.toggle({ split = { recursive = true } })
end, { desc = 'Toggle split/join code block recursively' })

-- Leave Visual mode before editing; TreeSJ targets the block at the cursor.
vim.keymap.set('x', '<leader>tm', '<Esc><Cmd>TSJToggle<CR>', { desc = 'Toggle split/join code block' })
vim.keymap.set('x', '<leader>ts', '<Esc><Cmd>TSJSplit<CR>', { desc = 'Split code block' })
vim.keymap.set('x', '<leader>tj', '<Esc><Cmd>TSJJoin<CR>', { desc = 'Join code block' })
vim.keymap.set('x', '<leader>tM', "<Esc><Cmd>lua require('treesj').toggle({ split = { recursive = true } })<CR>", {
  desc = 'Toggle split/join code block recursively',
})
