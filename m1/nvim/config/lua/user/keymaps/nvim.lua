local wk_status_ok, wk = pcall(require, "which-key")
if not wk_status_ok then
	return
end

wk.register({
	-- [" "] = { "<cmd>Telescope commands<cr>", "Commands", noremap = true },
	[" "] = { "<cmd>HopChar1<cr>", "Hop", noremap = true },
	f = {
		name = "File", -- optional group name
		f = { "<cmd>FindFile<cr>", "Find File", noremap = true }, -- create a binding with label
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap = false }, -- additional options for creating the keymap
		b = { "<cmd>Telescope buffers<cr>", "find buffer", noremap = true }, -- create a binding with label
		-- n = { "New File" }, -- just a label. don't create any mapping
		-- e = "Edit File", -- same as above
		-- ["1"] = "which_key_ignore",  -- special label to hide it in the popup
		-- b = { function() print("bar") end, "Foobar" } -- you can also pass functions!
	},
	p = {
		name = "Project",
		f = { "<cmd>Telescope git_files recurse_submodules=true<cr>", "Find File", noremap = true },
		s = { "<cmd>Telescope live_grep<cr>", "Search", noremap = true },
		S = { "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", "rg", noremap = true },
		p = { "<cmd>Telescope projects<cr>", "Switch Project", noremap = true },
		t = { "<cmd>NvimTreeToggle %:p:h<cr>", "Toggle Tree", noremap = true },
	},
	t = { "<cmd>ToggleTerm<cr>", "Terminal", noremap = true },
}, { prefix = "<leader>" })

local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

function super(key, cmd)
	if vim.g.neovide then
		map("n", string.format("<D-%s>", key), cmd, options)
		map("i", string.format("<D-%s>", key), string.format("<Esc>%s", cmd), options)
	else
		map("n", string.format("<M-%s>", key), cmd, options)
		map("i", string.format("<M-%s>", key), string.format("<Esc>%s", cmd), options)
	end
end

-- function _G.project_files()
-- 	local opts = { recurse_submodules = true } -- define here if you want to define something
-- 	local ok = pcall(require("telescope.builtin").git_files, opts)
-- 	if not ok then
-- 		require("telescope.builtin").find_files(opts)
-- 	end
-- end

super("p", "<cmd>ProjectFiles<cr>")
super("b", "<cmd>Telescope buffers<cr>")
super("o", "<cmd>Telescope oldfiles<cr>")
super("P", "<cmd>Telescope projects<cr>")
super("F", "<cmd>Telescope live_grep<cr>")
super("s", "<cmd>w<cr>")

super("t", "<cmd>tabedit<cr>")
super("w", "<cmd>q<cr>")

map("n", "gp", "<cmd>Telescope projects<cr>", options)
map("n", "gs", "<cmd>Telescope live_grep<cr>", options)
map("n", "<esc>", "<cmd>noh<cr>", options)
-- select all
map("n", "<C-a>", "gg<S-v>G", options)
