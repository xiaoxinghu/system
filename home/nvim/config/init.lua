local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }
map("n", "gp", "<cmd>Telescope find_files<cr>", options)

-- theme
vim.cmd([[colorscheme nightfox]])

require("lualine").setup({
	options = {
		theme = "nightfox",
	},
})

-- comment
require("Comment").setup()
