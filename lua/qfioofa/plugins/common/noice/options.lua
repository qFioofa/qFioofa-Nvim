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
		-- Skip jdtls edit-time validation progress; keep init/build progress
		{
			filter = {
				event = "lsp",
				kind = "progress",
				cond = function(msg)
					local p = vim.tbl_get(msg, "opts", "progress")
					return p ~= nil
						and p.client == "jdtls"
						and (p.title or ""):find("Validat") ~= nil
				end,
			},
			opts = { skip = true },
		},
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
		enabled = false,
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

return {
	cmdline = {
		enabled = true,
		view = "cmdline_popup",
	},
	messages = {
		enabled = true,
		view = "notify",
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
