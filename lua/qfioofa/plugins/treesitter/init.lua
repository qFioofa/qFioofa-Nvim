return {
	"nvim-treesitter/nvim-treesitter",
	-- Pinned for build/parser stability against the `master` branch API.
	-- Revisit periodically: bump the commit, then run `:TSUpdate` and verify
	-- highlighting/folds still work before keeping it.
	commit = "42fc28b",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	dependencies = {
		"nvim-treesitter/playground",
	},
	opts = require("qfioofa.plugins.treesitter.options"),
}
