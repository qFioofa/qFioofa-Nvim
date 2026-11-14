local utils = require("qfioofa.utils")

return {
	check_ts = true,
	ts_config = {
		lua = { "string", "source" },
		javascript = { "string", "template_string" },
		java = false,
	},
	disable_filetype = {
		"TelescopePrompt",
		"snacks_picker_input",
		"spectre_panel",
		"DiffviewFiles",
		"DiffviewFileHistory",
		"NvimTree",
		"lazygit",
		"gitcommit",
		"gitrebase",
		"help",
		"man",
		"qf",
		"toggleterm",
		"noice",
		"notify",
		"undotree",
		"oil",
		"neo-tree",
		"Outline",
		"alpha",
		"dashboard",
		"snacks_dashboard",
	},
	enabled = function(bufnr)
		return utils.is_editable(bufnr) and not vim.wo.diff
	end,
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
