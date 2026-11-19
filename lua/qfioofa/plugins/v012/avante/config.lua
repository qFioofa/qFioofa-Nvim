local M = {}

function M.setup()
	local opts = require("qfioofa.plugins.v012.avante.options")
	local shortcuts = require("qfioofa.plugins.v012.avante.shortcuts")
	opts.shortcuts =
		vim.list_extend(vim.deepcopy(opts.shortcuts or {}), shortcuts.load())
	require("avante").setup(opts)
	require("qfioofa.plugins.v012.avante.mode").apply()
end

return M
