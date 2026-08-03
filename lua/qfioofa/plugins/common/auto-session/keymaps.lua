-- Session save/restore. Lives under the <leader>s prefix alongside the Saga
-- bindings; <leader>ss / <leader>sr don't collide with any of them.
return {
	{ "<leader>ss", "<cmd>SessionSave<cr>", desc = "Session: save" },
	{ "<leader>sr", "<cmd>SessionRestore<cr>", desc = "Session: restore" },
}
