local function should_save(buf)
	local excluded_filetypes = {
		"nvimtree",
		"NvimTree",
		"gitcommit",
		"help",
		"man",
		"TelescopePrompt",
		"toggleterm",
		"oil",
		"neo-tree",
		"alpha",
		"dashboard",
		"lazygit",
		"Outline",
		"prompt",
	}

	local filetype = vim.fn.getbufvar(buf, "&filetype")
	local buftype = vim.fn.getbufvar(buf, "&buftype")

	if vim.tbl_contains(excluded_filetypes, filetype) then
		return false
	end

	if buftype ~= "" then
		return false
	end

	return true
end

return {
	enabled = true,
	trigger_events = {
		immediate_save = { "BufLeave" },
		defer_save = {},
		cancel_deferred_save = {},
	},
	condition = should_save,
	write_all_buffers = false,
	noautocmd = false,
	lockmarks = false,
	debounce_delay = 1000,
	debug = false,
}
