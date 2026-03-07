local function isExcludedWindow()
	local ft = vim.api.nvim_buf_get_option(0, "filetype")

	local buf_name = vim.api.nvim_buf_get_name(0)
	local excluded_filetypes = { "nvimtree", "NvimTree" }

	for _, excluded_ft in ipairs(excluded_filetypes) do
		if ft == excluded_ft then
			return true
		end
	end

	if buf_name:match("NvimTree") then
		return true
	end

	return false
end

vim.api.nvim_create_autocmd("WinEnter", {
	group = vim.api.nvim_create_augroup("WindowSizeActive", { clear = true }),
	callback = function()
		local min_width = 100

		if isExcludedWindow() then
			return
		end

		local current_width = vim.api.nvim_win_get_width(0)
		if current_width < min_width then
			vim.cmd("vertical resize " .. min_width)
		end
	end,
})
