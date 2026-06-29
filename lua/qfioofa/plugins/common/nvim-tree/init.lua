local function config()
	local ok, nvim_tree = pcall(require, "nvim-tree")
	if not ok then
		return
	end

	local keymaps = require("qfioofa.plugins.common.nvim-tree.keymaps")
	local options = require("qfioofa.plugins.common.nvim-tree.options")
	options.on_attach = keymaps.on_attach

	nvim_tree.setup(options)
	keymaps.global()
end

return {
	"kyazdani42/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = config,
}
