local settings = {
	Lua = {
		completion = {
			callSnippet = "Replace",
		},
		diagnostics = {
			globals = { "vim" },
		},
		workspace = {
			library = {
				[vim.fn.expand("$VIMRUNTIME/lua")] = true,
				[vim.fn.stdpath("config") .. "/lua"] = true,
			},
			checkThirdParty = false,
		},
		telemetry = {
			enable = false,
		},
	},
}

return function()
	return {
		settings = settings,
	}
end
