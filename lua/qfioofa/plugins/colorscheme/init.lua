-- Active colorscheme. Alternatives kept below for quick switching.
-- List of colorthemes:
--    yugen-ash
--    gruvbox
--    yugen
--    koda
--    vscode
return {
	{
		"qfioofa/yugen-ash.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			variant = "muted",
		},
		config = function()
			-- require("yugen-ash").setup({
			-- 	variant = "muted",
			-- })
			vim.cmd("colorscheme yugen-ash")
		end,
	},
	{
		"oskarnurm/koda.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			theme = {
				dark = "dark",
				light = "glade",
			},
		},
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"bettervim/yugen",
		priority = 1000,
	},
	{
		"rose-pine/neovim",
		lazy = false,
		name = "rose-pine",
		priority = 1000,
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
	},
}
