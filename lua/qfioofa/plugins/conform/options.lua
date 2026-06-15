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
		json = { "prettier" },
		jsonc = { "prettier" },
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
		sql = { "sql_formatter" },
		pgsql = { "sql_formatter" },
		mysql = { "sql_formatter" },
		plsql = { "sql_formatter" },
	},

	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},

	formatters = {
		-- Format with the PostgreSQL dialect so pg-specific syntax (e.g. casts,
		-- RETURNING, JSON operators) is preserved instead of being mangled.
		sql_formatter = {
			prepend_args = { "--language", "postgresql" },
		},
	},
}
