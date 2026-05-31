-- Language servers to configure (and install via mason).
-- Keys must be lspconfig server names (not mason package names). Formatters
-- like clang-format are handled separately by conform, not here.
return {
	eslint = {},
	svelte = {},
	ts_ls = {},
	clangd = {},

	-- Python: pyright for types, ruff for fast linting + import sorting.
	pyright = {},
	ruff = {},

	-- Go
	gopls = {},

	-- Bash / shell
	bashls = {},

	-- Docker
	dockerls = {},

	-- TOML (taplo also provides formatting, used by conform below)
	taplo = {},

	-- Markdown / XML
	marksman = {},
	lemminx = {},

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
