local DEFAULT_OPTIONS = {
	gruvbox_material_background = "soft",
	gruvbox_material_palette = "original",
	gruvbox_material_enable_italic = 0,
	gruvbox_material_enable_bold = 0,
	gruvbox_material_sign_column_background = "dark",
	gruvbox_material_statusline_style = "original",
	gruvbox_material_disable_background = 0,
	gruvbox_material_ui_contrast = "high",
	gruvbox_material_cursor = "auto",
	gruvbox_material_visual = "orange",
	gruvbox_material_dim_inactive_windows = 0,
	gruvbox_material_colors_override = {
		bg0 = { "#1d1d1d", "234" },
		bg1 = { "#1d1d1d", "234" },
		bg2 = { "#1d1d1d", "235" },
	},
}

local function apply_theme_options(options)
	for field, value in pairs(options) do
		vim.g[field] = value
	end
end

local function main()
	apply_theme_options(DEFAULT_OPTIONS)
end

return main
