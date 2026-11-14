local function open_revision()
	vim.ui.input({ prompt = "Diffview revision: " }, function(rev)
		if rev and rev ~= "" then
			vim.cmd("DiffviewOpen " .. rev)
		end
	end)
end

return {
	{
		"<leader>gv",
		"<cmd>DiffviewOpen<cr>",
		desc = "Diffview: working tree",
	},
	{ "<leader>gV", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
	{
		"<leader>gF",
		function()
			vim.cmd("DiffviewFileHistory %")
		end,
		desc = "Diffview: file history",
	},
	{
		"<leader>gH",
		"<cmd>DiffviewFileHistory<cr>",
		desc = "Diffview: repo history",
	},
	{ "<leader>go", open_revision, desc = "Diffview: open revision" },
}
