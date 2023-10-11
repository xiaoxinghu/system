-- https://github.com/williamboman/mason.nvim/discussions/92#discussioncomment-3173425
-- https://www.reddit.com/r/neovim/comments/w9vvf5/moving_to_masonnvim/
-- https://github.com/williamboman/mason.nvim/discussions/57
local M = {}

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

mason.setup()

mason_lspconfig.setup({
	ensure_installed = { "lua_ls", "tsserver", "terraformls", "rust_analyzer", "clangd" },
})

require("user.lsp.ui")
require("user.lsp.null-ls")
local handlers = require("user.lsp.handlers")

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

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

-- setup handlers
mason_lspconfig.setup_handlers({
	function(server_name)
		lspconfig[server_name].setup({
			on_attach = handlers.on_attach,
			capabilities = handlers.capabilities,
		})
	end,
	["lua_ls"] = function()
		lspconfig.lua_ls.setup({
			on_attach = handlers.on_attach,
			capabilities = handlers.capabilities,
			settings = {
				Lua = {
					-- runtime = {
					--   -- Tell the language server which version of Lua you're using (most likely LuaJIT)
					--   version = "LuaJIT",
					--   -- Setup your lua path
					--   path = runtime_path,
					-- },
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false, -- THIS IS THE IMPORTANT LINE TO ADD
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
			on_attach = handlers.on_attach,
			capabilities = handlers.capabilities,
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
})

return M
