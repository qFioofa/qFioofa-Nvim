return {
	options = {
		component_separators = "",
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "NvimTree" },
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
