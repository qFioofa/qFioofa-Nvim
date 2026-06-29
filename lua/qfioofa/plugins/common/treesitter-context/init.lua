local function config()
	local ok, context = pcall(require, "treesitter-context")
	if not ok then
		return
	end

	context.setup(require("qfioofa.plugins.common.treesitter-context.options"))
end

return {
	"nvim-treesitter/nvim-treesitter-context",
	event = "BufReadPost",
	config = config,
}
