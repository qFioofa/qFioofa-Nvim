-- which-key shows a popup of available keybindings as you type a prefix.
-- It auto-discovers any mapping that has a `desc`; the `spec` below only adds
-- human-readable names for the <leader> groups used across this config.
return {
	preset = "modern",
	delay = 300,
	spec = {
		{ "<leader>f", group = "Find" },
		{ "<leader>g", group = "Git / Goto" },
		{ "<leader>c", group = "Code" },
		{ "<leader>d", group = "Diagnostics / Delete" },
		{ "<leader>t", group = "Toggle / Terminal" },
		{ "<leader>n", group = "Noice" },
		{ "<leader>r", group = "Rename" },
		{ "<leader>w", group = "Workspace / Write" },
		{ "<leader>u", group = "UI / Notify" },
		{ "<leader>l", group = "LazyGit" },
		{ "<leader>a", group = "Auto-save" },
	},
}
