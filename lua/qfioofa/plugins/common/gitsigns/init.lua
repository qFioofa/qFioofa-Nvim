local function config()
	require("gitsigns").setup(
		require("qfioofa.plugins.common.gitsigns.options")
	)
end

return {
	"lewis6991/gitsigns.nvim",
	config = config,
	keys = require("qfioofa.plugins.common.gitsigns.keymaps"),
}
