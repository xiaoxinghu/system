local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
local gitlinker_ok, gitlinker = pcall(require, "gitlinker")
local git_ok, git = pcall(require, "git")
local wk_ok, wk = pcall(require, "which-key")

if gitsigns_ok then
	gitsigns.setup({
		signs = {
			add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
			change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
			delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
			topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
			changedelete = {
				hl = "GitSignsChange",
				text = "▎",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
		},
	})
end

if gitlinker_ok then
	gitlinker.setup()
end

if wk_ok then
	wk.register({
		g = {
			name = "Git",
			Y = { '<cmd>lua require"gitlinker".get_repo_url()<CR>', "yank repo", noremap = true },
			B = {
				'<cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<CR>',
				"open repo",
				noremap = true,
			},
		},
	}, { prefix = "<leader>" })
end

if git_ok then
	git.setup({
		default_mappings = true,
	})
end
