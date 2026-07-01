local function config()
	require("nvim-treesitter.configs").setup(
		require("qfioofa.plugins.common.treesitter.options")
	)
	-- Fix master-branch directive crashes on nvim 0.12 (see patch.lua).
	require("qfioofa.plugins.common.treesitter.patch")()
end

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	config = config,
}
