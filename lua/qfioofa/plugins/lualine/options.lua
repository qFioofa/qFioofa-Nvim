-- The statusline sections, defined once so the toggleterm extension below can
-- reuse the exact same configuration (mode, branch, diagnostics, location, ...)
-- and only swap the filename slot for the shell terminal name.
local sections = {
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
}

-- Resolve a toggleterm buffer's shell name, e.g. "zsh". Prefer toggleterm's
-- own display name, falling back to parsing the `term://...:<cmd>` buffer name.
local function terminal_name()
	local id = vim.b.toggle_number
	if id then
		local ok, terms = pcall(require, "toggleterm.terminal")
		if ok then
			local term = terms.get(id)
			local got, name = pcall(function()
				return term and term:_display_name()
			end)
			if got and name and name ~= "" then
				return vim.fn.fnamemodify(name, ":t")
			end
		end
	end

	local cmd = vim.api.nvim_buf_get_name(0):match("term://.-//%d+:(.*)$")
	if cmd then
		return vim.fn.fnamemodify(vim.split(cmd, " ")[1], ":t")
	end
	return "terminal"
end

-- A lualine extension that gives focused toggleterm windows (including floats)
-- the full statusline above, with the filename slot replaced by the shell name.
local toggleterm_extension = {
	filetypes = { "toggleterm" },
	sections = vim.deepcopy(sections),
}
toggleterm_extension.sections.lualine_y = {
	{
		terminal_name,
		icon = "",
		separator = { left = "", right = "" },
	},
}

return {
	options = {
		component_separators = "",
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "NvimTree" },
		always_divide_middle = true,
	},
	sections = sections,
	inactive_sections = {
		lualine_a = { "filename" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	-- Renders the full lualine statusline (mode, branch, ...) for toggleterm
	-- windows. Reused by the winbar (plugins/toggleterm/winbar.lua) so a floating
	-- terminal shows the same bar at the top, with the shell name in place of the
	-- filename.
	extensions = { toggleterm_extension },
}
