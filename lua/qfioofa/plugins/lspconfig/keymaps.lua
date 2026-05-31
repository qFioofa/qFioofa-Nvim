-- Buffer-local LSP mappings, applied from the LspAttach autocmd in init.lua.
return function(event)
	local client = vim.lsp.get_client_by_id(event.data.client_id)

	-- Toggle LSP on/off for the buffer.
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

	-- Open the diagnostics location list.
	vim.keymap.set("n", "<leader>to", function()
		local errs = vim.diagnostic.get(0)
		if #errs > 0 then
			vim.diagnostic.setloclist({ open = true })
		end
	end, { desc = "Open lsp error messages" })

	-- Toggle diagnostic visibility.
	vim.keymap.set("n", "<leader>te", function()
		local buf = vim.api.nvim_get_current_buf()
		local state = vim.diagnostic.is_enabled({ bufnr = buf })
		vim.diagnostic.enable(not state, { bufnr = buf })
		vim.notify(
			state and "Diagnostic hidden" or "Diagnostic shown",
			vim.log.levels.INFO
		)
	end, { desc = "Toggle Errors Visibility" })

	-- Helper that sets a buffer-local LSP mapping.
	local map = function(keys, func, desc)
		vim.keymap.set(
			"n",
			keys,
			func,
			{ buffer = event.buf, desc = "LSP: " .. desc }
		)
	end

	-- Jump to the definition of the word under your cursor.
	map(
		"gd",
		require("telescope.builtin").lsp_definitions,
		"[G]oto [D]efinition"
	)

	-- Find references for the word under your cursor.
	map(
		"gr",
		require("telescope.builtin").lsp_references,
		"[G]oto [R]eferences"
	)

	-- Jump to the implementation of the word under your cursor.
	map(
		"gI",
		require("telescope.builtin").lsp_implementations,
		"[G]oto [I]mplementation"
	)

	-- Jump to the type of the word under your cursor.
	map(
		"<leader>D",
		require("telescope.builtin").lsp_type_definitions,
		"Type [D]efinition"
	)

	-- Fuzzy find all the symbols in your current document.
	map(
		"<leader>ds",
		require("telescope.builtin").lsp_document_symbols,
		"[D]ocument [S]ymbols"
	)

	-- Fuzzy find all the symbols in your current workspace.
	map(
		"<leader>ws",
		require("telescope.builtin").lsp_dynamic_workspace_symbols,
		"[W]orkspace [S]ymbols"
	)

	-- Rename the variable under your cursor.
	map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

	-- Execute a code action.
	map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	-- Opens a popup that displays documentation about the word under your cursor.
	map("K", vim.lsp.buf.hover, "Hover Documentation")

	-- WARN: This is not Goto Definition, this is Goto Declaration.
	map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

	-- Enable inlay hints if the language server supports them.
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
