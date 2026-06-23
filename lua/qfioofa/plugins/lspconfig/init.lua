local function config()
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
			require("qfioofa.plugins.lspconfig.keymaps")(event)

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

			if client:supports_method("textDocument/foldingRange") then
				local win = vim.api.nvim_get_current_win()
				vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
				vim.wo[win][0].foldmethod = "expr"
			end

			if client:supports_method("textDocument/codeLens") then
				vim.lsp.codelens.refresh({ bufnr = event.buf })
				vim.api.nvim_create_autocmd(
					{ "BufEnter", "CursorHold", "InsertLeave" },
					{
						buffer = event.buf,
						group = highlight_augroup,
						callback = function()
							vim.lsp.codelens.refresh({ bufnr = event.buf })
						end,
					}
				)
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

	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	vim.lsp.config("*", { capabilities = capabilities })

	local servers = require("qfioofa.plugins.lspconfig.options")

	for server_name, server in pairs(servers) do
		vim.lsp.config(server_name, server)
	end

	-- UML LSP installation
	-- Install go
	-- sudo apt install golang-go
	--
	-- install lsp
	-- go install github.com/ptdewey/plantuml-lsp@latest
	-- Only wire up plantuml-lsp when both the language server and the
	-- `plantuml` renderer it shells out to are on PATH. Otherwise Neovim
	-- spawn-errors on every .puml/.uml buffer. Install with:
	--   go install github.com/ptdewey/plantuml-lsp@latest   (then add $(go env GOPATH)/bin to PATH)
	--   plus the `plantuml` package for the --exec-path=plantuml renderer.
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

	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		"stylua",
		"black",
		"isort",
		"shfmt",
		"prettier",
		"sql-formatter",
	})
	require("mason-tool-installer").setup({
		ensure_installed = ensure_installed,
		run_on_start = true,
	})

	-- Patch sql-language-server's bundled deps before it is started below, so
	-- an already-installed sqlls does not crash on Node strict `exports`.
	require("qfioofa.plugins.lspconfig.patch_sqlls").run()

	require("mason-lspconfig").setup({
		ensure_installed = vim.tbl_keys(servers or {}),
		-- We enable servers ourselves below, so mason-lspconfig must not auto
		-- enable everything it installed (that also pulls in formatters like
		-- stylua as bogus LSP clients).
		automatic_enable = false,
	})

	-- Enable our servers. `vim.lsp.enable` starts them on matching FileType,
	-- including buffers that are already open, so no restart is needed.
	vim.lsp.enable(vim.tbl_keys(servers or {}))

	-- Mason overwrites node_modules on (re)install, so re-apply the
	-- sql-language-server exports patch and (re)enable servers that were just
	-- installed — again without a restart.
	vim.api.nvim_create_autocmd("User", {
		pattern = "MasonToolsUpdateCompleted",
		callback = function()
			require("qfioofa.plugins.lspconfig.patch_sqlls").run()
			vim.lsp.enable(vim.tbl_keys(servers or {}))
		end,
	})
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = config,
}
