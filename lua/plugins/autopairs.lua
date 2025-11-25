local PACKAGE_NAME = "nvim-autopairs"

return function()
	local npairs = require(PACKAGE_NAME)
	
	npairs.setup {
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
end
