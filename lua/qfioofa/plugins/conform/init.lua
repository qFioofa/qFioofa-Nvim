local function config()
	local ok, conform = pcall(require, "conform")
	if not ok then
		return
	end

	conform.setup(require("qfioofa.plugins.conform.options"))
	require("qfioofa.plugins.conform.keymaps")()
end

return {
	"stevearc/conform.nvim",
	config = config,
}
