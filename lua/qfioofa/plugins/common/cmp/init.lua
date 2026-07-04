local function config()
	require("colorful-menu").setup({})
	require("cmp").setup(require("qfioofa.plugins.common.cmp.options"))
end

return {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp",
		"xzbdmw/colorful-menu.nvim",
	},
	config = config,
}
