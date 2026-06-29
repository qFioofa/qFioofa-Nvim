local function buf_indent(ctx)
	local bo = vim.bo[ctx.buf]
	local width = bo.shiftwidth
	if width == 0 then
		width = bo.tabstop
	end
	return bo.expandtab, width
end

local function has_config(ctx, names)
	return vim.fs.find(names, { path = ctx.dirname, upward = true })[1] ~= nil
end

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
		elixir = { "mix" },
		heex = { "mix" },
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
		prettier = {
			prepend_args = function(_, ctx)
				if
					has_config(ctx, {
						".prettierrc",
						".prettierrc.json",
						".prettierrc.json5",
						".prettierrc.yml",
						".prettierrc.yaml",
						".prettierrc.toml",
						".prettierrc.js",
						".prettierrc.cjs",
						".prettierrc.mjs",
						"prettier.config.js",
						"prettier.config.cjs",
						"prettier.config.mjs",
					})
				then
					return {}
				end
				local expandtab, width = buf_indent(ctx)
				if expandtab then
					return { "--tab-width", tostring(width) }
				end
				return { "--use-tabs" }
			end,
		},

		taplo = {
			append_args = function(_, ctx)
				if has_config(ctx, { ".taplo.toml", "taplo.toml" }) then
					return {}
				end
				local expandtab, width = buf_indent(ctx)
				local str = expandtab and string.rep(" ", width) or "\t"
				return { "-o", "indent_string=" .. str }
			end,
		},

		sql_formatter = {
			append_args = function(_, ctx)
				if
					has_config(ctx, {
						".sql-formatter.json",
						".sqlformatterrc",
						".sqlformatterrc.json",
						"sql-formatter.config.json",
					})
				then
					return {}
				end
				local expandtab, width = buf_indent(ctx)
				return {
					"-c",
					vim.json.encode({
						language = "postgresql",
						tabWidth = width,
						useTabs = not expandtab,
					}),
				}
			end,
		},

		["clang-format"] = {
			prepend_args = function(_, ctx)
				if has_config(ctx, { ".clang-format", "_clang-format" }) then
					return { "--style=file" }
				end
				local expandtab, width = buf_indent(ctx)
				return {
					string.format(
						"--style={BasedOnStyle: LLVM, IndentWidth: %d, TabWidth: %d, UseTab: %s}",
						width,
						width,
						expandtab and "Never" or "ForIndentation"
					),
				}
			end,
		},
	},
}
