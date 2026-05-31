-- Language servers to configure (and install via mason).
return {
	eslint = {},
	svelte = {},
	["typescript-language-server"] = {},
	["clang-format"] = {},
	["clangd"] = {},
	lua_ls = {
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
					enable = false,
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
