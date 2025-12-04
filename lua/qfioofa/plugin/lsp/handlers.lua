local highlight_augroup_name = "kickstart-lsp-highlight"
local attach_augroup_name = "kickstart-lsp-attach"
local detach_augroup_name = "kickstart-lsp-detach"

local function create_map(keys, func, desc, mode, event)
	mode = mode or "n"
	vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
end

local function setup_document_highlight(bufnr, client_id)
	local highlight_augroup = vim.api.nvim_create_augroup(highlight_augroup_name, { clear = false })

	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		buffer = bufnr,
		group = highlight_augroup,
		callback = vim.lsp.buf.document_highlight,
	})

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		buffer = bufnr,
		group = highlight_augroup,
		callback = vim.lsp.buf.clear_references,
	})

	vim.api.nvim_create_autocmd("LspDetach", {
		group = vim.api.nvim_create_augroup(detach_augroup_name, { clear = true }),
		callback = function(event2)
			vim.lsp.buf.clear_references()
			vim.api.nvim_clear_autocmds({
				group = highlight_augroup_name,
				buffer = event2.buf,
			})
		end,
	})
end

local function setup_keymaps(event)
	create_map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition", "n", event)
	create_map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences", "n", event)
	create_map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation", "n", event)
	create_map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition", "n", event)

	create_map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols", "n", event)
	create_map(
		"<leader>ws",
		require("telescope.builtin").lsp_dynamic_workspace_symbols,
		"[W]orkspace [S]ymbols",
		"n",
		event
	)

	create_map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame", "n", event)
	create_map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" }, event)

	create_map("<leader>cA", function()
		vim.lsp.buf.code_action({
			context = {
				only = { "source" },
				diagnostics = {},
			},
		})
	end, "[C]ode [A]ction on buffer", { "n", "x" }, event)

	create_map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration", "n", event)
end

local function setup_inlay_hints(event)
	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
		create_map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
		end, "[T]oggle Inlay [H]ints", "n", event)
	end
end

return function()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup(attach_augroup_name, { clear = true }),
		callback = function(event)
			setup_keymaps(event)

			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
				setup_document_highlight(event.buf, client.id)
			end

			setup_inlay_hints(event)
		end,
	})
end
