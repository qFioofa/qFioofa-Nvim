local utils = require("qfioofa.utils")
local lspRoot = utils.roots.plugins .. "lsp."

local ensure_installed_extra = { "stylua" }

local function setup_mason()
	require("mason").setup()
end

local function setup_mason_tools(servers_list)
	local ensure_installed = vim.tbl_keys(servers_list or {})
	vim.list_extend(ensure_installed, ensure_installed_extra)
	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
end

local function setup_mason_lspconfig(servers)
	require("mason-lspconfig").setup({
		handlers = {
			function(server_name)
				local server = servers[server_name]
				if server then
					local capabilities = require("lsp.capabilities").get_capabilities()
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				else
					require("lspconfig")[server_name].setup({})
				end
			end,
		},
	})
end

return function()
	require(lspRoot .. "handlers")
	require(lspRoot .. "capabilities")

	setup_mason()

	local servers = require(lspRoot .. "servers")
	setup_mason_tools(servers)
	setup_mason_lspconfig(servers)
end
