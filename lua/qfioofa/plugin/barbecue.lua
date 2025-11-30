local BARBECUE_NAME = "barbecue"

local Options = {
	attach_navic = false,
	include_following = false,
	show_dir = false,
	show_file = false,
	show_basename = false,
	dirname_depth = 1,
	basename_depth = 1,
	custom_basename = nil,
	context_follow_icon_color = true,
	symbols = {
		separator = " > ",
		ellipsis = "...",
		mod = "[+]",
		ro = "RO",
	},
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
	theme = 'auto',
	highlight = {

	},
	exclude_filetypes = { "help", "netrw", "NvimTree", "lazy", "mason", "toggleterm" },
}

return function()
	local barbecue = require(BARBECUE_NAME)

	barbecue.setup(Options)

	local barbecueUI = require(BARBECUE_NAME .. ".ui")
	barbecueUI.toggle(true)
end
