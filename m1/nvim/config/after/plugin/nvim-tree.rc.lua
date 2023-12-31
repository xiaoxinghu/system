local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
	return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup({
	view = {
		adaptive_size = true,
		mappings = {
			list = {
				{ key = "u", cb = tree_cb("preview") },
			},
		},
	},
	filters = {
		dotfiles = true,
	},
})
