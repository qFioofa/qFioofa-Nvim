local function config()
	require("colorizer").setup(require("qfioofa.plugins.common.colorizer.options"))
end

return {
	"norcalli/nvim-colorizer.lua",
	event = { "BufReadPost", "BufNewFile" },
	config = config,
}
