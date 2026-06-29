-- Returned as a lazy.nvim `keys` spec so lspsaga loads on first use.
-- Scoped under the free <leader>s ("Saga") prefix — <leader>l is LazyGit and
-- <leader>d/<leader>c are taken by dap/code maps. This is the floating LSP
-- "what's running / what's broken" UI the user wanted.
return {
	{
		"<leader>sd",
		"<cmd>Lspsaga show_buf_diagnostics<cr>",
		desc = "Saga: buffer diagnostics (float)",
	},
	{
		"<leader>sw",
		"<cmd>Lspsaga show_workspace_diagnostics<cr>",
		desc = "Saga: workspace diagnostics (float)",
	},
	{
		"<leader>so",
		"<cmd>Lspsaga outline<cr>",
		desc = "Saga: symbols outline",
	},
	{
		"<leader>sf",
		"<cmd>Lspsaga finder<cr>",
		desc = "Saga: finder (refs/defs/impl)",
	},
}
