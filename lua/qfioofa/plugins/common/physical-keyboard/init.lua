return {
	"qFioofa/physical-keyboard.nvim",
	event = "VeryLazy",
	opts = require("qfioofa.plugins.common.physical-keyboard.options"),
	keys = {
		{ "<leader>kp", "<cmd>PhyKeyboardUI<cr>", desc = "Physical keyboard UI" },
	},
}
