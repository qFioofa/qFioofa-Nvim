-- Every plugin lives in its own file under `lua/qfioofa/plugins/`.
-- lazy.nvim's `import` loads each of those files; every file returns a plugin
-- spec (or a list of specs).
local function main()
	local lazy = require("lazy")

	lazy.setup({
		spec = {
			{ import = "qfioofa.plugins" },
		},
	})
end

return main
