local PACKAGE_NAME = "nvim-navic"

local Options = {
	lsp = {
		auto_attach = true,
	},
	highlight = true,
	separator = " > ",
	depth_limit = 0,
	depth_limit_indicator = "..",
}

return function()
	local status_ok, navic = pcall(require, PACKAGE_NAME)

	if not status_ok then
		return
	end

	navic.setup(Options)
end
