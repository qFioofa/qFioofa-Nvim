local PACKAGE_NAME = "telescope"

local function setup_extensions()
	return {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	}
end

local function setup_defaults()
	return {
		file_ignore_patterns = {
			"node_modules",
			".git",
			"%.lock",
			"%.tmp",
			"%.cache",
		},
		path_display = { "truncate" },
	}
end

local function setup_picker_defaults()
	return {
		find_files = {
			hidden = true,
			previewer = false,
		},
		grep_string = {
			only_one_result = true,
		},
		live_grep = {
			additional_args = function(opts)
				return { "--hidden" }
			end,
		},
	}
end

local Options = {
	defaults = setup_defaults(),
	pickers = setup_picker_defaults(),
	extensions = setup_extensions(),
}

local function setBinds()
	-- Find files
	vim.keymap.set("n", "<leader>ff", function()
		require("telescope.builtin").find_files()
	end, { desc = "Find Files" })

	-- Find in files (grep)
	vim.keymap.set("n", "<leader>fg", function()
		require("telescope.builtin").live_grep()
	end, { desc = "Find in Files" })

	-- Find in current buffer
	vim.keymap.set("n", "<leader>fb", function()
		require("telescope.builtin").current_buffer_fuzzy_find()
	end, { desc = "Find in Buffer" })

	-- Recent files
	vim.keymap.set("n", "<leader>fr", function()
		require("telescope.builtin").oldfiles()
	end, { desc = "Recent Files" })

	-- Help tags
	vim.keymap.set("n", "<leader>fh", function()
		require("telescope.builtin").help_tags()
	end, { desc = "Help Tags" })

	-- Commands
	vim.keymap.set("n", "<leader>fc", function()
		require("telescope.builtin").commands()
	end, { desc = "Commands" })

	-- Keymaps
	vim.keymap.set("n", "<leader>fk", function()
		require("telescope.builtin").keymaps()
	end, { desc = "Keymaps" })

	-- Buffers
	vim.keymap.set("n", "<leader>fb", function()
		require("telescope.builtin").buffers()
	end, { desc = "Buffers" })

	-- Git files
	vim.keymap.set("n", "<leader>gf", function()
		require("telescope.builtin").git_files()
	end, { desc = "Git Files" })

	-- Git status
	vim.keymap.set("n", "<leader>gs", function()
		require("telescope.builtin").git_status()
	end, { desc = "Git Status" })
end

return function()
	local status_ok, telescope = pcall(require, PACKAGE_NAME)
	if not status_ok then
		return
	end

	telescope.setup(Options)
	setBinds()
end
