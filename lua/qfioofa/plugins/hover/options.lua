return {
	providers = {
		"hover.providers.diagnostic",
		"hover.providers.lsp",
		"hover.providers.dap",
		"hover.providers.man",
		-- "hover.providers.dictionary",  -- natural-language defs, not code
		-- "hover.providers.gh",
		-- "hover.providers.gh_user",
		-- "hover.providers.jira",
		-- "hover.providers.fold_preview",
		-- "hover.providers.highlight",
	},
	preview_opts = {
		border = "single",
	},
	-- Whether the contents of a currently open hover window should be moved
	-- to a :h preview-window when pressing the hover keymap.
	preview_window = true,
	title = true,
	mouse_providers = {
		"hover.providers.lsp",
	},
	mouse_delay = 1000,
}
