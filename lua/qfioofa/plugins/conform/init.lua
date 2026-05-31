local function config()
	require("conform").setup(require("qfioofa.plugins.conform.options"))
end

return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	keys = require("qfioofa.plugins.conform.keymaps"),
	config = config,
}
