local WIDTH = 40
local MIN_WIDTH = 25
local MAX_WIDTH = 45

local function buffers_window()
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)
		if
			vim.api.nvim_win_get_config(win).relative == ""
			and vim.bo[buf].filetype == "neo-tree"
			and vim.b[buf].neo_tree_source == "buffers"
		then
			return win
		end
	end
end

-- Keep the right-hand buffers panel at a stable width, like nvim-tree does
-- for its left sidebar. If it is opened full width (for example before the
-- initial layout settles) clamp it back to WIDTH.
local function enforce_width()
	local win = buffers_window()
	if not win then
		return
	end

	local width = vim.api.nvim_win_get_width(win)
	if
		vim.o.columns > WIDTH
		and (width < MIN_WIDTH or width > MAX_WIDTH)
	then
		vim.api.nvim_win_set_width(win, WIDTH)
	end

	vim.wo[win].winfixwidth = true
end

local function schedule_enforce()
	vim.schedule(enforce_width)
end

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

	schedule_enforce()
	vim.defer_fn(enforce_width, 100)
end

local function config()
	local ok, neo_tree = pcall(require, "neo-tree")
	if not ok then
		return
	end

	local options = require("qfioofa.plugins.common.neo-tree.options")
	options.event_handlers = {
		{
			event = "neo_tree_window_after_open",
			handler = schedule_enforce,
		},
	}

	neo_tree.setup(options)
	require("qfioofa.plugins.common.neo-tree.keymaps").global()

	local group = vim.api.nvim_create_augroup("qfioofa_neo_tree", { clear = true })

	vim.api.nvim_create_autocmd("VimEnter", {
		group = group,
		once = true,
		callback = open_on_start,
	})

	vim.api.nvim_create_autocmd({
		"VimResized",
		"WinResized",
		"WinEnter",
		"BufWinEnter",
	}, {
		group = group,
		callback = schedule_enforce,
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
