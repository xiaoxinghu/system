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
