return {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			disable = { "undefined-globa" },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
				maxPreload = 2000,
				preloadFileSize = 1000,
			},
			telemetry = {
				enable = false,
			},
			hint = {
				enable = true,
				arrayIndex = "Disable",
				await = true,
				paramName = "All",
				paramType = true,
				semicolon = "All",
				setType = true,
			},
			completion = {
				callSnippet = "Replace",
				keywordSnippet = "Replace",
			},
		},
		emmyLua = {
			diagnostics = {
				disable = { "undefined-global" },
			},
		},
	},
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
}
