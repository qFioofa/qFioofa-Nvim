local function config()
	local java_doc = require("qfioofa.plugins.common.neogen.java-doc")
	require("neogen").setup({
		snippet_engine = "luasnip",
		languages = {
			java = java_doc,
		},
	})
end

return {
	"danymat/neogen",
	config = config,
	keys = {
		{ "<leader>nd", "<cmd>Neogen<cr>", desc = "Generate Javadoc" },
	},
}
