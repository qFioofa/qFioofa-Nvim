-- Language servers to configure (and install via mason).
-- Keys must be lspconfig server names (not mason package names). Formatters
-- like clang-format are handled separately by conform, not here.
return {
	eslint = {},
	svelte = {},
	ts_ls = {},
	clangd = {},
	lua_ls = {
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
					enable = true,
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = {
					enable = false,
				},
			},
		},
	},
}
