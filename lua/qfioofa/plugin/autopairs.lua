local PACKAGE_NAME = "nvim-autopairs"

local Options = {
	check_ts = true,
	ts_config = {
		lua = { "string", "source" },
		javascript = { "string", "template_string" },
		java = false,
	},
	disable_filetype = { "TelescopePrompt" },
	fast_wrap = {
		chars = { "{", "[", "(", '"', "'" },
		map = "<M-e>",
		pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
		offset = 0, -- Offset from pattern match
		end_key = "$",
		keys = "qwertyuiopzxcvbnmasdfghjkl",
		check_comma = true,
		highlight = "PmenuSel",
		highlight_grey = "LineNr",
	},
}

return function()
	local status_ok, npairs = pcall(require, PACKAGE_NAME)
	if not status_ok then
		return
	end

	npairs.setup(Options)
end
