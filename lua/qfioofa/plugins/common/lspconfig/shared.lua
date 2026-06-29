-- Profile-agnostic LSP setup. Callers differ only in `capabilities` (cmp vs
-- native) and the optional `attach_hook` (pack uses it for native completion).
local function setup(capabilities, attach_hook)
	vim.o.winborder = "rounded"
	vim.o.exrc = true

	local function set_lsp_hl()
		vim.api.nvim_set_hl(0, "LspReferenceText", { link = "Visual" })
		vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "Visual" })
		vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "Visual" })
		vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })
	end
	set_lsp_hl()
	vim.api.nvim_create_autocmd("ColorScheme", { callback = set_lsp_hl })

	local highlight_augroup = vim.api.nvim_create_augroup(
		"kickstart-lsp-highlight",
		{ clear = false }
	)

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup(
			"kickstart-lsp-attach",
			{ clear = true }
		),
		callback = function(event)
			require("qfioofa.plugins.common.lspconfig.keymaps")(event)

			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if
				client
				and client.server_capabilities.documentHighlightProvider
			then
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})
			end

			if not client then
				return
			end

			if client.name == "ruff" then
				client.server_capabilities.hoverProvider = false
			end

			if attach_hook then
				attach_hook(client, event)
			end
		end,
	})

	vim.api.nvim_create_autocmd("LspDetach", {
		group = vim.api.nvim_create_augroup(
			"kickstart-lsp-detach",
			{ clear = true }
		),
		callback = function(event)
			vim.lsp.buf.clear_references()
			vim.api.nvim_clear_autocmds({
				group = "kickstart-lsp-highlight",
				buffer = event.buf,
			})
		end,
	})

	vim.lsp.config("*", { capabilities = capabilities })

	local servers = require("qfioofa.plugins.common.lspconfig.options")
	for server_name, server in pairs(servers) do
		vim.lsp.config(server_name, server)
	end

	-- Only wire plantuml-lsp when both it and the `plantuml` renderer are on
	-- PATH, else Neovim spawn-errors on every .puml/.uml buffer.
	if
		vim.fn.executable("plantuml-lsp") == 1
		and vim.fn.executable("plantuml") == 1
	then
		vim.lsp.config("plantuml_lsp", {
			cmd = { "plantuml-lsp", "--exec-path=plantuml" },
			filetypes = { "plantuml", "uml", "puml" },
			root_markers = { ".git" },
		})
		vim.lsp.enable("plantuml_lsp")
	end

	vim.diagnostic.config({
		virtual_text = false,
		virtual_lines = { current_line = true },
		underline = true,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚",
				[vim.diagnostic.severity.WARN] = "󰀪",
				[vim.diagnostic.severity.HINT] = "󰌶",
				[vim.diagnostic.severity.INFO] = "󰋽",
			},
			numhl = {
				[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
				[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			},
		},
	})

	require("mason").setup()

	-- jdtls is started in languages/java.lua, not via vim.lsp.config, so it
	-- stays out of options.lua; installed here alongside formatters.
	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		"stylua",
		"black",
		"isort",
		"shfmt",
		"prettier",
		"sql-formatter",
		"jdtls",
		"java-debug-adapter",
		"java-test",
		"google-java-format",
	})

	-- Swallow per-package install errors and report them once below.
	local failed_installs = {}
	local base_notify = vim.notify
	vim.notify = function(msg, level, opts)
		if
			type(msg) == "string"
			and opts
			and opts.title == "mason-tool-installer"
			and level == vim.log.levels.ERROR
		then
			failed_installs[#failed_installs + 1] = msg:match(
				"^(.-): failed to install"
			) or msg
			return
		end
		return base_notify(msg, level, opts)
	end

	require("mason-tool-installer").setup({
		ensure_installed = ensure_installed,
		run_on_start = true,
	})

	require("qfioofa.plugins.common.lspconfig.patch_sqlls").run()

	-- mason-tool-installer is the SOLE installer; a second runner races it on
	-- lockfiles. mason-lspconfig only provides name mapping here.
	require("mason-lspconfig").setup({ automatic_enable = false })

	vim.lsp.enable(vim.tbl_keys(servers or {}))

	-- Mason overwrites node_modules on (re)install, so re-patch sqlls and
	-- re-enable just-installed servers without a restart.
	vim.api.nvim_create_autocmd("User", {
		pattern = "MasonToolsUpdateCompleted",
		callback = function()
			require("qfioofa.plugins.common.lspconfig.patch_sqlls").run()
			vim.lsp.enable(vim.tbl_keys(servers or {}))

			if #failed_installs > 0 then
				base_notify(
					"Mason: failed to install "
						.. #failed_installs
						.. " tool(s): "
						.. table.concat(failed_installs, ", "),
					vim.log.levels.ERROR,
					{ title = "Mason" }
				)
				failed_installs = {}
			end
		end,
	})
end

return setup
