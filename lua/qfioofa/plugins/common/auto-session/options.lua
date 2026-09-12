return {
	auto_restore_last_session = false,
	suppressed_dirs = {
		"~/",
		"~/Projects",
		"~/Downloads",
		"/",
	},
	-- nvim-tree's "NvimTree_1" buffer/window must not be written into a
	-- session: restoring it recreates an empty file named NvimTree_1.
	pre_save_cmds = { "tabdo NvimTreeClose" },
	post_restore_cmds = {
		function()
			local ok, api = pcall(require, "nvim-tree.api")
			if ok and api and api.tree then
				api.tree.open()
			end
		end,
	},
}
