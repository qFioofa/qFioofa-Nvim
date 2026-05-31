-- Language servers to configure (and install via mason).
-- Keys must be lspconfig server names (not mason package names). Formatters
-- like clang-format are handled separately by conform, not here.
return {
	eslint = {},
	svelte = {},
	ts_ls = {},
	clangd = {},
	lua_ls = {
		-- `workspace.library` is intentionally omitted: neodev (a dependency in
		-- this plugin spec) configures the runtime library for Neovim Lua dev,
		-- which is cheaper than scanning the whole runtime path here.
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
					enable = true,
				},
				telemetry = {
					enable = false,
				},
			},
		},
	},
}
