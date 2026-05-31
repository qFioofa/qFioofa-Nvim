return {
	auto_reload_on_write = true,
	sync_root_with_cwd = true,
	disable_netrw = true,
	hijack_netrw = true,
	open_on_tab = false,
	hijack_cursor = false,
	update_cwd = true,
	filesystem_watchers = {
		enable = true,
	},
	hijack_directories = {
		enable = true,
		auto_open = true,
	},
	filters = {
		dotfiles = false,
		git_ignored = true,
	},
	diagnostics = {
		enable = false,
		show_on_dirs = false,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
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
		show_on_dirs = true,
		timeout = 500,
	},
	modified = {
		enable = true,
		show_on_dirs = true,
	},
	renderer = {
		highlight_git = "all",
		highlight_modified = "icon",
		root_folder_label = ":t",
		indent_width = 2,
		group_empty = true,
		special_files = {
			"README.md",
			"Makefile",
			"MAKEFILE",
			"package.json",
		},
		symlink_destination = true,
		indent_markers = {
			enable = true,
			icons = {
				corner = "└",
				edge = "│",
				item = "│",
				bottom = "─",
				none = " ",
			},
		},
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
				modified = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				modified = "●",
				bookmark = "",
				git = {
					unstaged = "",
					staged = "✓",
					unmerged = "",
					renamed = "➜",
					deleted = "",
					untracked = "★",
					ignored = "◌",
				},
				folder = {
					default = "",
					arrow_closed = "›",
					arrow_open = "⌄",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
			},
		},
	},
	actions = {
		change_dir = {
			enable = true,
			global = false,
		},
		open_file = {
			quit_on_open = false,
			resize_window = true,
			window_picker = {
				enable = true,
			},
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
		signcolumn = "yes",
		side = "left",
		preserve_window_proportions = true,
	},
}
