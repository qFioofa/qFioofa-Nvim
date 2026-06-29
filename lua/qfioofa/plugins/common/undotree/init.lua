return {
	"mbbill/undotree",
	init = function()
		vim.g.undotree_SetFocusWhenToggle = 1
	end,
	keys = {
		{ "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "[U]ndo tree" },
	},
}
