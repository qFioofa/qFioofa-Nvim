return {
	auto_reload_on_write = true,
	sync_root_with_cwd = true,
	disable_netrw = true,
	hijack_netrw = true,
	open_on_tab = false,
	hijack_cursor = false,
	update_cwd = true,
	hijack_directories = {
		enable = true,
		auto_open = true,
	},
	filters = {
		dotfiles = false,
	},
	diagnostics = {
		enable = false,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	update_focused_file = {
		enable = true,
		update_cwd = true,
		ignore_list = {},
	},
	git = {
		enable = true,
		ignore = true,
		timeout = 500,
	},
	renderer = {
		highlight_git = "all",
		root_folder_modifier = ":t",
		indent_width = 2,
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					deleted = "",
					untracked = "U",
					ignored = "◌",
				},
				folder = {
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
				},
			},
		},
	},
	actions = {
		open_file = {
			quit_on_open = false,
			resize_window = true,
		},
	},
	view = {
		width = {
			min = 30,
			max = 60,
			padding = 1,
		},
		number = false,
		relativenumber = false,
		side = "left",
	},
}
