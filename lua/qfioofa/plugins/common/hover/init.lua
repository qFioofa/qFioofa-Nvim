local function config()
	local ok, hover = pcall(require, "hover")
	if not ok then
		return
	end

	hover.config(require("qfioofa.plugins.common.hover.options"))
	require("qfioofa.plugins.common.hover.keymaps")()

	vim.o.mousemoveevent = true
end

return {
	"lewis6991/hover.nvim",
	config = config,
}
