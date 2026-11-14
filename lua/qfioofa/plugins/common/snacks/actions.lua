local M = {}

function M.find_files()
	require("snacks").picker.explorer({
		title = " Files ",
		focus = "input",
		follow_file = false,
		hidden = false,
		ignored = false,
		layout = { preset = "telescope", preview = true },
	})
end

function M.find_config()
	require("snacks").picker.explorer({
		title = " Config ",
		focus = "input",
		follow_file = false,
		hidden = false,
		ignored = false,
		cwd = vim.fn.stdpath("config"),
		layout = { preset = "telescope", preview = true },
	})
end

function M.grep()
	require("snacks").picker.pick("grep_grouped", {
		title = " Grep ",
	})
end

return M
