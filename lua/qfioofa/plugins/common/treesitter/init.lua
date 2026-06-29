return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	opts = require("qfioofa.plugins.common.treesitter.options"),
}
