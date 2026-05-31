local opts = {
	noremap = true,
	silent = true,
}

local term_opts = {
	silent = true,
}

-- Shorten function name
local keymap = vim.keymap.set

-- Merge a description into the shared option tables so which-key (and `:map`)
-- can show a readable label for each mapping.
local function d(description)
	return vim.tbl_extend("force", opts, { desc = description })
end

local function td(description)
	return vim.tbl_extend("force", term_opts, { desc = description })
end

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Command --
keymap("n", "<leader><C-q>", ":qa!<CR>", d("Quit all (force)"))
keymap("n", "<leader><C-w>", ":w!<CR>", d("Write file (force)"))
keymap({ "n", "v" }, "<C-;>", ":", d("Enter command mode"))
keymap("n", "Y", "y$", d("Yank to end of line"))

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", d("Window: focus left"))
keymap("n", "<C-j>", "<C-w>j", d("Window: focus down"))
keymap("n", "<C-k>", "<C-w>k", d("Window: focus up"))
keymap("n", "<C-l>", "<C-w>l", d("Window: focus right"))
keymap("n", "<leader>dd", "<cmd>:%d<CR>", d("Delete entire buffer"))
keymap("n", "<leader>yy", "<cmd>:%y<CR>", d("Yank entire buffer"))

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", d("Resize: decrease height"))
keymap("n", "<C-Down>", ":resize +2<CR>", d("Resize: increase height"))
keymap("n", "<C-Left>", ":vertical resize +2<CR>", d("Resize: increase width"))
keymap("n", "<C-Right>", ":vertical resize -2<CR>", d("Resize: decrease width"))

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", d("Buffer: next"))
keymap("n", "<S-h>", ":bprevious<CR>", d("Buffer: previous"))

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", d("Indent left (keep selection)"))
keymap("v", ">", ">gv", d("Indent right (keep selection)"))

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", d("Move line down"))
keymap("v", "<A-k>", ":m .-2<CR>==", d("Move line up"))
keymap("v", "p", '"_dP', d("Paste without overwriting register"))

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", d("Move selection down"))
keymap("x", "K", ":move '<-2<CR>gv-gv", d("Move selection up"))
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", d("Move selection down"))
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", d("Move selection up"))

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", td("Terminal: focus left window"))
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", td("Terminal: focus down window"))
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", td("Terminal: focus up window"))
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", td("Terminal: focus right window"))
keymap("t", "<Esc>", "<C-\\><C-n>", td("Terminal: exit to normal mode"))

-- Open terminal window on the right side from normal mode
keymap(
	"n",
	"<leader>tt",
	":vsplit | wincmd l | terminal<CR>:vertical resize 100<CR>:startinsert<CR>",
	d("Open terminal (vertical split)")
)
