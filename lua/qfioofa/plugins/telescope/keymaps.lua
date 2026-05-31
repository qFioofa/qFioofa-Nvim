return function()
	local builtin = require("telescope.builtin")

	-- Find files
	vim.keymap.set("n", "<leader>ff", function()
		builtin.find_files()
	end, { desc = "Find Files" })

	-- Find in files (grep)
	vim.keymap.set("n", "<leader>fg", function()
		builtin.live_grep()
	end, { desc = "Find in Files" })

	-- Find in current buffer
	vim.keymap.set("n", "<leader>fb", function()
		builtin.current_buffer_fuzzy_find()
	end, { desc = "Find in Buffer" })

	-- Recent files
	vim.keymap.set("n", "<leader>fr", function()
		builtin.oldfiles()
	end, { desc = "Recent Files" })

	-- Help tags
	vim.keymap.set("n", "<leader>fh", function()
		builtin.help_tags()
	end, { desc = "Help Tags" })

	-- Commands
	vim.keymap.set("n", "<leader>fc", function()
		builtin.commands()
	end, { desc = "Commands" })

	-- Keymaps
	vim.keymap.set("n", "<leader>fk", function()
		builtin.keymaps()
	end, { desc = "Keymaps" })

	-- Buffers
	vim.keymap.set("n", "<leader>fb", function()
		builtin.buffers()
	end, { desc = "Buffers" })

	-- Git files
	vim.keymap.set("n", "<leader>gf", function()
		builtin.git_files()
	end, { desc = "Git Files" })

	-- Git status
	vim.keymap.set("n", "<leader>gs", function()
		builtin.git_status()
	end, { desc = "Git Status" })
end
