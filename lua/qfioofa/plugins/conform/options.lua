return {
	formatters_by_ft = {
		sh = { "shfmt" },
		bash = { "shfmt" },
		toml = { "taplo" },
		lua = { "stylua" },
		python = { "black", "isort" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		json = { "clang-format" },
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		markdown = { "prettier" },
		yaml = { "prettier" },
		rust = { "rustfmt" },
		go = { "gofmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		java = { "google-java-format" },
	},

	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},

	formatters = {},
}
