local function config()
	local ok, cmp = pcall(require, "cmp")
	if not ok then
		return
	end

	cmp.setup(require("qfioofa.plugins.cmp.options"))
end

return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = config,
}
