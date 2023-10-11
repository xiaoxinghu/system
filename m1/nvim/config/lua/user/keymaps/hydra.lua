local status_ok, hydra = pcall(require, "hydra")
if not status_ok then
  return
end

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
