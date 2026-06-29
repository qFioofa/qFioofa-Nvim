-- <0.12: capabilities from cmp_nvim_lsp.
local function config()
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	require("qfioofa.plugins.common.lspconfig.shared")(capabilities)
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = config,
}
