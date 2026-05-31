local M = {}

local function configure_bindings()
	return {
		{ key = "w", action = "edit", desc = "Open file/folder" },
		{ key = "l", action = "edit", desc = "Open file/folder" },
		{ key = "h", action = "close_node", desc = "Close folder" },
		{ key = "v", action = "vsplit", desc = "Open in vertical split" },
		{ key = "s", action = "split", desc = "Open in horizontal split" },
		{ key = "t", action = "tabnew", desc = "Open in new tab" },
		{ key = "<CR>", action = "edit", desc = "Open file/folder (default)" },
		{
			key = "o",
			action = "system_open",
			desc = "Open with system application",
		},
		{ key = "+", action = "create", desc = "Create new file/folder" },
		{ key = "d", action = "remove", desc = "Delete file/folder" },
		{ key = "r", action = "rename", desc = "Rename file/folder" },
		{ key = "y", action = "copy.node", desc = "Copy file/folder" },
		{ key = "x", action = "cut.node", desc = "Cut file/folder" },
		{ key = "p", action = "paste.node", desc = "Paste file/folder" },
		{ key = "c", action = "copy.filename", desc = "Copy filename" },
		{
			key = "C",
			action = "copy.relative_path",
			desc = "Copy relative path",
		},
		{
			key = "I",
			action = "toggle_gitignore",
			desc = "Toggle git ignored files",
		},
		{ key = "H", action = "toggle_hidden", desc = "Toggle hidden files" },
		{ key = "R", action = "refresh", desc = "Refresh tree" },
		{ key = "a", action = "create", desc = "Create new file/folder" },
		{ key = "<BS>", action = "navigate_up", desc = "Navigate up" },
		{ key = "<Tab>", action = "preview", desc = "Preview file" },
		{ key = "g?", action = "toggle_help", desc = "Show help" },
		{ key = "q", action = "close", desc = "Close tree" },
	}
end

-- Buffer-local mappings applied inside the tree window.
function M.on_attach(bufnr)
	local api = require("nvim-tree.api")

	api.config.mappings.default_on_attach(bufnr)

	for _, mapping in ipairs(configure_bindings()) do
		local action_func = api[mapping.action]

		if action_func then
			vim.keymap.set("n", mapping.key, action_func, {
				noremap = true,
				silent = true,
				nowait = true,
				buffer = bufnr,
				desc = mapping.desc,
			})
		end
	end
end

-- Global mapping to toggle the tree.
function M.global()
	vim.api.nvim_set_keymap("c", "<C-e>", ":NvimTreeToggle<CR>", {
		noremap = true,
		silent = true,
	})
end

return M
