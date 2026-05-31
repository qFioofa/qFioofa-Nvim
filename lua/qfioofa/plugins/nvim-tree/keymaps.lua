local M = {}

-- Bindings map a key (or list of keys) to a dotted path resolved against
-- `nvim-tree.api`. Using real api references (instead of string lookups on the
-- api root) is what makes nested actions like `fs.copy.node` actually work.
local function bindings()
	return {
		-- Opening / navigation
		{
			key = { "<CR>", "w", "o" },
			path = "node.open.edit",
			desc = "Open",
		},
		{
			key = "h",
			path = "node.navigate.parent.close",
			desc = "Close folder",
		},
		{
			key = "<BS>",
			path = "node.navigate.parent.close",
			desc = "Close folder",
		},
		{
			key = "v",
			path = "node.open.vertical",
			desc = "Open: vertical split",
		},
		{
			key = "s",
			path = "node.open.horizontal",
			desc = "Open: horizontal split",
		},
		{ key = "t", path = "node.open.tab", desc = "Open: new tab" },
		{ key = "<Tab>", path = "node.open.preview", desc = "Preview file" },
		{
			key = "<C-]>",
			path = "tree.change_root_to_node",
			desc = "CD into folder",
		},
		{ key = "-", path = "tree.change_root_to_parent", desc = "CD up" },

		-- File system operations
		{ key = { "a", "+" }, path = "fs.create", desc = "Create file/folder" },
		{ key = "d", path = "fs.remove", desc = "Delete" },
		{ key = "r", path = "fs.rename", desc = "Rename" },
		{ key = "<C-r>", path = "fs.rename_full", desc = "Rename: full path" },
		{ key = "x", path = "fs.cut", desc = "Cut" },
		{ key = "y", path = "fs.copy.node", desc = "Copy" },
		{ key = "p", path = "fs.paste", desc = "Paste" },
		{ key = "c", path = "fs.copy.filename", desc = "Copy filename" },
		{
			key = "C",
			path = "fs.copy.relative_path",
			desc = "Copy relative path",
		},
		{
			key = "Y",
			path = "fs.copy.absolute_path",
			desc = "Copy absolute path",
		},

		-- Tree view / filtering
		{ key = "E", path = "tree.expand_all", desc = "Expand all" },
		{ key = "W", path = "tree.collapse_all", desc = "Collapse all" },
		{ key = "R", path = "tree.reload", desc = "Refresh tree" },
		{
			key = "H",
			path = "tree.toggle_hidden_filter",
			desc = "Toggle hidden files",
		},
		{
			key = "I",
			path = "tree.toggle_gitignore_filter",
			desc = "Toggle git ignored",
		},
		{ key = "f", path = "live_filter.start", desc = "Live filter" },
		{ key = "F", path = "live_filter.clear", desc = "Clear live filter" },
		{ key = "S", path = "tree.search_node", desc = "Search" },
		{ key = "K", path = "node.show_info_popup", desc = "File info" },
		{ key = "g?", path = "tree.toggle_help", desc = "Show help" },
		{ key = "q", path = "tree.close", desc = "Close tree" },

		-- Bookmarks / bulk operations
		{ key = "m", path = "marks.toggle_node", desc = "Toggle bookmark" },
		{ key = "bd", path = "marks.bulk.delete", desc = "Delete bookmarked" },
		{ key = "bm", path = "marks.bulk.move", desc = "Move bookmarked" },
	}
end

-- Walk a dotted path (e.g. "fs.copy.node") against a table, returning the leaf.
local function resolve(root, path)
	local node = root
	for part in string.gmatch(path, "[^.]+") do
		if type(node) ~= "table" then
			return nil
		end
		node = node[part]
	end
	return node
end

-- Buffer-local mappings applied inside the tree window.
function M.on_attach(bufnr)
	local api = require("nvim-tree.api")

	api.config.mappings.default_on_attach(bufnr)

	local function opts(desc)
		return {
			noremap = true,
			silent = true,
			nowait = true,
			buffer = bufnr,
			desc = "nvim-tree: " .. desc,
		}
	end

	for _, mapping in ipairs(bindings()) do
		local action = resolve(api, mapping.path)

		if type(action) == "function" then
			local keys = type(mapping.key) == "table" and mapping.key
				or { mapping.key }

			for _, key in ipairs(keys) do
				vim.keymap.set("n", key, action, opts(mapping.desc))
			end
		end
	end
end

-- Global mapping to toggle the tree (normal mode).
function M.global()
	vim.keymap.set("n", "<C-e>", "<cmd>NvimTreeToggle<CR>", {
		noremap = true,
		silent = true,
		desc = "Toggle file tree",
	})
end

return M
