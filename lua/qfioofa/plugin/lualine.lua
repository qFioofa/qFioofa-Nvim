local PACKAGE_NAME = "lualine"

local s = {
	b = { bg = "#bc735c", fg = "#fafafa" },
	c = { bg = "#151515", fg = "#fafafa" },

	y = { bg = "#303030", fg = "#fafafa" },
	x = { bg = "#000000", fg = "#fafafa" },
}

local bg = "#151515"

local Options = {
	options = {
		theme = {
			normal = {
				a = { bg = "#bf616a", fg = "#fafafa" },
				b = s.b,
				c = s.c,

				y = s.y,
				x = s.x,
			},

			insert = {
				a = { bg = "#9db89c", fg = "#303030" },
				b = s.b,
				c = s.c,

				y = s.y,
				x = s.x,
			},
			visual = {
				a = { bg = "#D4A017", fg = "#303030" },
				b = s.b,
				c = s.c,

				y = s.y,
				x = s.x,
			},
			replace = {
				a = { bg = "#8dd3c3", fg = "#303030" },
				b = s.b,
				c = s.c,

				y = s.y,
				x = s.x,
			},
			command = {
				a = { bg = "#c678dd", fg = "#303030" },
				b = s.b,
				c = s.c,

				y = s.y,
				x = s.x,
			},
			terminal = {
				a = { bg = "#7A7A7A", fg = "#fafafa" },
				b = s.b,
				c = s.c,

				y = s.y,
				x = s.x,
			},
		},
		component_separators = "",
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
	},
	sections = {
		lualine_a = {
			{
				"mode",
				icon = "",
				separator = { left = "", right = "" },
				right_padding = 2,
			},
		},
		lualine_b = {
			{
				"branch",
				icon = "",
				separator = { left = "", right = "" },
				right_padding = 2,
			},
		},
		lualine_c = {
			"%=",
		},
		lualine_x = {
			{
				"diagnostics",
				icon = " ",
				separator = { left = "", right = "" },
				right_padding = 2,
			},
		},
		lualine_y = {
			{
				"filename",
				icon = "",
				separator = { left = "", right = "" },
				-- right_padding = 2,
				symbols = {
					modified = "",
					readonly = "",
					unnamed = "[No Name]",
					newfile = "[New]",
				},
			},
		},
		lualine_z = {
			{
				"location",
				icon = "",
				separator = { left = "", right = "" },
				left_padding = 2,
				right_padding = 2,
			},
		},
	},
	inactive_sections = {
		lualine_a = { "filename" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
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
