local function isExcludedWindow()
	local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })

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

-- Briefly highlight yanked text as visual feedback.
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("WinEnter", {
	group = vim.api.nvim_create_augroup("WindowSizeActive", { clear = true }),
	callback = function()
		local min_width = 100

		-- Don't fight floating windows (popups, completion, etc.).
		if vim.api.nvim_win_get_config(0).relative ~= "" then
			return
		end

		-- Nothing to widen against in a single-window layout.
		if #vim.api.nvim_tabpage_list_wins(0) < 2 then
			return
		end

		if isExcludedWindow() then
			return
		end

		local current_width = vim.api.nvim_win_get_width(0)
		if current_width < min_width then
			vim.cmd("vertical resize " .. min_width)
		end
	end,
})
