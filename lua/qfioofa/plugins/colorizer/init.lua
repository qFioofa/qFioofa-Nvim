local function config()
	require("colorizer").setup(require("qfioofa.plugins.colorizer.options"))
end

return {
	"norcalli/nvim-colorizer.lua",
	event = { "BufReadPost", "BufNewFile" },
	config = config,
}
