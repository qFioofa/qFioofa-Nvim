-- Buffer-local LSP mappings, applied from the LspAttach autocmd in init.lua.
return function(event)
	local client = vim.lsp.get_client_by_id(event.data.client_id)

	vim.keymap.set("n", "<leader>tl", function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		if next(clients) then
			for _, c in ipairs(clients) do
				vim.lsp.buf_detach_client(0, c.id)
			end
			vim.notify("LSP OFF", vim.log.levels.WARN)
		else
			vim.cmd("edit")
			vim.notify("LSP ON", vim.log.levels.INFO)
		end
	end, { desc = "Toggle LSP (Detach/Reload)" })

	vim.keymap.set("n", "<leader>to", function()
		local errs = vim.diagnostic.get(0)
		if #errs > 0 then
			vim.diagnostic.setloclist({ open = true })
		end
	end, { desc = "Open lsp error messages" })

	vim.keymap.set("n", "<leader>te", function()
		local buf = vim.api.nvim_get_current_buf()
		local state = vim.diagnostic.is_enabled({ bufnr = buf })
		vim.diagnostic.enable(not state, { bufnr = buf })
		vim.notify(
			state and "Diagnostic hidden" or "Diagnostic shown",
			vim.log.levels.INFO
		)
	end, { desc = "Toggle Errors Visibility" })

	local map = function(keys, func, desc)
		vim.keymap.set(
			"n",
			keys,
			func,
			{ buffer = event.buf, desc = "LSP: " .. desc }
		)
	end

	map(
		"gd",
		require("telescope.builtin").lsp_definitions,
		"[G]oto [D]efinition"
	)
	map(
		"gr",
		require("telescope.builtin").lsp_references,
		"[G]oto [R]eferences"
	)
	map(
		"gI",
		require("telescope.builtin").lsp_implementations,
		"[G]oto [I]mplementation"
	)
	map(
		"<leader>D",
		require("telescope.builtin").lsp_type_definitions,
		"Type [D]efinition"
	)
	map(
		"<leader>ds",
		require("telescope.builtin").lsp_document_symbols,
		"[D]ocument [S]ymbols"
	)
	map(
		"<leader>ws",
		require("telescope.builtin").lsp_dynamic_workspace_symbols,
		"[W]orkspace [S]ymbols"
	)
	map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	-- Note: `K` (hover documentation) is handled by hover.nvim, which already
	-- includes an LSP source, so it is intentionally not mapped here.

	-- WARN: This is not Goto Definition, this is Goto Declaration.
	map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

	-- Run the CodeLens on the current line (e.g. gopls "run test | debug").
	-- Lenses are refreshed from the LspAttach autocmd in init.lua.
	if client and client:supports_method("textDocument/codeLens") then
		map("<leader>cl", vim.lsp.codelens.run, "[C]ode [L]ens run")
	end

	if
		client
		and client.server_capabilities.inlayHintProvider
		and vim.lsp.inlay_hint
	then
		map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, "[T]oggle Inlay [H]ints")
	end
end
