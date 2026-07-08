local function config()
	local ok, ls = pcall(require, "luasnip")
	if not ok then
		return
	end

	ls.config.setup({ update_events = "TextChanged,TextChangedI" })

	require("luasnip.loaders.from_vscode").lazy_load()

	-- Loading own snippers
	require("luasnip.loaders.from_lua").lazy_load({
		paths = { vim.fn.stdpath("config") .. "/snippets" },
	})
end

return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
	},
	config = config,
}
