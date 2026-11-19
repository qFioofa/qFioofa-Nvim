local function neo_tree(command)
	local ok, api = pcall(require, "neo-tree.command")
	if ok then
		api.execute(command)
	end
end

return {
	auto_restore_last_session = false,
	suppressed_dirs = {
		"~/",
		"~/Projects",
		"~/Downloads",
		"/",
	},
	-- Sidebar buffers (NvimTree_1, "neo-tree buffers") must not be written
	-- into a session: restoring them recreates empty files/windows.
	pre_save_cmds = {
		"tabdo NvimTreeClose",
		function()
			neo_tree({ action = "close", source = "buffers" })
		end,
	},
	post_restore_cmds = {
		function()
			local ok, api = pcall(require, "nvim-tree.api")
			if ok and api and api.tree then
				api.tree.open()
			end
		end,
		function()
			neo_tree({ action = "show", source = "buffers", position = "right" })
		end,
	},
}
