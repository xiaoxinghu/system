if vim.g.vscode then
	require("user.keymaps.vscode")
else
	require("user.keymaps.nvim")
end

require("user.keymaps.hydra")
