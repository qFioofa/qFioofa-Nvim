local PACKAGE_NAME = "nvim-tree"

local Options = {
	auto_reload_on_write = true,
	sync_root_with_cwd = true,
	disable_netrw = true,
	hijack_netrw = true,
	open_on_tab = false,
	hijack_cursor = true,
	update_cwd = true,
	hijack_directories = {
		enable = true,
		auto_open = true,
	},
	diagnostics = {
		enable = true,
		icons = {
			hint = "",
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
		timeout = 500,
	},
	view = {
		width = {
			min = 30,
			max = 60,
			padding = 15
		},
		number = true,
		relativenumber = true,
		side = "left",
	},
	renderer = {
		highlight_git = "all",
		root_folder_modifier = ":t",
		indent_width = 2,
		hidden_display = 'simple',
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					deleted = "",
					untracked = "U",
					ignored = "◌",
				},
				folder = {
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
				},
			}
		}
	}
}
 
return function()
	local nvim_tree = require(PACKAGE_NAME)

	nvim_tree.setup(Options)
end
