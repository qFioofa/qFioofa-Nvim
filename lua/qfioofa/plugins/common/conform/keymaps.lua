-- Returned as a lazy.nvim `keys` spec so conform loads on first format.
return {
	{
		"<leader>cf",
		function()
			require("conform").format({
				async = true,
				lsp_format = "fallback",
				timeout_ms = 1000,
			})
		end,
		mode = { "n", "v" },
		desc = "Format buffer/selection",
	},
}
