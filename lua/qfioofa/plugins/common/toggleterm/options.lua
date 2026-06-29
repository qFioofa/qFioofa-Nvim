-- Default to a centered floating terminal. Sizes are functions so the float
-- scales with the editor instead of using fixed columns/rows.
return {
	-- We register <leader>tt via the lazy `keys` spec, so leave the built-in
	-- open_mapping unset to avoid a duplicate binding.
	open_mapping = nil,
	direction = "float",
	start_in_insert = true,
	persist_mode = true,
	persist_size = true,
	close_on_exit = true,
	shade_terminals = true,
	float_opts = {
		border = "curved",
		width = function()
			return math.floor(vim.o.columns * 0.85)
		end,
		height = function()
			return math.floor(vim.o.lines * 0.85)
		end,
		winblend = 3,
		title_pos = "center",
	},
	-- toggleterm's own winbar can't render in floats. We disable it and set our
	-- own winbar (top of the window) that reuses the full lualine config via the
	-- toggleterm lualine extension. See plugins/toggleterm/winbar.lua and
	-- plugins/lualine/options.lua.
	winbar = {
		enabled = false,
	},
	on_open = function(term)
		require("qfioofa.plugins.common.toggleterm.winbar").attach(term)
	end,
}
