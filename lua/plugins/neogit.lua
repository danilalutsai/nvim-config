local gh = require "gh"

vim.pack.add {
  gh "NeogitOrg/neogit",
}

require("neogit").setup({
  kind = "replace",

  highlight = {
    -- Added changes: same colors in every state
    -- green = "#a6e3a1",
    -- bg_green = "#a6e3a1",
    line_green = "#243b2a",
    inline_green = "#243b2a",

    -- Deleted changes: same colors in every state
    -- red = "#f38ba8",
    -- bg_red = "#f38ba8",
    line_red = "#432a35",
    inline_red = "#432a35",

    bold = false,
    italic = false,
  },
  integrations = {
    telescope = true,
  },
  mappings = {
    popup = {
      ["R"] = "RemotePopup",
      ["M"] = "MarginPopup",
      ["L"] = "LogPopup",
      ["l"] = false,
    },
    status = {
      ["R"] = false,
    },
  },
})

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", {
  desc = "Open Neogit",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NeogitHjklNavigation", { clear = true }),
  pattern = "Neogit*",
  callback = function(event)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(event.buf) then
        return
      end

      local keys = {
        h = "h",
        j = "j",
        k = "k",
        l = "l",
      }

      for lhs, rhs in pairs(keys) do
        vim.keymap.set({ "n", "x" }, lhs, rhs, {
          buffer = event.buf,
          noremap = true,
          silent = true,
          nowait = true,
        })
      end
    end)
  end,
})
