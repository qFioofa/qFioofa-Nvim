return function()
	vim.keymap.set({ "n", "v" }, "<leader>cf", function()
		require("conform").format({
			async = true,
			lsp_fallback = true,
			timeout_ms = 1000,
		})
	end, { desc = "Format buffer/selection" })
end
