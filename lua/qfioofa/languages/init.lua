local LANGUAGES = {
	java = "qfioofa.languages.java",
}

local function main()
	local group =
		vim.api.nvim_create_augroup("qfioofa-languages", { clear = true })
	for ft, mod in pairs(LANGUAGES) do
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = ft,
			callback = function()
				require(mod).start()
			end,
		})
	end
end

return main
