-- Returned as a lazy.nvim `keys` spec so toggleterm loads on first use.
-- All live under the <leader>t "Toggle / Terminal" which-key group.
return {
	{
		"<leader>tt",
		"<cmd>ToggleTerm direction=float<cr>",
		mode = "n",
		desc = "Terminal: floating",
	},
	{
		"<leader>th",
		"<cmd>ToggleTerm direction=horizontal<cr>",
		mode = "n",
		desc = "Terminal: horizontal split",
	},
	{
		"<leader>tv",
		"<cmd>ToggleTerm size=80 direction=vertical<cr>",
		mode = "n",
		desc = "Terminal: vertical split",
	},
}
