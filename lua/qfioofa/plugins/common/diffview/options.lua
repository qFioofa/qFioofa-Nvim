return {
	diff_binaries = false,
	enhanced_diff_hl = true,
	use_icons = true,
	show_help_hints = true,
	watch_index = true,
	view = {
		default = {
			layout = "diff2_vertical",
			disable_diagnostics = true,
			winbar_info = true,
		},
		merge_tool = {
			layout = "diff3_mixed",
			disable_diagnostics = true,
			winbar_info = true,
		},
		file_history = {
			layout = "diff2_vertical",
			disable_diagnostics = true,
			winbar_info = true,
		},
	},
	file_panel = {
		listing_style = "tree",
		tree_options = {
			flatten_dirs = true,
			folder_statuses = "only_folded",
		},
		win_config = { position = "left", width = 35 },
	},
	file_history_panel = {
		win_config = { position = "bottom", height = 16 },
	},
	keymaps = { disable_defaults = false },
	hooks = {
		diff_buf_read = function()
			vim.opt_local.wrap = false
			vim.opt_local.list = false
		end,
	},
}
