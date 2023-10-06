local rust_tools_status_ok, rust_tools = pcall(require, "rust-tools")
if not rust_tools_status_ok then
	return
end

-- local handlers = require("core.lsp.handlers")
--
-- rust_tools.setup({
--   server = {
--     on_attach = handlers.on_attach,
--     capabilities = handlers.capabilities,
--   },
-- })
