local BARBECUE_NAME = "barbecue"

local Options = {
	attach_navic = true,
	include_following = true,
	show_dir = false,
	show_file = false,
	show_basename = false,
	context_follow_icon_color = true,
	symbols = {
		separator = " > ",
		ellipsis = "...",
		mod = "[+]",
		ro = "RO",
	},
	modified = function(bufnr)
		return vim.bo[bufnr].modified
	end,
	kinds = {
		File = "󰈙 ",
		Module = " ",
		Namespace = "󰌗 ",
		Package = "󰏗 ",
		Class = "󰌗 ",
		Method = "󰆧 ",
		Property = "󰜢 ",
		Field = "󰇽 ",
		Constructor = " ",
		Enum = "󰕘 ",
		Function = "󰆧 ",
		Variable = "󰀫 ",
		Constant = "󰏿 ",
		String = "󰾊 ",
		Number = "󰎠 ",
		Boolean = "󰨙 ",
		Array = "󰅪 ",
		Object = "󰅩 ",
		Key = "󰌋 ",
		Null = "󰟢 ",
		EnumMember = "󰕘 ",
		Struct = "󰌗 ",
		Event = "󱐋 ",
		Operator = "󰆕 ",
		TypeParameter = "󰊄 ",
	},
	theme = "auto",
	highlight = {},
	exclude_filetypes = { "help", "netrw", "NvimTree", "lazy", "mason", "toggleterm" },
}

return function()
	local barbecue = require(BARBECUE_NAME)

	barbecue.setup(Options)
	require("barbecue.ui").toggle(true)
end
