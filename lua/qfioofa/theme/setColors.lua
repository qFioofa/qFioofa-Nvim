local hl = vim.api.nvim_set_hl

local function defineColors()
	hl(0, "FileExplorer", {
		fg = "#ffffff",
		bg = "#1d1d1d",
	})

	-- Noice
	hl(0, "NoiceMini", { bg = "#1d1d1d", fg = "#1d1d1d" })
	hl(0, "NoiceCmdlineIcon", { fg = "#d1d1d1" })
	hl(0, "NoiceCmdlineIconSearch", { fg = "#FFBE89" })
	hl(0, "NoiceCmdlinePopup", { bg = "#1d1d1d" })
	hl(0, "NoiceCmdlinePopupBorder", { fg = "#FFBE89" })

	-- Notify highlights
	hl(0, "NotifyBackground", { bg = "#1d1d1d" })
	hl(0, "NotifyBorder", { fg = "#FFBE89" })
	hl(0, "NotifyTitle", { fg = "#FFBE89", bold = true })

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
