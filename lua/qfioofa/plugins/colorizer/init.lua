local function config()
	local ok, colorizer = pcall(require, "colorizer")
	if not ok then
		return
	end

	colorizer.setup(require("qfioofa.plugins.colorizer.options"))
end

return {
	"norcalli/nvim-colorizer.lua",
	config = config,
}
