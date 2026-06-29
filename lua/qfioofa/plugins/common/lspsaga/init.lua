return {
	"nvimdev/lspsaga.nvim",
	event = "LspAttach",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = require("qfioofa.plugins.common.lspsaga.options"),
	keys = require("qfioofa.plugins.common.lspsaga.keymaps"),
}
