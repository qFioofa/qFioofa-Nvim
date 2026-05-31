local function config()
	local ok, npairs = pcall(require, "nvim-autopairs")
	if not ok then
		return
	end

	npairs.setup(require("qfioofa.plugins.autopairs.options"))
end

return {
	"windwp/nvim-autopairs",
	config = config,
}
