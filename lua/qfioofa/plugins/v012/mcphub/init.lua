local function config()
	local ok, err = pcall(function()
		require("mcphub").setup(require("qfioofa.plugins.v012.mcphub.options"))
	end)
	if not ok then
		vim.notify(
			"[mcphub] setup failed: " .. tostring(err),
			vim.log.levels.ERROR
		)
	end
end

return {
	"ravitemer/mcphub.nvim",
	tag = "v6.2.0",
	build = "nvim --clean --headless -l bundled_build.lua",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	opts = require("qfioofa.plugins.v012.mcphub.options"),
	keys = require("qfioofa.plugins.v012.mcphub.keymaps"),
	config = config,
}
