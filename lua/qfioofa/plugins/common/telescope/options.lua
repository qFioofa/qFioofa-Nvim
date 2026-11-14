local actions = require("telescope.actions")

return {
	defaults = {
		prompt_prefix = "󰍉 ",
		selection_caret = " ",
		entry_prefix = " ",
		multi_icon = " ",
		prompt_title = " Search ",
		results_title = " Results ",
		-- Rounded popup border with readable, opaque windows.
		border = true,
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		dynamic_preview_title = true,
		hl_result_eol = true,
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
		-- Show the filename first, then the rest of the path.
		path_display = { "filename_first" },
		wrap_results = true,
		winblend = 0,
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
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
