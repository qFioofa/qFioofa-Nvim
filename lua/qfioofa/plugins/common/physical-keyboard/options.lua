return {
	enable = true,
	notify = "errors",
	active_layouts = { "ru" },
	fallback = "unique",
	toggle_key = "<leader>tk",
	detect = {
		enabled = true,
		remote = "auto",
		min_interval = 300,
		timeout = 500,
		events = { "FocusGained", "VimResume", "InsertLeave" },
		async = true,
	},
	langmap = {
		enabled = true,
	},
	mappings = {
		enabled = true,
		hack_keymap = true,
		automapping = true,
		modes = { "n", "x", "s", "o" },
		exclude = {},
		extra = {},
	},
	native = {
		enabled = true,
		commandline = true, -- clean :map/:nmap output
		api = true, -- clean Snacks/Telescope/which-key lists
	},
	cmdline = {
		enabled = true,
		aliases = { "JNew", "Telescope", "Lazy", "Mason", "checkhealth" },
		extra = {},
	},
	echo = {
		enabled = false,
		mode = "all",
	},
}
