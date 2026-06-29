return {
	providers = {
		-- diagnostic registers with priority 1001 (above lsp), so on any symbol
		-- that also has a diagnostic it shadows the LSP doc on K. Diagnostics are
		-- already shown inline (virtual_lines.current_line), so keep K = doc only.
		-- "hover.providers.diagnostic",
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
