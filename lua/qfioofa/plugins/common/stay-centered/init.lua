local function config()
	local ok, stay_centered = pcall(require, "stay-centered")
	if not ok then
		return
	end

	stay_centered.setup(require("qfioofa.plugins.common.stay-centered.options"))
end

return {
	"arnamak/stay-centered.nvim",
	config = config,
}
