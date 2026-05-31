return {
	"nvim-treesitter/nvim-treesitter",
	commit = "42fc28b",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	dependencies = {
		"nvim-treesitter/playground",
	},
	opts = require("qfioofa.plugins.treesitter.options"),
}
