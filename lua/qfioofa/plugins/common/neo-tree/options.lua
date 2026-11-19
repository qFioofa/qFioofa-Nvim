return {
	close_if_last_window = false,
	enable_git_status = false,
	enable_diagnostics = false,
	default_source = "buffers",
	sources = { "buffers" },
	filesystem = {
		-- The filesystem source is not loaded; letting neo-tree hijack
		-- directories makes it assert on open and swap the current buffer
		-- for a blank one. nvim-tree handles directories instead.
		hijack_netrw_behavior = "disabled",
	},
	buffers = {
		follow_current_file = {
			enabled = true,
		},
		show_unloaded = false,
		window = {
			mappings = {
				["o"] = "open",
			},
		},
	},
	window = {
		position = "right",
		width = 40,
	},
}
