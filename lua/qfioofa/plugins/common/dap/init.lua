return {
	"mfussenegger/nvim-dap",
	keys = {
		{
			"<leader>db",
			"<cmd>DapToggleBreakpoint<cr>",
			desc = "Debug: toggle breakpoint",
		},
		{
			"<leader>dc",
			"<cmd>DapContinue<cr>",
			desc = "Debug: continue / start",
		},
		{ "<leader>do", "<cmd>DapStepOver<cr>", desc = "Debug: step over" },
		{ "<leader>di", "<cmd>DapStepInto<cr>", desc = "Debug: step into" },
		{ "<leader>du", "<cmd>DapStepOut<cr>", desc = "Debug: step out" },
		{ "<leader>dr", "<cmd>DapToggleRepl<cr>", desc = "Debug: toggle REPL" },
		{ "<leader>dx", "<cmd>DapTerminate<cr>", desc = "Debug: terminate" },
	},
	config = function()
		vim.fn.sign_define(
			"DapBreakpoint",
			{ text = "", texthl = "DiagnosticSignError" }
		)
		-- The stopped marker is otherwise just a gutter glyph, easy to misread
		-- as sitting on a nearby line (e.g. a breakpoint on the function header).
		-- linehl/numhl highlight the whole current line so it's unmistakable.
		vim.fn.sign_define("DapStopped", {
			text = "",
			texthl = "DiagnosticSignWarn",
			linehl = "Visual",
			numhl = "DiagnosticSignWarn",
		})
	end,
}
