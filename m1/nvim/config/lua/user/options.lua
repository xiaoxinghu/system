-- TODO: move options here from init.lua
vim.opt.clipboard = "unnamedplus" -- use system clipboard

-- enable mouse support
vim.cmd([[set mouse=a]])

if vim.g.neovide then
  -- vim.g.neovide_transparency = 0.8
  vim.g.neovide_cursor_animation_length = 0.01
  vim.g.neovide_input_use_logo = true
  vim.cmd([[set mouse=a]])
  vim.cmd([[set guifont=JetBrainsMono\ Nerd\ Font]])
end

if vim.g.gui_vimrun then
  vim.cmd([[set guifont=JetBrainsMono\ Nerd\ Font]])
end
