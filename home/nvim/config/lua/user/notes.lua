local wk_status_ok, wk = pcall(require, "which-key")
if not wk_status_ok then
	return
end

-- wk.regismer({
--   n = {
--     name = "Notes",
--     f = { "<cmd>Telescope file_browser path=%:p:h<cr>", "Find File", noremap = true }, -- create a binding with label
--     -- r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap = false }, -- additional options for creating the keymap
--     -- b = { "<cmd>Telescope buffers<cr>", "find buffer", noremap = true }, -- create a binding with label
--   },
-- }, { prefix = "<leader>" })

vim.api.nvim_set_keymap(
	"n",
	"gn",
	-- "<cmd>Telescope grep_string search_dirs={'~/brain'}<cr>",
	"<cmd>Telescope live_grep search_dirs={'~/brain'}<cr>",
	{ noremap = true, silent = true }
)

local orgmode_status_ok, orgmode = pcall(require, "orgmode")
if not orgmode_status_ok then
	return
end

orgmode.setup_ts_grammar()

-- Tree-sitter configuration
require("nvim-treesitter.configs").setup({
	-- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "org" }, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
	},
	ensure_installed = { "org" }, -- Or run :TSUpdate org
})

orgmode.setup({
	-- org_agenda_files = { "~/brain/**/*" },
	org_default_notes_file = "~/brain/notes.org",
	org_hide_leading_stars = true,
	org_agenda_templates = {
		t = {
			description = "Todo",
			template = "* TODO %?",
		},
	},
})
