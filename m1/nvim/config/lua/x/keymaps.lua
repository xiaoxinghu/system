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
