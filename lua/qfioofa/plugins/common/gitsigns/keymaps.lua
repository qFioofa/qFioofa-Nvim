local function gs()
	return require("gitsigns")
end

local function action(name)
	return function()
		gs()[name]()
	end
end

local function nav(direction)
	return function()
		if vim.wo.diff then
			vim.cmd("normal! " .. (direction == "next" and "]c" or "[c"))
		else
			gs().nav_hunk(direction)
		end
	end
end

local function ranged(name)
	return function()
		local mode = vim.fn.mode()
		if mode == "v" or mode == "V" or mode == "\22" then
			gs()[name]({ vim.fn.line("."), vim.fn.line("v") })
		else
			gs()[name]()
		end
	end
end

local function quickfix(all)
	return function()
		if all then
			gs().setqflist("all")
		else
			gs().setqflist()
		end
	end
end

return {
	{ "]c", nav("next"), desc = "Next hunk" },
	{ "[c", nav("prev"), desc = "Prev hunk" },

	{ "<leader>hp", action("preview_hunk"), desc = "Preview hunk" },
	{
		"<leader>hi",
		action("preview_hunk_inline"),
		desc = "Preview hunk inline",
	},
	{
		"<leader>hb",
		function()
			gs().blame_line({ full = true })
		end,
		desc = "Blame line",
	},
	{ "<leader>hB", "<cmd>Gitsigns blame<cr>", desc = "Blame file" },
	{ "<leader>hd", action("diffthis"), desc = "Diff this file" },
	{
		"<leader>hD",
		function()
			gs().diffthis("~")
		end,
		desc = "Diff against HEAD~",
	},
	{ "<leader>hq", quickfix(false), desc = "Hunks to quickfix" },
	{ "<leader>hQ", quickfix(true), desc = "All hunks to quickfix" },
	{
		"<leader>hs",
		ranged("stage_hunk"),
		mode = { "n", "v" },
		desc = "Stage hunk",
	},
	{
		"<leader>hr",
		ranged("reset_hunk"),
		mode = { "n", "v" },
		desc = "Reset hunk",
	},
	{ "<leader>hS", action("stage_buffer"), desc = "Stage buffer" },
	{ "<leader>hR", action("reset_buffer"), desc = "Reset buffer" },
	{ "<leader>hu", action("undo_stage_hunk"), desc = "Undo stage hunk" },
	{
		"ih",
		action("select_hunk"),
		mode = { "o", "x" },
		desc = "Select hunk",
	},

	{
		"<leader>tb",
		"<cmd>Gitsigns toggle_current_line_blame<cr>",
		desc = "Toggle line blame",
	},
	{
		"<leader>tw",
		"<cmd>Gitsigns toggle_word_diff<cr>",
		desc = "Toggle word diff",
	},
}
