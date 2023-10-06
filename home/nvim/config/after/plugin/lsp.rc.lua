local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  return
end

local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
  return
end

mason.setup()

local mason_config_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_config_status_ok then
  return
end

mason_lspconfig.setup({
  automatic_installation = true,
  ensure_installed = { "lua_ls", "tsserver", "terraformls", "rust_analyzer", "clangd", "astro" },
})

function _G.lsp_organize_imports_sync(bufnr)
  if not bufnr then
    bufnr = vim.api.nvim_get_current_buf()
  end
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  }

  vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", params, 1000)
end

local on_attach = function(client, bufnr)
  local wk_status_ok, wk = pcall(require, "which-key")
  if wk_status_ok then
    wk.register({
      a = { "<cmd>lua vim.lsp.buf.code_action({apply = true})<CR>", "Code Action" },
      -- d = { "<cmd>Lspsaga show_line_diagnostics<CR>", "Show Diagnostics" },
      e = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next Error" },
      E = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Prev Error" },
      f = { "<cmd>lua vim.lsp.buf.format { async = true }<CR>", "Format" },
      i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation" },
      r = { "<cmd>lua vim.lsp.buf.references()<CR>", "References" },
      s = { "<cmd>Telescope lsp_document_symbols<CR>", "Symbols" },
      t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Type Definition" },
      [";"] = { "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Workspace Symbol" },
      o = { "<cmd>lua lsp_organize_imports_sync()<CR>,", "Organize Imports" },
    }, { prefix = ";" })
  end

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gr", "<cmd>Lspsaga finder<CR>", { silent = true })
  vim.keymap.set("n", "gR", "<cmd>Lspsaga rename<CR>", bufopts)
  vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", bufopts)

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  -- vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

  -- see details here: https://github.com/neovim/nvim-lspconfig/issues/1891#issuecomment-1157964108
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_command([[augroup Format]])
    vim.api.nvim_command([[autocmd! * <buffer>]])
    vim.api.nvim_command([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
    -- vim.api.nvim_command [[autocmd BufWritePre <buffer> lua lsp_organize_imports_sync()]]
    vim.api.nvim_command([[augroup END]])
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_cmp_ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

capabilities.textDocument.completion.completionItem.snippetSupport = true

mason_lspconfig.setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
  ["lua_ls"] = function()
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT)
            version = "LuaJIT",
            -- Setup your lua path
            -- path = runtime_path,
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end,

  ["tsserver"] = function()
    lspconfig.tsserver.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript" },
      commands = {
        OrganizeImports = {
          function()
            vim.lsp.buf.execute_command({
              command = "_typescript.organizeImports",
              arguments = { vim.api.nvim_buf_get_name(0) },
            })
          end,
        },
      },
    })
  end,

  ["rust_analyzer"] = function()
    require("rust-tools").setup({
      server = {
        on_attach = on_attach,
        capabilities = capabilities,
      },
    })
  end,
  ["astro"] = function()
    lspconfig.astro.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
})
