local function config()
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

			-- Highlight references of the word under the cursor on CursorHold.
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
		-- Formatters used by conform (LSP servers are added from `servers` above).
		-- gofmt ships with the Go toolchain, so it is not installed via Mason.
		"stylua",
		"black",
		"isort",
		"shfmt",
		"prettier",
		"sql-formatter",
	})
	require("mason-tool-installer").setup({
		ensure_installed = ensure_installed,
		-- Install missing tools on startup; fidget renders the progress UI.
		run_on_start = true,
	})

	-- Start a server only when its executable is actually on PATH. If the
	-- binary is missing (Mason still installing, or a Nix build that did not
	-- link), skip the start instead of letting Neovim crash the client with
	-- "quit with exit code 127", and remember it so the UI can report it.
	local missing = {}
	local function setup_server(server_name)
		local server = servers[server_name] or {}
		server.capabilities = vim.tbl_deep_extend(
			"force",
			{},
			capabilities,
			server.capabilities or {}
		)

		local cfg = vim.lsp.config[server_name]
		local cmd = cfg and cfg.cmd
		local exe = type(cmd) == "table" and cmd[1] or nil
		if exe and vim.fn.executable(exe) == 0 then
			missing[server_name] = true
			return false
		end

		missing[server_name] = nil
		require("lspconfig")[server_name].setup(server)
		return true
	end

	require("mason-lspconfig").setup({
		ensure_installed = vim.tbl_keys(servers or {}),
		handlers = {
			function(server_name)
				setup_server(server_name)
			end,
		},
	})

	-- When Mason finishes installing, start the servers that were skipped and
	-- re-fire FileType so they attach to already-open buffers — no restart.
	vim.api.nvim_create_autocmd("User", {
		pattern = "MasonToolsUpdateCompleted",
		callback = function()
			local started = {}
			for server_name in pairs(missing) do
				if setup_server(server_name) then
					table.insert(started, server_name)
				end
			end
			if next(missing) then
				vim.notify(
					"LSP not installed: "
						.. table.concat(vim.tbl_keys(missing), ", ")
						.. "\nRun :Mason to install.",
					vim.log.levels.WARN,
					{ title = "LSP" }
				)
			end
			if #started > 0 then
				vim.cmd("silent! doautoall FileType")
			end
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
