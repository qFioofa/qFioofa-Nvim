local hl = vim.api.nvim_set_hl

local function defineColors()
	hl(0, "FileExplorer", {
		fg = "#ffffff",
		bg = "#1d1d1d",
	})

	hl(0, "Cursor", {
		fg = "#ffffff",
		bg = "NONE",
	})

	-- LSP progress highlights
	hl(0, "NoiceLspProgressTitle", { fg = "#FFBE89", bold = true })
	hl(0, "NoiceLspProgressClient", { fg = "#82aaff" })

	-- Message highlights
	hl(0, "NoiceFormatTitle", { fg = "#FFBE89", bold = true })
	hl(0, "NoiceFormatDate", { fg = "#82aaff" })
	hl(0, "NoiceFormatEvent", { fg = "#c792ea" })
	hl(0, "NoiceFormatKind", { fg = "#ffcb6b" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = defineColors,
})
