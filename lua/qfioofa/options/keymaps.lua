local opts = {
	noremap = true,
	silent = true,
}

local term_opts = {
	silent = true,
}

local keymap = vim.keymap.set

-- Merge a description into the shared option tables so which-key (and `:map`)
-- can show a readable label for each mapping.
local function d(description)
	return vim.tbl_extend("force", opts, { desc = description })
end

local function td(description)
	return vim.tbl_extend("force", term_opts, { desc = description })
end

-- Open the URL (or file path) under the cursor with the OS handler.
-- `vim.ui.open` is cross-platform: explorer on Windows, open on macOS,
-- xdg-open/wslview on Linux.
local function open_under_cursor()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1

	-- Prefer a URL on the current line that spans the cursor.
	local url_pattern = "%a[%w+.-]*://[%w-_%.%?%.:/%+=&#@!~,;'%%]+"
	local from = 1
	while true do
		local s, e = line:find(url_pattern, from)
		if not s then
			break
		end
		if col >= s and col <= e + 1 then
			vim.ui.open(line:sub(s, e))
			return
		end
		from = e + 1
	end

	-- Fall back to whatever is under the cursor (file path, www.… link).
	local cfile = vim.fn.expand("<cfile>")
	if cfile ~= "" then
		vim.ui.open(cfile)
	else
		vim.notify("No URL or file under cursor", vim.log.levels.WARN)
	end
end

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Command --
keymap("n", "<C-q>", ":qa!<CR>", d("Quit all (force)"))
keymap(
	"n",
	"<C-w>",
	":w!<CR>",
	vim.tbl_extend("force", d("Write file (force)"), { nowait = true })
)
keymap({ "n", "i" }, "<C-s>", "<Esc>:w<CR>", d("Write file"))
keymap("n", "<leader>x", ":bd<CR>", d("Buffer: close"))
keymap("n", "q", ":bd<CR>", d("Buffer: close"))
keymap({ "n", "v" }, "<C-;>", ":", d("Enter command mode"))
keymap("n", "Y", "y$", d("Yank to end of line"))
keymap("n", "gx", open_under_cursor, d("Open link/file under cursor"))

-- Windows / splits
keymap("n", "<leader>w-", ":split<CR>", d("Split: horizontal"))
keymap("n", "<leader>w|", ":vsplit<CR>", d("Split: vertical"))

-- Normal --
keymap("n", "<C-h>", "<C-w>h", d("Window: focus left"))
keymap("n", "<C-j>", "<C-w>j", d("Window: focus down"))
keymap("n", "<C-k>", "<C-w>k", d("Window: focus up"))
keymap("n", "<C-l>", "<C-w>l", d("Window: focus right"))
keymap("n", "<leader>dd", "<cmd>:%d<CR>", d("Delete entire buffer"))
keymap("n", "<leader>yy", "<cmd>:%y<CR>", d("Yank entire buffer"))

keymap("n", "<C-Up>", ":resize -2<CR>", d("Resize: decrease height"))
keymap("n", "<C-Down>", ":resize +2<CR>", d("Resize: increase height"))
keymap("n", "<C-Left>", ":vertical resize +2<CR>", d("Resize: increase width"))
keymap("n", "<C-Right>", ":vertical resize -2<CR>", d("Resize: decrease width"))

local function visible_buffer_order()
	local ok, order = pcall(function()
		local manager = require("neo-tree.sources.manager")
		local renderer = require("neo-tree.ui.renderer")
		local state = manager.get_state("buffers")
		if
			not state
			or not state.tree
			or not renderer.tree_is_visible(state)
		then
			return nil
		end

		local bufs = {}
		for _, node in ipairs(renderer.get_all_visible_nodes(state.tree)) do
			if node.type == "file" or node.type == "terminal" then
				local bufnr = node.extra and node.extra.bufnr
				if
					bufnr
					and vim.api.nvim_buf_is_valid(bufnr)
					and vim.fn.buflisted(bufnr) == 1
				then
					bufs[#bufs + 1] = bufnr
				end
			end
		end
		return #bufs > 0 and bufs or nil
	end)
	if ok and order then
		return order
	end

	local bufs = {}
	for _, info in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if info.buftype == "" and info.name ~= "" then
			local ft = vim.bo[info.bufnr].filetype
			if ft ~= "neo-tree" and ft ~= "neo-tree-popup" then
				bufs[#bufs + 1] = info.bufnr
			end
		end
	end
	table.sort(bufs, function(a, b)
		return vim.api.nvim_buf_get_name(a) < vim.api.nvim_buf_get_name(b)
	end)
	return bufs
end

local function switch_buffer(delta)
	local bufs = visible_buffer_order()
	if #bufs == 0 then
		return
	end

	local current = vim.api.nvim_get_current_buf()
	local index
	for i, bufnr in ipairs(bufs) do
		if bufnr == current then
			index = i
			break
		end
	end
	if index then
		index = (index - 1 + delta) % #bufs + 1
	else
		index = delta > 0 and 1 or #bufs
	end

	local target = bufs[index]
	local wins = vim.fn.win_findbuf(target)
	if #wins > 0 then
		vim.api.nvim_set_current_win(wins[1])
		return
	end

	local win = vim.api.nvim_get_current_win()
	if vim.bo.filetype == "neo-tree" or vim.bo.filetype == "neo-tree-popup" then
		for _, candidate in ipairs(vim.api.nvim_list_wins()) do
			local ft = vim.bo[vim.api.nvim_win_get_buf(candidate)].filetype
			if
				ft ~= "neo-tree"
				and ft ~= "neo-tree-popup"
				and vim.api.nvim_win_get_config(candidate).relative == ""
			then
				win = candidate
				break
			end
		end
	end
	vim.api.nvim_win_set_buf(win, target)
	vim.api.nvim_set_current_win(win)
end

keymap("n", "<S-l>", function()
	switch_buffer(1)
end, d("Buffer: next"))
keymap("n", "<S-h>", function()
	switch_buffer(-1)
end, d("Buffer: previous"))

-- New file: in a Java project goes through :JNew (package/imports/type), in
-- any other context it just opens a scratch buffer with the given name.
keymap("n", "<leader>fn", function()
	local java = require("qfioofa.java.newfile")
	if vim.bo.filetype == "java" or java.find_source_root() then
		vim.cmd("JNew")
	else
		local fname = vim.fn.input("New file: ", "")
		if fname ~= "" then
			vim.cmd("edit " .. vim.fn.fnameescape(fname))
			vim.cmd("startinsert")
		end
	end
end, d("New file"))

-- Clear search highlight without leaving a "no match" message behind.
keymap("n", "<leader>uh", "<cmd>noh<CR>", d("Clear search highlight"))

-- Visual --
keymap("v", "<", "<gv", d("Indent left (keep selection)"))
keymap("v", ">", ">gv", d("Indent right (keep selection)"))

keymap("v", "<A-j>", ":m .+1<CR>==", d("Move line down"))
keymap("v", "<A-k>", ":m .-2<CR>==", d("Move line up"))
keymap("v", "p", '"_dP', d("Paste without overwriting register"))

-- Visual Block --
keymap("x", "J", ":move '>+1<CR>gv-gv", d("Move selection down"))
keymap("x", "K", ":move '<-2<CR>gv-gv", d("Move selection up"))
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", d("Move selection down"))
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", d("Move selection up"))

-- Terminal --
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", td("Terminal: focus left window"))
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", td("Terminal: focus down window"))
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", td("Terminal: focus up window"))
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", td("Terminal: focus right window"))
keymap("t", "<Esc>", "<C-\\><C-n>", td("Terminal: exit to normal mode"))

-- <leader>tt now opens a floating terminal via toggleterm.nvim
-- (see lua/qfioofa/plugins/toggleterm).

-- <C-w> is rebound to save above. Neovim's built-in <C-w>d / <C-w><C-D> maps
-- (diagnostics float) share that prefix, so pressing <C-w> would make nvim wait
-- `timeoutlen` for a possible second key. Neutralizing them here lets the
-- <C-w> (save) mapping fire immediately.
keymap("n", "<C-w>d", "<Nop>", opts)
keymap("n", "<C-w><C-d>", "<Nop>", opts)

-- Disable highlight from search
-- original from https://github.com/phtea/dotfiles/tree/main/nvim/.config/nvim
keymap(
	"n",
	"<Esc>",
	"<CMD>nohlsearch<CR>",
	{ silent = true, desc = "Hide highlight" }
)
