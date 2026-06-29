local function config()
	local ok, tabout = pcall(require, "tabout")
	if not ok then
		return
	end

	tabout.setup(require("qfioofa.plugins.common.tabout.options"))
end

return {
	"abecodes/tabout.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = config,
}
