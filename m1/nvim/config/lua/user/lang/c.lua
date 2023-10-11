local cmake_status_ok, cmake = pcall(require, "cmake")
if not cmake_status_ok then
  return
end

cmake.setup({})

vim.keymap.set("n", "B", "<cmd>CMake build_and_run<CR>", bufopts)
