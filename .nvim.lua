vim.opt.makeprg = "./build.sh scanner"

vim.cmd([[
  set errorformat+=%f(%l:%c)\ %m
]])

-- Open Trouble UI after make command if there's an error
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	pattern = "[^l]*",
	callback = function()
		-- Get the current quickfix list
		local qflist = vim.fn.getqflist()
		local has_errors = false

		-- Check if there is at least one valid error
		for _, item in ipairs(qflist) do
			if item.valid == 1 then
				has_errors = true
				break
			end
		end

		if has_errors then
			-- Open the quickfix list using Trouble
			vim.cmd("Trouble qflist open")
		else
			-- Close it if the build succeeded and it was previously open
			vim.cmd("Trouble qflist close")
			print("Build successful!")
		end
	end,
	desc = "Auto-open Trouble quickfix on errors",
})
