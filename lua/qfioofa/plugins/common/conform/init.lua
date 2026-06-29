local function config()
	require("conform").setup(require("qfioofa.plugins.common.conform.options"))
end

return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	keys = require("qfioofa.plugins.common.conform.keymaps"),
	config = config,
}
