local function config()
	require("diffview").setup(
		require("qfioofa.plugins.common.diffview.options")
	)
end

-- Test comment
return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewFileHistory",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewRefresh",
	},
	config = config,
	keys = require("qfioofa.plugins.common.diffview.keymaps"),
}
