local status_ok, term = pcall(require, "toggleterm")
if not status_ok then
	return
end

term.setup()

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	hidden = true,
	direction = "float",
	float_opts = {
		border = "curved",
		-- width = 120,
		-- height = 30,
		winblend = 3,
	},
})

function _G.__lazygit_toggle()
	lazygit:toggle()
end

local wk_status_ok, wk = pcall(require, "which-key")
if not wk_status_ok then
	return
end

wk.register({
	g = {
		name = "Git",
		g = { "<cmd>lua __lazygit_toggle()<CR>", "lazygit", noremap = true },
	},
}, { prefix = "<leader>" })

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	-- vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	-- vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	-- vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
