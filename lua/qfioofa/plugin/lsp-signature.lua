local PACKAGE_NAME = "lsp_singature"

local Options = {
	bind = true,
	handler_opts = {
		border = "rounded",
	},
}

return function()
	local status_ok, lsp_singature = pcall(require, PACKAGE_NAME)
	if not status_ok then
		return
	end

	lsp_singature.setup(Options)
end
