return {
	"meanderingprogrammer/render-markdown.nvim",
	ft = { "markdown" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-mini/mini.nvim",
	},
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		heading = {
			width = "block",
			left_pad = 0,
			right_pad = 1,
		},
		code = {
			width = "block",
			right_pad = 1,
		},
		indent = { enabled = false },
		pipe_table = {
			preset = "round",
			cell = "padded",
			alignment_indicator = "─",
		},
	},
	keys = {
		{
			"<leader>tm",
			"<cmd>RenderMarkdown toggle<cr>",
			desc = "Toggle markdown render",
		},
	},
}
