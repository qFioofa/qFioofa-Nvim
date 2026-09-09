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
keymap("n", "<C-w>", ":w!<CR>", d("Write file (force)"))
keymap({ "n", "i" }, "<C-s>", "<Esc>:w<CR>", d("Write file"))
keymap("n", "<leader>x", ":bd<CR>", d("Buffer: close"))
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

keymap("n", "<S-l>", ":bnext<CR>", d("Buffer: next"))
keymap("n", "<S-h>", ":bprevious<CR>", d("Buffer: previous"))

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
