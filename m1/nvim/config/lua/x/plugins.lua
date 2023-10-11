-- Tasks
-- TODO https://github.com/AckslD/nvim-neoclip.lua

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap =
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd([[packadd packer.nvim]])
end

return require("packer").startup(function(use)
	-- My plugins here

	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
	use("tpope/vim-surround")

	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	if vim.g.vscode then -- vscode only
	else -- terminal only
		-- treesitter
		use({
			"nvim-treesitter/nvim-treesitter",
			run = function()
				require("nvim-treesitter.install").update({ with_sync = true })
			end,
		})
		use("nvim-treesitter/nvim-treesitter-textobjects")

		use("JoosepAlviste/nvim-ts-context-commentstring")
		use("p00f/nvim-ts-rainbow")
		use("windwp/nvim-ts-autotag")

		-- UI
		use("kyazdani42/nvim-web-devicons")
		--- themes
		-- If you are using Packer
		use("shaunsingh/nord.nvim")
		use("folke/tokyonight.nvim")
		use("ishan9299/modus-theme-vim")
		-- use("ellisonleao/gruvbox.nvim")
		use("EdenEast/nightfox.nvim")
		-- use("tjdevries/colorbuddy.nvim")
		use("projekt0n/github-nvim-theme")
		use("NLKNguyen/papercolor-theme")

		use("nvim-lualine/lualine.nvim")
		use({
			"akinsho/bufferline.nvim",
			config = function()
				require("bufferline").setup()
			end,
		})

		-- editor
		use("windwp/nvim-autopairs")
		use("phaazon/hop.nvim")
		use("LunarVim/bigfile.nvim")

		-- telescope
		-- use({
		--   "nvim-telescope/telescope.nvim",
		--   requires = {
		--     { "nvim-lua/plenary.nvim" },
		--     { "nvim-telescope/telescope-file-browser.nvim" },
		--     { "nvim-telescope/telescope-live-grep-args.nvim" },
		--     { "nvim-telescope/telescope-fzf-native.nvim",    run = "make" },
		--   },
		-- })

		use("jvgrootveld/telescope-zoxide")
		use("AckslD/nvim-neoclip.lua")

		-- fzf
		-- use({
		--   "ibhagwan/fzf-lua",
		--   -- optional for icon support
		--   requires = { "kyazdani42/nvim-web-devicons" },
		-- })

		-- porject
		use("ahmedkhalf/project.nvim")

		-- snippets
		use("L3MON4D3/LuaSnip") --snippet engine
		use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

		-- LSP
		use({
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"jose-elias-alvarez/null-ls.nvim",
			"glepnir/lspsaga.nvim",
			"RRethy/vim-illuminate",
			"onsails/lspkind-nvim", -- vscode-like pictograms
		})

		-- auto complete
		use("hrsh7th/nvim-cmp")
		use("hrsh7th/cmp-buffer")
		use("hrsh7th/cmp-path")
		use("hrsh7th/cmp-cmdline")
		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-nvim-lua")
		use("github/copilot.vim")

		-- coding
		use("mfussenegger/nvim-dap")
		use("rcarriga/nvim-dap-ui")
		use("Shatur/neovim-cmake")
		use("simrat39/rust-tools.nvim")
		use({
			"peterhoeg/vim-qml",
			event = "BufRead",
			ft = { "qml" },
		})
		use("gpanders/editorconfig.nvim")
		use("norcalli/nvim-colorizer.lua") -- css colors

		-- keys
		use("folke/which-key.nvim")

		-- git
		use("lewis6991/gitsigns.nvim")
		use("ruifm/gitlinker.nvim")
		use("dinhhuy258/git.nvim")

		-- tree
		use({
			"nvim-tree/nvim-tree.lua",
			requires = {
				"nvim-tree/nvim-web-devicons", -- optional, for file icons
			},
			tag = "nightly", -- optional, updated every week. (see issue #1193)
			config = function()
				require("nvim-tree").setup({})
			end,
		})

		use({
			"cuducos/yaml.nvim",
			ft = { "yaml" }, -- optional
		})

		-- terminal
		use("akinsho/toggleterm.nvim")

		-- notes
		use({
			"nvim-orgmode/orgmode",
			config = function()
				require("orgmode").setup({})
			end,
		})

		use("anuvyklack/hydra.nvim")
		use("jxnblk/vim-mdx-js")
	end

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
