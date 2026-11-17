local M = {}

-- Shared picker layout and keys. J/K scroll the file preview; explorer keeps
-- the picker open on jump by default, so close it explicitly on confirm.
local function picker_opts(opts)
	opts = opts or {}
	opts.layout = opts.layout or { preset = "telescope", preview = true }
	opts.auto_close = true
	opts.jump = vim.tbl_extend("force", { close = true }, opts.jump or {})

	local win = opts.win or {}
	win.input = win.input or {}
	win.input.keys = vim.tbl_extend("force", {
		J = { "preview_scroll_down", mode = { "i", "n" } },
		K = { "preview_scroll_up", mode = { "i", "n" } },
	}, win.input.keys or {})
	win.list = win.list or {}
	win.list.keys = vim.tbl_extend("force", {
		J = "preview_scroll_down",
		K = "preview_scroll_up",
	}, win.list.keys or {})
	win.preview = win.preview or {}
	win.preview.keys = vim.tbl_extend("force", {
		J = "preview_scroll_down",
		K = "preview_scroll_up",
	}, win.preview.keys or {})
	opts.win = win
	return opts
end

local function picker(source, title, extra)
	return function()
		local opts = picker_opts({ title = title })
		for key, value in pairs(extra or {}) do
			opts[key] = value
		end
		require("snacks").picker[source](opts)
	end
end

-- Snacks applies a built-in per-filetype kind filter for lsp symbols. Override
-- every entry so classes/functions/methods from all buffers survive.
local ALL_KINDS = {
	default = true,
	lua = true,
	markdown = true,
	help = true,
}

local TYPE_KINDS = {
	"Class",
	"Enum",
	"Interface",
	"Module",
	"Namespace",
	"Object",
	"Package",
	"Struct",
	"TypeParameter",
}

local TYPE_FILTER = {
	default = TYPE_KINDS,
	lua = TYPE_KINDS,
	markdown = TYPE_KINDS,
	help = TYPE_KINDS,
}

function M.find_files()
	require("snacks").picker.explorer(picker_opts({
		title = " Files ",
		focus = "input",
		follow_file = false,
		hidden = false,
		ignored = false,
		layout = { preset = "default", preview = true },
	}))
end

function M.find_config()
	require("snacks").picker.explorer(picker_opts({
		title = " Config ",
		focus = "input",
		follow_file = false,
		hidden = false,
		ignored = false,
		cwd = vim.fn.stdpath("config"),
	}))
end

function M.grep()
	require("snacks").picker.pick(
		"grep_grouped",
		picker_opts({
			title = " Grep ",
		})
	)
end

M.lsp_definitions = picker("lsp_definitions", " Definitions ")
M.lsp_references = picker("lsp_references", " References ")
M.lsp_implementations = picker("lsp_implementations", " Implementations ")
M.lsp_symbols = picker("lsp_symbols", " Symbols ", {
	filter = ALL_KINDS,
})
M.lsp_workspace_symbols =
	picker("lsp_workspace_symbols", " Workspace Symbols ", {
		filter = ALL_KINDS,
	})
M.lsp_types = picker("lsp_workspace_symbols", " Types ", {
	filter = TYPE_FILTER,
})

return M
