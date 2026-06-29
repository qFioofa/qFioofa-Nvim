local function config()
	local ok, lualine = pcall(require, "lualine")
	if not ok then
		return
	end

	lualine.setup(require("qfioofa.plugins.common.lualine.options"))
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = config,
}
