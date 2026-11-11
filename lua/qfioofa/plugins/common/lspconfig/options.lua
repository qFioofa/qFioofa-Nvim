-- Ruby LSP refuses to boot when the project's Ruby version does not match the
-- interpreter running the server: Bundler raises RubyVersionMismatch while
-- composing the bundle. Detect that mismatch and fall back to running without
-- the project bundle. Setting BUNDLE_GEMFILE makes ruby-lsp skip its composed
-- bundle setup (see ruby-lsp's exe/ruby-lsp), so /dev/null is used as a
-- sentinel. Indexing/navigation still work; only project-gem features (Rails
-- addon, rubocop, ...) are unavailable until a matching Ruby is used.
local function project_ruby_version(root)
	if not root or root == "" then
		return nil
	end

	local version_file = root .. "/.ruby-version"
	if vim.fn.filereadable(version_file) == 1 then
		local line = vim.fn.readfile(version_file)[1]
		local version = line
			and line:gsub("^ruby%-", ""):match("^%d+%.%d+%.%d+")
		if version then
			return version
		end
	end

	local gemfile = root .. "/Gemfile"
	if vim.fn.filereadable(gemfile) == 1 then
		for _, line in ipairs(vim.fn.readfile(gemfile)) do
			local version = line:match("^%s*ruby%s+[\"']([%d%.]+)[\"']")
			if version and version:match("^%d+%.%d+%.%d+$") then
				return version
			end
		end
	end

	return nil
end

local function running_ruby_version()
	local out = vim.fn.systemlist({ "ruby", "-e", "print RUBY_VERSION" })
	if vim.v.shell_error ~= 0 then
		return nil
	end
	return out[1]
end

local function ruby_lsp_cmd(dispatchers, config)
	local root = config and config.root_dir or vim.fn.getcwd()
	local wanted = project_ruby_version(root)
	local running = running_ruby_version()
	local env = config and config.cmd_env or {}
	local cmd = { "ruby-lsp" }

	-- The NixOS `ruby312` wrapper runs ruby-lsp on the exact Ruby 3.1.2 with
	-- the project bundle, so gems get indexed. Without it, fall back to the
	-- bundled server and skip Bundler when the versions disagree.
	if wanted == "3.1.2" and vim.fn.executable("ruby312") == 1 then
		local composed = root .. "/.ruby-lsp/Gemfile"
		if vim.fn.filereadable(composed) == 1 then
			-- Skip SetupBundler's slow bundle check; the composed bundle
			-- exists and bundle exec starts the server in ~1s.
			cmd = { "ruby312", "bundle", "exec", "ruby-lsp" }
			env = vim.tbl_extend("force", env, {
				BUNDLE_GEMFILE = composed,
			})
		else
			cmd = { "ruby312", "ruby-lsp" }
		end
	elseif wanted and running and wanted ~= running then
		env = vim.tbl_extend("force", env, {
			BUNDLE_GEMFILE = "/dev/null",
		})
	end

	return vim.lsp.rpc.start(cmd, dispatchers, {
		cwd = config and (config.cmd_cwd or config.root_dir) or nil,
		env = next(env) and env or nil,
	})
end

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

	-- C#. mason's omnisharp package ships a self-contained build, so no system
	-- dotnet SDK is needed just for completion/diagnostics.
	omnisharp = {},

	-- Swift. sourcekit-lsp has no mason package: it comes with the Swift
	-- toolchain (Xcode / swiftly), so shared.lua skips it when installing.
	sourcekit = {},

	-- Python: pyright for types, ruff for fast linting + import sorting.
	-- autoImportCompletions feeds imports straight into <Tab>/<C-Space>
	-- completion; importFormat="absolute" keeps a pyproject/`.venv`-portable
	-- import style. `autoImport` is the older pyright key, kept so this config
	-- still works across pyright versions.
	pyright = {
		settings = {
			python = {
				analysis = {
					autoImportCompletions = true,
					autoImport = true,
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					importFormat = "absolute",
				},
			},
		},
	},
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

	-- Elixir + Erlang. elixirls covers .ex/.exs/.heex; elp covers .erl.
	-- erlangls was dropped: nvim-lspconfig no longer ships an lsp/erlangls.lua
	-- (so cmd is nil and it crash-loops on every buffer), and its mason package
	-- builds from source via rebar3, which isn't installed. elp (Erlang Language
	-- Platform) ships a prebuilt mason binary and a working default config.
	elixirls = {},
	elp = {},

	-- Ruby. ruby-lsp (by Shopify) auto-detects Rails projects, bundles rubocop
	-- diagnostics, and provides inlay hints for Ruby 3.1+.
	--
	-- Positions are pinned to UTF-16: ruby-lsp's UTF-8 scanner counts code
	-- points while the LSP utf-8 encoding (and Neovim) measures bytes, so any
	-- multibyte content (e.g. Cyrillic) drives positions past the end of the
	-- line and ruby-lsp raises InvalidLocationError on hover/signature/completion.
	-- Its Utf16Scanner is correct, and Neovim converts utf-16 natively.
	ruby_lsp = {
		cmd = ruby_lsp_cmd,
		capabilities = {
			general = {
				positionEncodings = { "utf-16" },
			},
		},
	},

	-- SQL (general + PostgreSQL). sql-language-server provides completion,
	-- linting and hover; formatting is handled by sql_formatter in conform.
	sqlls = {},

	-- TOML (taplo also provides formatting, used by conform below)
	taplo = {},

	marksman = {},
	lemminx = {},

	-- Typst. tinymist bundles its own typst compiler for the LSP; the standalone
	-- `typst` CLI for building docs comes from nixos (cli.nix).
	tinymist = {},

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
