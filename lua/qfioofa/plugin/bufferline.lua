local PACKAGE_NAME = "bufferline"

local Options = {
	options = {
		numbers = "none",
		close_command = "Bdelete! %d",
		right_mouse_command = "Bdelete! %d",
		left_mouse_command = "buffer %d",
		middle_mouse_command = nil,
		indicator_icon = "▎",
		buffer_close_icon = "",
		modified_icon = "●",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 30,
		max_prefix_length = 30,
		tab_size = 21,
		diagnostics = false,
		diagnostics_update_in_insert = false,
		offsets = { 
			{ 
				filetype = "NvimTree", 
				text = " File explorer",
				highlight = "FileExplorer",
				padding = 0 ,
			} 
		},
		show_buffer_icons = true,
		show_buffer_close_icons = true,
		show_close_icon = true,
		show_tab_indicators = true,
		persist_buffer_sort = true,
		separator_style = "thin",
		enforce_regular_tabs = true,
		always_show_bufferline = true,
	},
	highlights = {
		fill = {
			bg = "#1d1d1d",
			fg = "#ffffff",
			bold = false,
			italic = false, 
			reverse = false,
			standout = false,
			nocombine = false,
			default = false,
		},
		background = {
			bg = "#1d1d1d",
			fg = "#f1f1f1",
			bold = false,
			italic = false, 
			reverse = false,
			standout = false,
			nocombine = false,
			default = false,
		},
		close_button = {
			bg = "#1d1d1d",
			fg = "#f1f1f1"
		},
		close_button_visible = {
			bg = "#1d1d1d",
			fg = "#f1f1f1"
		},
		tab_selected = {
			bg = "#1d1d1d",
			fg = "#f1f1f1",
			italic = false, 
			reverse = false,
			standout = false,
			nocombine = false,
			default = false,
		},
		tab = {
			bg = "#d65d0e",
			fg = "#d79921"
		},
		tab_close = {
			bg = "NONE",
			fg = "#d65d0e"
		},
		duplicate_selected = {
			bg = "#1d1d1d",
			fg = "#f1f1f1"
		},
		duplicate_visible = {
			bg = "#1d1d1d",
			fg = "#f1f1f1"
		},
		duplicate = {
			bg = "#1d1d1d",
			fg = "#f1f1f1"
		},
		modified = {
			bg = "#1d1d1d",
			fg = '#d79921',
		},
		modified_selected = {
			bg = "#1d1d1d",
			fg = "#d79921"
		},
		modified_visible = {
			bg = "#1d1d1d",
			fg = "#d79921"
		},
		separator = {
			bg = "#1d1d1d",
			fg = "#1d1d1d"
		},
	},
}

local function setBinds()
	local keymap = vim.api.nvim_set_keymap
	local opts = {
		noremap = true, 
		silent = true 
	}

	keymap("n", "<leader>q", function()
		require("bufferline").close_all()
	end, { desc = "Close all buffers" })
end

return function()
	local status_ok, bufferline = pcall(require, PACKAGE_NAME)
	if not status_ok then
		return
	end

	bufferline.setup(Options)
end
