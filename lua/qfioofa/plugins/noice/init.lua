local function config()
	local ok, noice = pcall(require, "noice")
	if not ok then
		return
	end

	noice.setup(require("qfioofa.plugins.noice.options"))
	require("qfioofa.plugins.noice.keymaps")()
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
