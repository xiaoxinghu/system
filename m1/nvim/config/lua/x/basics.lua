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
