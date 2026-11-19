local function build_command()
	if vim.fn.has("win32") ~= 0 then
		return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource true"
	end
	return "make"
end

return {
	"yetone/avante.nvim",
	tag = "v0.5.0",
	priority = 10,
	build = build_command(),
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"ColinKennedy/mega.cmdparse",
		"ColinKennedy/mega.logging",
	},
	opts = require("qfioofa.plugins.v012.avante.options"),
	keys = require("qfioofa.plugins.v012.avante.keymaps"),
	config = function()
		require("qfioofa.plugins.v012.avante.config").setup()
	end,
}
