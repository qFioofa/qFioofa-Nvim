local actions = require("telescope.actions")

return {
	defaults = {
		prompt_prefix = "   ",
		selection_caret = " ",
		entry_prefix = " ",
		sorting_strategy = "ascending",
		-- flex auto-switches horizontal/vertical based on window width.
		layout_strategy = "flex",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.55,
			},
			width = 0.87,
			height = 0.80,
		},
		file_ignore_patterns = {
			"node_modules",
			".git",
			"%.lock",
			"%.tmp",
			"%.cache",
		},
		-- "smart" shows just enough path to disambiguate; wrap instead of cut.
		path_display = { "smart" },
		wrap_results = true,
		winblend = 10,
		mappings = {
			i = {
				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<esc>"] = actions.close,
			},
		},
	},
	pickers = {
		find_files = {
			hidden = true,
			previewer = true,
		},
		grep_string = {
			only_one_result = true,
		},
		live_grep = {
			additional_args = function(_)
				return { "--hidden" }
			end,
		},
		buffers = {
			sort_mru = true,
			ignore_current_buffer = true,
			mappings = {
				i = { ["<C-x>"] = actions.delete_buffer },
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
}
