-- Automatic symbol highlighting is disabled because it can cause frequent redraws
-- while the cursor is idle in TypeScript buffers.
local enable_document_highlight = false

-- LSP keymaps triggered when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, {
        buffer = event.buf,
        desc = "LSP: " .. desc,
      })
    end

    -- Normal hover popup
    map("K", vim.lsp.buf.hover, "Hover documentation")

    -- Open hover documentation in a normal split window
    map("gK", function()
      local bufnr = event.buf

      local clients = vim.lsp.get_clients({
        bufnr = bufnr,
        method = "textDocument/hover",
      })

      if #clients == 0 then
        vim.notify("No LSP hover documentation available", vim.log.levels.WARN)
        return
      end

      local client = clients[1]

      local params = vim.lsp.util.make_position_params(
        0,
        client.offset_encoding
      )

      client:request("textDocument/hover", params, function(err, result)
        if err then
          vim.notify(err.message or "LSP hover request failed", vim.log.levels.ERROR)
          return
        end

        if not result or not result.contents then
          vim.notify("No documentation available", vim.log.levels.INFO)
          return
        end

        local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)

        -- Remove empty lines only at the beginning and end
        while #lines > 0 and lines[1] == "" do
          table.remove(lines, 1)
        end

        while #lines > 0 and lines[#lines] == "" do
          table.remove(lines)
        end

        if #lines == 0 then
          vim.notify("No documentation available", vim.log.levels.INFO)
          return
        end

        vim.schedule(function()
          -- Open a horizontal split at the bottom
          vim.cmd("botright new")

          local doc_buf = vim.api.nvim_get_current_buf()

          vim.api.nvim_buf_set_name(doc_buf, "LSP Documentation")
          vim.api.nvim_buf_set_lines(doc_buf, 0, -1, false, lines)

          vim.bo[doc_buf].buftype = "nofile"
          vim.bo[doc_buf].bufhidden = "wipe"
          vim.bo[doc_buf].swapfile = false
          vim.bo[doc_buf].filetype = "markdown"
          vim.bo[doc_buf].modifiable = false

          vim.wo.number = false
          vim.wo.relativenumber = false
          vim.wo.wrap = true
          vim.wo.cursorline = false

          -- Close only the documentation split
          vim.keymap.set("n", "q", "<cmd>close<CR>", {
            buffer = doc_buf,
            silent = true,
            desc = "Close documentation",
          })
        end)
      end, bufnr)
    end, "Documentation in split")

    map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
    map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    -- Organize / remove unused imports (very handy in React files)
    map("<leader>co", function()
      vim.lsp.buf.code_action({
        apply = true,
        context = { only = { "source.organizeImports" }, diagnostics = {} },
      })
    end, "[C]ode [O]rganize imports")

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if enable_document_highlight and client and client:supports_method("textDocument/documentHighlight", event.buf) then
      local highlight_augroup =
        vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()

          vim.api.nvim_clear_autocmds({
            group = "kickstart-lsp-highlight",
            buffer = event2.buf,
          })
        end,
      })
    end

    if client and client:supports_method("textDocument/inlayHint", event.buf) then
      map("<leader>ih", function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
        )
      end, "[T]oggle Inlay [H]ints")
    end
  end,
})

-- Shared inlay hint settings for both the typescript and javascript sections
local ts_inlay_hints = {
  includeInlayParameterNameHints = "literal",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = false,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

local servers = {
  -- Handles .js .jsx .ts .tsx — including all JSX tag and prop completion
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },

    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },

    root_markers = {
      "tsconfig.json",
      "jsconfig.json",
      "package.json",
      ".git",
    },

    settings = {
      typescript = {
        inlayHints = ts_inlay_hints,
        preferences = {
          -- Auto-insert the closing JSX tag and quote style for props
          jsxAttributeCompletionStyle = "auto",
          includePackageJsonAutoImports = "auto",
        },
        updateImportsOnFileMove = { enabled = "always" },
      },

      javascript = {
        inlayHints = ts_inlay_hints,
        preferences = {
          jsxAttributeCompletionStyle = "auto",
        },
        updateImportsOnFileMove = { enabled = "always" },
      },
    },
  },

  -- HTML-style abbreviation expansion, JSX-aware (emits className, not class)
  emmet_language_server = {
    cmd = { "emmet-language-server", "--stdio" },

    filetypes = {
      "html",
      "css",
      "scss",
      "less",
      "javascriptreact",
      "typescriptreact",
    },

    root_markers = { "package.json", ".git" },

    init_options = {
      showExpandedAbbreviation = "always",
      showAbbreviationSuggestions = true,
      showSuggestionsAsSnippets = true,
      preferences = {},
      syntaxProfiles = {},
      variables = {},
    },
  },

  html = {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html" },
  },

  cssls = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
  },

  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false

      if client.workspace_folders then
        local path = client.workspace_folders[1].name

        if path ~= vim.fn.stdpath("config")
          and (
            vim.uv.fs_stat(path .. "/.luarc.json")
            or vim.uv.fs_stat(path .. "/.luarc.jsonc")
          )
        then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
        runtime = {
          version = "LuaJIT",
          path = { "lua/?.lua", "lua/?/init.lua" },
        },

        workspace = {
          checkThirdParty = false,
          library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
            "${3rd}/luv/library",
            "${3rd}/busted/library",
          }),
        },
      })
    end,

    settings = {
      Lua = {
        format = {
          enable = false,
        },
      },
    },
  },
}

-- Formatters (stylua, prettierd) are NOT language servers.
-- They belong here in the installer list, but never in the `servers` table above.
require("mason-tool-installer").setup({
  ensure_installed = {
    "typescript-language-server",
    "emmet-language-server",
    "html-lsp",
    "css-lsp",
    "prettierd",
    "stylua",
    "lua-language-server",
  },
})

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end

-- Hide inline messages and underlines for unused TypeScript code,
-- while keeping its normal faded foreground color.

local unused_ts_codes = {
  ["6133"] = true, -- variable/value declared but never read
  ["6196"] = true, -- type, interface, enum, etc. declared but never used
  ["6192"] = true, -- all imports in an import declaration are unused
  ["6198"] = true, -- all destructured elements are unused
  ["6138"] = true, -- property declared but never read
}

local function is_unused(diagnostic)
  if unused_ts_codes[tostring(diagnostic.code)] then
    return true
  end

  -- Also support LSP diagnostics explicitly tagged as unnecessary.
  return diagnostic._tags and diagnostic._tags.unnecessary
end

local original_virtual_text = vim.diagnostic.handlers.virtual_text

vim.diagnostic.handlers.virtual_text = {
  show = function(namespace, bufnr, diagnostics, opts)
    local filtered = vim.tbl_filter(function(diagnostic)
      return not is_unused(diagnostic)
    end, diagnostics)

    original_virtual_text.show(namespace, bufnr, filtered, opts)
  end,

  hide = original_virtual_text.hide,
}

local original_underline = vim.diagnostic.handlers.underline
local unused_fade_namespace = vim.api.nvim_create_namespace("unused-code-fade")

vim.diagnostic.handlers.underline = {
  show = function(namespace, bufnr, diagnostics, opts)
    -- Render Neovim's normal underlines for every diagnostic except unused code.
    local normal_diagnostics = vim.tbl_filter(function(diagnostic)
      return not is_unused(diagnostic)
    end, diagnostics)

    original_underline.show(namespace, bufnr, normal_diagnostics, opts)

    -- Apply only DiagnosticUnnecessary to unused ranges: this keeps the faded
    -- foreground color without combining it with an underline highlight.
    vim.api.nvim_buf_clear_namespace(bufnr, unused_fade_namespace, 0, -1)

    for _, diagnostic in ipairs(diagnostics) do
      if is_unused(diagnostic) then
        vim.hl.range(
          bufnr,
          unused_fade_namespace,
          "DiagnosticUnnecessary",
          { diagnostic.lnum, diagnostic.col },
          {
            diagnostic.end_lnum or diagnostic.lnum,
            diagnostic.end_col or (diagnostic.col + 1),
          },
          { priority = vim.hl.priorities.diagnostics }
        )
      end
    end
  end,

  hide = function(namespace, bufnr)
    original_underline.hide(namespace, bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, unused_fade_namespace, 0, -1)
  end,
}
