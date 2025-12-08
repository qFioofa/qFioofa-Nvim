local PACKAGE_NAME = "nvim-tree"

local Options = {
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
			padding = 10,
		},
		number = false,
		relativenumber = false,
		side = "left",
	},
}

local function configure_bindings()
	return {
		{ key = "w", action = "edit", desc = "Open file/folder" },
		{ key = "l", action = "edit", desc = "Open file/folder" },
		{ key = "h", action = "close_node", desc = "Close folder" },
		{ key = "v", action = "vsplit", desc = "Open in vertical split" },
		{ key = "s", action = "split", desc = "Open in horizontal split" },
		{ key = "t", action = "tabnew", desc = "Open in new tab" },
		{ key = "<CR>", action = "edit", desc = "Open file/folder (default)" },
		{ key = "o", action = "system_open", desc = "Open with system application" },
		{ key = "+", action = "create", desc = "Create new file/folder" },
		{ key = "d", action = "remove", desc = "Delete file/folder" },
		{ key = "r", action = "rename", desc = "Rename file/folder" },
		{ key = "y", action = "copy.node", desc = "Copy file/folder" },
		{ key = "x", action = "cut.node", desc = "Cut file/folder" },
		{ key = "p", action = "paste.node", desc = "Paste file/folder" },
		{ key = "c", action = "copy.filename", desc = "Copy filename" },
		{ key = "C", action = "copy.relative_path", desc = "Copy relative path" },
		{ key = "I", action = "toggle_gitignore", desc = "Toggle git ignored files" },
		{ key = "H", action = "toggle_hidden", desc = "Toggle hidden files" },
		{ key = "R", action = "refresh", desc = "Refresh tree" },
		{ key = "a", action = "create", desc = "Create new file/folder" },
		{ key = "<BS>", action = "navigate_up", desc = "Navigate up" },
		{ key = "<Tab>", action = "preview", desc = "Preview file" },
		{ key = "g?", action = "toggle_help", desc = "Show help" },
		{ key = "q", action = "close", desc = "Close tree" },
	}
end

local function setBinds()
	local keymap = vim.api.nvim_set_keymap
	local opts = {
		noremap = true,
		silent = true,
	}

	keymap("c", "<C-e>", ":NvimTreeToggle<CR>", opts)
end

return function()
	local nvim_tree = require(PACKAGE_NAME)

	Options.on_attach = function(bufnr)
		local api = require("nvim-tree.api")

		api.config.mappings.default_on_attach(bufnr)

		local custom_mappings = configure_bindings()
		for _, mapping in ipairs(custom_mappings) do
			local action_func = api[mapping.action]

			if action_func then
				vim.keymap.set("n", mapping.key, action_func, {
					noremap = true,
					silent = true,
					nowait = true,
					buffer = bufnr,
					desc = mapping.desc,
				})
			end
		end
	end

	nvim_tree.setup(Options)
	setBinds()
end
