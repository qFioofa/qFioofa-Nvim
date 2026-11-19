local function open_on_start()
	local ok, command = pcall(require, "neo-tree.command")
	if not ok then
		return
	end

	command.execute({
		action = "show",
		source = "buffers",
		position = "right",
	})
end

local function config()
	local ok, neo_tree = pcall(require, "neo-tree")
	if not ok then
		return
	end

	neo_tree.setup(require("qfioofa.plugins.common.neo-tree.options"))
	require("qfioofa.plugins.common.neo-tree.keymaps").global()

	vim.api.nvim_create_autocmd("VimEnter", {
		group = vim.api.nvim_create_augroup(
			"qfioofa_neo_tree",
			{ clear = true }
		),
		once = true,
		callback = open_on_start,
	})
end

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = config,
}
