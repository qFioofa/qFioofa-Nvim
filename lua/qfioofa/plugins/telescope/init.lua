local function config()
	local ok, telescope = pcall(require, "telescope")
	if not ok then
		return
	end

	telescope.setup(require("qfioofa.plugins.telescope.options"))
	require("qfioofa.plugins.telescope.keymaps")()
end

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-telescope/telescope-media-files.nvim",
	},
	config = config,
}
