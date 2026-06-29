return {
	{
		"<leader>un",
		function()
			require("notify").dismiss({
				silent = true,
				pending = true,
			})
		end,
		desc = "Dismiss All Notifications",
	},
}
