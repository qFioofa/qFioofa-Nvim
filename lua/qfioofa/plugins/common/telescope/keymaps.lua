-- Returned as a lazy.nvim `keys` spec so telescope only loads on first use.
local function builtin(name)
	return function()
		require("telescope.builtin")[name]()
	end
end

return {
	{ "<leader>ff", builtin("find_files"), desc = "Find Files" },
	{ "<leader>fg", builtin("live_grep"), desc = "Find in Files" },
	{ "<leader>fw", builtin("grep_string"), desc = "Find Word (under cursor)" },
	{
		"<leader>fb",
		builtin("current_buffer_fuzzy_find"),
		desc = "Find in Buffer",
	},
	{ "<leader>fr", builtin("oldfiles"), desc = "Recent Files" },
	{ "<leader>fh", builtin("help_tags"), desc = "Help Tags" },
	{ "<leader>fc", builtin("commands"), desc = "Commands" },
	{ "<leader>fk", builtin("keymaps"), desc = "Keymaps" },
	{ "<leader>fl", builtin("buffers"), desc = "List Buffers" },
	{ "<leader>fs", builtin("treesitter"), desc = "Treesitter Symbols" },
	{ "<leader>fd", builtin("diagnostics"), desc = "Diagnostics" },
	{
		"<leader>fm",
		function()
			require("telescope").extensions.media_files.media_files()
		end,
		desc = "Media Files",
	},
	{ "<leader>gf", builtin("git_files"), desc = "Git Files" },
	{ "<leader>gs", builtin("git_status"), desc = "Git Status" },
	{ "<leader>gc", builtin("git_commits"), desc = "Git Commits" },
	{ "<leader>gb", builtin("git_branches"), desc = "Git Branches" },
}
