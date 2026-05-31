-- Active colorscheme. Alternatives kept below for quick switching.
return {
	{
		"qfioofa/yugen-ash.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- require("yugen-ash").setup({ variant = "muted" })
			vim.cmd("colorscheme yugen-ash")
		end,
	},

	-- {
	-- 	"jellisonleao/gruvbox.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd("colorscheme gruvbox")
	-- 	end,
	-- },
	-- {
	-- 	"bettervim/yugen",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd("colorscheme yugen")
	-- 	end,
	-- },
	-- {
	-- 	"rose-pine/neovim",
	-- 	name = "rose-pine",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("rose-pine").setup({ variant = "main" })
	-- 		vim.cmd("colorscheme rose-pine")
	-- 	end,
	-- },
}
