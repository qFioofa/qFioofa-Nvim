-- lazy.nvim backend (<0.12): bootstrap lazy, import common + v011 specs.
local init_lazy = require("qfioofa.pluginManager.initManager")

local function main()
	init_lazy()
	require("lazy").setup({
		spec = {
			{ import = "qfioofa.plugins.common" },
			{ import = "qfioofa.plugins.v011" },
		},
	})
end

return main
