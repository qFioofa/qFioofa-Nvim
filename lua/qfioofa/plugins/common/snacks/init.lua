local function config()
	local ok, snacks = pcall(require, "snacks")
	if not ok then
		return
	end

	snacks.setup(require("qfioofa.plugins.common.snacks.options"))
end

return {
	"folke/snacks.nvim",
	priority = 1000,
	config = config,
}
