return {
	defaults = {
		prompt_prefix = "   ",
		selection_caret = " ",
		entry_prefix = " ",
		sorting_strategy = "ascending",
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
		path_display = { "truncate" },
	},
	pickers = {
		find_files = {
			hidden = true,
			previewer = false,
		},
		grep_string = {
			only_one_result = true,
		},
		live_grep = {
			additional_args = function(opts)
				return { "--hidden" }
			end,
		},
	},
	extensions = {
		extensions_list = { "themes", "terms" },
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
}
