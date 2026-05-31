return function()
	local keymaps = {
		{
			"n",
			"K",
			function()
				require("hover").open()
			end,
			{ desc = "hover.nvim (open)" },
		},
		{
			"n",
			"gK",
			function()
				require("hover").enter()
			end,
			{ desc = "hover.nvim (enter)" },
		},
		{
			"n",
			"<C-p>",
			function()
				require("hover").switch("previous")
			end,
			{ desc = "hover.nvim (previous source)" },
		},
		{
			"n",
			"<C-n>",
			function()
				require("hover").switch("next")
			end,
			{ desc = "hover.nvim (next source)" },
		},
	}

	for _, keymap in ipairs(keymaps) do
		vim.keymap.set(keymap[1], keymap[2], keymap[3], keymap[4])
	end
end
