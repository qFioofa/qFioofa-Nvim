local function config()
	local java_doc = require("java-doc")
	require("neogen").setup({
		snippet_engine = "luasnip",
		languages = {
			java = java_doc,
		},
	})
end

return {
	"danymat/neogen",
	dependencies = { "nvim-treesitter/nvim-treesitter", "L3MON4D3/LuaSnip" },
	config = config,
	keys = {
		{ "<leader>nd", "<cmd>Neogen<cr>", desc = "Generate Javadoc" },
	},
}
