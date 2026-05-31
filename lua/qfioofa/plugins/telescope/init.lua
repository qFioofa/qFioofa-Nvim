local function config()
	require("telescope").setup(require("qfioofa.plugins.telescope.options"))
end

return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	keys = require("qfioofa.plugins.telescope.keymaps"),
	dependencies = {
		"nvim-telescope/telescope-media-files.nvim",
	},
	config = config,
}
