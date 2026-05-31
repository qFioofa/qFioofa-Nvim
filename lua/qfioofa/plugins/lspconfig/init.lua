local function config()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup(
			"kickstart-lsp-attach",
			{ clear = true }
		),
		callback = function(event)
			require("qfioofa.plugins.lspconfig.keymaps")(event)

			-- Highlight references of the word under the cursor on CursorHold.
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if
				client
				and client.server_capabilities.documentHighlightProvider
			then
				local highlight_augroup = vim.api.nvim_create_augroup(
					"kickstart-lsp-highlight",
					{ clear = false }
				)
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

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = vim.tbl_deep_extend(
		"force",
		capabilities,
		require("cmp_nvim_lsp").default_capabilities()
	)

	local servers = require("qfioofa.plugins.lspconfig.options")

	-- UML LSP installation
	-- Install go
	-- sudo apt install golang-go
	--
	-- install lsp
	-- go install github.com/ptdewey/plantuml-lsp@latest
	local lspconfig = require("lspconfig")
	local configs = require("lspconfig.configs")
	if not configs.plantuml_lsp then
		configs.plantuml_lsp = {
			default_config = {
				cmd = {
					"plantuml-lsp",
					"--exec-path=plantuml",
				},
				filetypes = { "plantuml", "uml", "puml" },
				root_dir = function(fname)
					return lspconfig.util.root_pattern(".git")(fname)
						or vim.fs.dirname(fname)
				end,
				settings = {},
			},
		}
	end
	lspconfig.plantuml_lsp.setup({})

	vim.diagnostic.config({
		virtual_text = true,
		signs = false,
		underline = true,
	})

	require("mason").setup()

	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		"stylua",
	})
	require("mason-tool-installer").setup({
		ensure_installed = ensure_installed,
	})

	require("mason-lspconfig").setup({
		ensure_installed = vim.tbl_keys(servers or {}),
		handlers = {
			function(server_name)
				local server = servers[server_name] or {}
				server.capabilities = vim.tbl_deep_extend(
					"force",
					{},
					capabilities,
					server.capabilities or {}
				)
				require("lspconfig")[server_name].setup(server)
			end,
		},
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
