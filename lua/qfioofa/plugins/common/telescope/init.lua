local function config()
	local telescope = require("telescope")
	telescope.setup(require("qfioofa.plugins.common.telescope.options"))

	-- Load extensions after setup. Wrapped in pcall so a missing/unbuilt
	-- extension doesn't abort the whole telescope config.
	pcall(telescope.load_extension, "fzf")
	pcall(telescope.load_extension, "ui-select")
	pcall(telescope.load_extension, "media_files")
end

return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	keys = require("qfioofa.plugins.common.telescope.keymaps"),
	dependencies = {
		"nvim-telescope/telescope-media-files.nvim",
		-- Native C sorter: big fuzzy-matching speedup. `build` compiles it.
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		-- Routes vim.ui.select (LSP code-action/rename, etc.) through telescope.
		"nvim-telescope/telescope-ui-select.nvim",
	},
	config = config,
}
