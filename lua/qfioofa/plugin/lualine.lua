local PACKAGE_NAME = "lualine"

local Options = {
	options = {
		theme = {
			normal = {
				a = { bg = "#d65d0e", fg = "#ffffff" },
				b = { bg = "#2d2d2d", fg = "#ffffff" },
				c = { bg = "#2d2d2d", fg = "#ffffff" },
			},
			insert = {
				a = { bg = "#98971a", fg = "#ffffff" },
				b = { bg = "#2d2d2d", fg = "#ffffff" },
				c = { bg = "#2d2d2d", fg = "#ffffff" },
			},
			visual = {
				a = { bg = "#d79921", fg = "#ffffff" },
				b = { bg = "#2d2d2d", fg = "#ffffff" },
				c = { bg = "#2d2d2d", fg = "#ffffff" },
			},
			replace = {
				a = { bg = "#8ec07c", fg = "#ffffff" },
				b = { bg = "#2d2d2d", fg = "#ffffff" },
				c = { bg = "#2d2d2d", fg = "#ffffff" },
			},
			command = {
				a = { bg = "#d3869b", fg = "#ffffff" },
				b = { bg = "#2d2d2d", fg = "#ffffff" },
				c = { bg = "#2d2d2d", fg = "#ffffff" },
			},
			terminal = {
				a = { bg = "#1d1d1d", fg = "#ffffff" },
				b = { bg = "#2d2d2d", fg = "#ffffff" },
				c = { bg = "#2d2d2d", fg = "#ffffff" },
			},
		},
		component_separators = { left = " |", right = "| " },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff" },
		lualine_c = { "filename" },
		lualine_x = { "diagnostics", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
}

return function()
	local status_ok, lualine = pcall(require, PACKAGE_NAME)
	if not status_ok then
		return
	end

	lualine.setup(Options)
end
