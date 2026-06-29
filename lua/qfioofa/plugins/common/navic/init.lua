local function config()
	local ok, navic = pcall(require, "nvim-navic")
	if not ok then
		return
	end

	navic.setup(require("qfioofa.plugins.common.navic.options"))
end

return {
	"SmiteshP/nvim-navic",
	dependencies = { "neovim/nvim-lspconfig" },
	config = config,
}
