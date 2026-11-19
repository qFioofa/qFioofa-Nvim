local M = {}

function M.global()
	vim.keymap.set("n", "<leader>eb", function()
		require("neo-tree.command").execute({
			toggle = true,
			source = "buffers",
			position = "right",
		})
	end, {
		noremap = true,
		silent = true,
		desc = "Toggle buffer explorer",
	})
end

return M
