local function config()
	local java_doc = require("qfioofa.plugins.common.neogen.javaDoc")
	require("neogen").setup({
		snippet_engine = "luasnip",
		languages = {
			java = java_doc,
		},
	})
end

local keys = require("qfioofa.plugins.common.neogen.keymaps")

return {
	"danymat/neogen",
	config = config,
	keys = keys,
}
