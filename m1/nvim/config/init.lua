vim.opt.termguicolors = true
vim.opt.syntax = "on"
vim.o.errorbells = false
vim.o.smartcase = true
vim.o.showmode = false
vim.bo.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath("config") .. "/undodir"
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hidden = true
vim.o.completeopt = "menuone,noinsert,noselect"
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"
vim.wo.wrap = false
vim.g.mapleader = " "
vim.o.ignorecase = true
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.cursorline = true
vim.opt.winblend = 0
vim.opt.wildoptions = "pum"
vim.opt.pumblend = 5
vim.opt.background = "dark"

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- spell check
vim.cmd([[autocmd FileType markdown,markdown.mdx,gitcommit setlocal spell]])

-- enable mouse support
vim.cmd([[set mouse=a]])

if vim.g.neovide then
	-- vim.g.neovide_transparency = 0.8
	vim.g.neovide_cursor_animation_length = 0.02
	vim.g.neovide_input_use_logo = true
	vim.cmd([[set mouse=a]])
	vim.cmd([[set guifont=JetBrainsMono\ Nerd\ Font]])
end

if vim.g.gui_vimrun then
	vim.cmd([[set guifont=JetBrainsMono\ Nerd\ Font]])
end

-- require("tokyonight").setup({
-- 	-- day_brightness = 0.3,
-- })

-- require("github-theme").setup({
-- 	transparent = false,
-- 	theme_style = "light",
-- 	-- day_brightness = 0.3,
-- })
--
-- vim.cmd([[colorscheme nord]])
-- vim.cmd([[colorscheme tokyonight]])
-- vim.cmd([[colorscheme modus-vivendi]])
-- vim.cmd([[colorscheme modus-operandi]])



vim.cmd([[colorscheme nightfox]])

---@param cmd string
---@param opts table
---@return number | 'the job id'
function start_job(cmd, opts)
  opts = opts or {}
  local id = vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data, _)
      if data and opts.on_stdout then
        opts.on_stdout(data)
      end
    end,
    on_exit = function(_, data, _)
      if opts.on_exit then
        opts.on_exit(data)
      end
    end,
  })

  if opts.input then
    vim.fn.chansend(id, opts.input)
    vim.fn.chanclose(id, "stdin")
  end

  return id
end

-- function is_dark(callback)
-- 	start_job("defaults read -g AppleInterfaceStyle", {
-- 		on_exit = function(exit_code)
-- 			local is_dark_mode = exit_code == 0
-- 			callback(is_dark_mode)
-- 		end,
-- 	})
-- end
--
-- is_dark(function(dark)
-- 	if dark then
-- 		-- vim.cmd([[colorscheme github_dark]])
-- 		vim.o.background = "dark"
-- 	else
-- 		-- vim.cmd([[colorscheme github_light]])
-- 		vim.o.background = "light"
-- 	end
-- end)

local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

local function super(key, cmd)
  -- map("n", string.format("<D-%s>", key), cmd, options)
  -- map("i", string.format("<D-%s>", key), string.format("<Esc>%s", cmd), options)
  if vim.g.neovide or vim.fn.has("gui_vimr") then
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

local wk_status_ok, wk = pcall(require, "which-key")
if wk_status_ok then
  wk.register({
    -- [" "] = { "<cmd>Telescope commands<cr>", "Commands", noremap = true },
    [" "] = { "<cmd>HopChar1<cr>", "Hop", noremap = true },
    f = {
      name = "File", -- optional group name
      f = { "<cmd>FindFile<cr>", "Find File", noremap = true }, -- create a binding with label
      r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap = false }, -- additional options for creating the keymap
    },
    b = {
      name = "Buffer", -- optional group name
      b = { "<cmd>Telescope buffers<cr>", "find buffer", noremap = true }, -- create a binding with label
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
end

local hydra_ok, hydra = pcall(require, "hydra")
if not hydra_ok then
  hydra({
    name = "Adjust",
    hint = "Adjust the window",
    config = {
      color = "red",
    },
    mode = "n",
    body = "<leader>w",
    heads = {
      { "o", "<C-w>o", { desc = "only window" } },
      { "h", "<C-w>h", { desc = "left" } },
      { "l", "<C-w>l", { desc = "right" } },
      { "j", "<C-w>j", { desc = "down" } },
      { "k", "<C-w>k", { desc = "up" } },
      { "<", "<C-w><", { desc = "decrease width" } },
      { ">", "<C-w>>", { desc = "increase width" } },
      { "+", "<C-w>+", { desc = "increase height" } },
      { "-", "<C-w>-", { desc = "decrease height" } },
      { "<Esc>", nil, { exit = true, nowait = true } },
    },
  })
end

local signs = {
	{ name = "DiagnosticSignError", text = "" },
	{ name = "DiagnosticSignWarn", text = "" },
	{ name = "DiagnosticSignHint", text = "" },
	{ name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
	-- disable virtual text
	virtual_text = false,
	-- show signs
	signs = {
		active = signs,
	},
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
}

vim.diagnostic.config(config)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "rounded",
})

local lspsaga_status_ok, lspsaga = pcall(require, "lspsaga")
if lspsaga_status_ok then
	-- TODO: https://github.com/glepnir/lspsaga.nvim
	lspsaga.setup({})
end
