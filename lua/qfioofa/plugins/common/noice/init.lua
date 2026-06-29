local function config()
	local ok, noice = pcall(require, "noice")
	if not ok then
		return
	end

	noice.setup(require("qfioofa.plugins.common.noice.options"))
	require("qfioofa.plugins.common.noice.keymaps")()
end

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = config,
}
