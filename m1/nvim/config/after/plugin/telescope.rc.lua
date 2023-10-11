local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

-- local actions = require "telescope.actions"
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local fb_actions = require("telescope").extensions.file_browser.actions

telescope.setup({
	defaults = {
		prompt_prefix = " ",
		selection_caret = " ",
		-- better live_grep, from: https://github.com/nvim-telescope/telescope.nvim/issues/470#issuecomment-767904334
		-- the --hidden is from here: https://github.com/BurntSushi/ripgrep/issues/623
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--hidden",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			-- "-u",
		},
		file_ignore_patterns = { "node_modules", ".git" },
		mappings = {
			n = {
				["q"] = actions.close,
			},
		},
	},
	pickers = {
		-- find_files = {
		--   theme = "dropdown",
		--   previewer = false,
		--   mappings = {
		--     n = {
		--       ["cd"] = function(prompt_bufnr)
		--         local selection = require("telescope.actions.state").get_selected_entry()
		--         local dir = vim.fn.fnamemodify(selection.path, ":p:h")
		--         require("telescope.actions").close(prompt_bufnr)
		--         -- Depending on what you want put `cd`, `lcd`, `tcd`
		--         vim.cmd(string.format("silent lcd %s", dir))
		--       end,
		--     },
		--   },
		-- },
		live_grep = {
			mappings = {
				i = {
					["<C-f>"] = actions.to_fuzzy_refine,
				},
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
		},
		file_browser = {
			theme = "ivy",
			-- disables netrw and use telescope-file-browser in its place
			hijack_netrw = true,
			mappings = {
				["i"] = {
					-- your custom insert mode mappings
				},
				["n"] = {
					-- your custom normal mode mappings
					["N"] = fb_actions.create,
					-- ["h"] = fb_actions.goto_parent_dir,
					["/"] = function()
						vim.cmd("startinsert")
					end,
				},
			},
		},
	},
})

telescope.load_extension("file_browser")
telescope.load_extension("live_grep_args")
telescope.load_extension("zoxide")
telescope.load_extension("fzf")

local neoclip_ok, neoclip = pcall(require, "neoclip")
if neoclip_ok then
	neoclip.setup()
	telescope.load_extension("neoclip")
end

vim.api.nvim_create_user_command("ProjectFiles", function()
	local opts = {
		-- recurse_submodules = true,
		hidden = true,
		show_untracked = true,
	}

	local ok = pcall(require("telescope.builtin").git_files, opts)
	if not ok then
		builtin.find_files(opts)
	end
end, { nargs = 0 })

local function telescope_buffer_dir()
	return vim.fn.expand("%:p:h")
end

vim.api.nvim_create_user_command("FindFile", function()
	telescope.extensions.file_browser.file_browser({
		path = "%:p:h",
		cwd = telescope_buffer_dir(),
		respect_gitignore = false,
		hidden = true,
		grouped = true,
		-- previewer = false,
		initial_mode = "normal",
		layout_config = { height = 40 },
	})
end, { nargs = 0 })
