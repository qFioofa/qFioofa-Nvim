local PACKAGE_NAME = "noice"

local function setup_views()
	return {
		cmdline_popup = {
			position = {
				row = "50%",
				col = "50%",
			},
			size = {
				width = 60,
				height = "auto",
			},
			border = {
				style = "rounded",
				padding = { 0, 1 },
			},
			win_options = {
				winhighlight = {
					Normal = "Normal",
					FloatBorder = "FloatBorder",
					IncSearch = "",
					Search = "",
				},
			},
		},
		popupmenu = {
			relative = "editor",
			position = {
				row = 8,
				col = "50%",
			},
			size = {
				width = 60,
				height = 10,
			},
			border = {
				style = "rounded",
				padding = { 0, 1 },
			},
			win_options = {
				winhighlight = {
					Normal = "Normal",
					FloatBorder = "FloatBorder",
					CursorLine = "Visual",
					PmenuSel = "Visual",
				},
			},
		},
		mini = {
			position = {
				row = -1,
				col = 0,
			},
			size = "auto",
			border = {
				style = "rounded",
				padding = { 0, 0 },
			},
			win_options = {
				winhighlight = {
					Normal = "NoiceMini",
					MsgArea = "NoiceMini",
				},
			},
			timeout = 3000,
		},
	}
end

local function setup_routes()
	return {
		-- Show written/saved messages as mini
		{
			filter = {
				event = "msg_show",
				kind = "",
				find = "written",
			},
			opts = { skip = false, view = "mini" },
		},
		-- Show search count messages as mini
		{
			filter = {
				event = "msg_show",
				kind = "search_count",
			},
			opts = { skip = false, view = "mini" },
		},
		-- Show recording messages as mini
		{
			filter = {
				event = "msg_show",
				kind = "",
				find = "recording",
			},
			opts = { view = "mini" },
		},
		-- Route all other messages to notify
		{
			filter = {
				event = "msg_show",
				min_height = 1,
			},
			view = "notify",
		},
	}
end

local function setup_popupmenu()
	return {
		enabled = true,
		backend = "nui",
	}
end

local function setup_lsp()
	return {
		progress = {
			enabled = true,
			view = "mini",
		},
		signature = {
			enabled = false,
		},
		message = {
			enabled = false,
		},
		documentation = {
			view = "hover",
		},
		hover = {
			enabled = true,
			view = "hover",
		},
	}
end

local function setup_keymaps()
	local keymaps = {
		{
			"<S-Enter>",
			function()
				require("noice").redirect(vim.fn.getcmdline())
			end,
			mode = "c",
			desc = "Redirect Cmdline",
		},
		{
			"<leader>nl",
			function()
				require("noice").cmd("last")
			end,
			desc = "Noice Last Message",
		},
		{
			"<leader>nh",
			function()
				require("noice").cmd("history")
			end,
			desc = "Noice History",
		},
		{
			"<leader>na",
			function()
				require("noice").cmd("all")
			end,
			desc = "Noice All",
		},
		{
			"<leader>nd",
			function()
				require("noice").cmd("dismiss")
			end,
			desc = "Dismiss All",
		},
	}

	for _, keymap in ipairs(keymaps) do
		vim.keymap.set(keymap.mode or "n", keymap[1], keymap[2], { desc = keymap.desc, silent = true, noremap = true })
	end
end

local Options = {
	cmdline = {
		enabled = true,
		view = "cmdline_popup",
	},
	messages = {
		enabled = true,
		view = "cmdline_popup",
	},
	popupmenu = setup_popupmenu(),
	lsp = setup_lsp(),
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = false,
		inc_rename = false,
		lsp_doc_border = true,
	},
	views = setup_views(),
	routes = setup_routes(),
}

return function()
	local status_ok, noice = pcall(require, PACKAGE_NAME)
	if not status_ok then
		print("Noice not found!")
		return
	end

	noice.setup(Options)
	setup_keymaps()
end
