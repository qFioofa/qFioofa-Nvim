-- Language servers to configure (and install via mason).
-- Keys must be lspconfig server names (not mason package names). Formatters
-- like clang-format are handled separately by conform, not here.
return {
	eslint = {},
	svelte = {},

	-- Inlay hints must be enabled in the server settings, otherwise the
	-- <leader>th toggle in keymaps.lua has nothing to show.
	ts_ls = {
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
	},

	-- offsetEncoding pins utf-16 so clangd stops warning about multiple
	-- offset encodings when paired with cmp's capabilities.
	clangd = {
		capabilities = { offsetEncoding = { "utf-16" } },
		cmd = {
			"clangd",
			"--clang-tidy",
			"--header-insertion=iwyu",
		},
	},

	-- Python: pyright for types, ruff for fast linting + import sorting.
	pyright = {},
	ruff = {},

	gopls = {
		settings = {
			gopls = {
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
				staticcheck = true,
				analyses = {
					unusedparams = true,
					nilness = true,
					unusedwrite = true,
				},
			},
		},
	},

	bashls = {},
	dockerls = {},

	-- SQL (general + PostgreSQL). sql-language-server provides completion,
	-- linting and hover; formatting is handled by sql_formatter in conform.
	sqlls = {},

	-- TOML (taplo also provides formatting, used by conform below)
	taplo = {},

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
