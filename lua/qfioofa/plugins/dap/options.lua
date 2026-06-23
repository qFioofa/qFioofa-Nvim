-- nvim-dap-ui layout/appearance options.
return {
	controls = {
		element = "repl",
		enabled = false,
		icons = {
			disconnect = "",
			pause = "",
			play = "",
			run_last = "",
			step_back = "",
			step_into = "",
			step_out = "",
			step_over = "",
			terminate = "",
		},
	},
	element_mappings = {},
	expand_lines = true,
	floating = {
		border = "rounded",
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	force_buffers = true,
	icons = {
		collapsed = "",
		current_frame = "",
		expanded = "",
	},
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.50 },
				{ id = "stacks", size = 0.30 },
				{ id = "watches", size = 0.10 },
				{ id = "breakpoints", size = 0.10 },
			},
			size = 40,
			position = "left",
		},
		{
			elements = { "repl", "console" },
			size = 10,
			position = "bottom",
		},
	},
	mappings = {
		edit = "e",
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		repl = "r",
		toggle = "t",
	},
	render = {
		indent = 1,
		max_value_lines = 100,
	},
}
