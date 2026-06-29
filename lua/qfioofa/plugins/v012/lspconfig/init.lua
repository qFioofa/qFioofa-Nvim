-- >=0.12: native capabilities + built-in vim.lsp.completion (no nvim-cmp).
local function config()
	vim.o.completeopt = "menuone,noselect,fuzzy"
	pcall(function()
		vim.o.autocomplete = true
	end)

	local capabilities = vim.lsp.protocol.make_client_capabilities()

	local function attach_hook(client, event)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(
				true,
				client.id,
				event.buf,
				{ autotrigger = true }
			)
		end
	end

	require("qfioofa.plugins.common.lspconfig.shared")(
		capabilities,
		attach_hook
	)
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
