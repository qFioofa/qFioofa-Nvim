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

return function()
	local status_ok, bufferline = pcall(require, PACKAGE_NAME)
	if not status_ok then
		return
	end

	bufferline.setup(Options)

	-- vim.api.nvim_create_autocmd("BufEnter", {
	-- 	callback = function()
	-- 		local max_buffers = 5
	-- 		local all_buffers = vim.api.nvim_list_bufs()
	-- 		local loaded_buffers = {}
	-- 		
	-- 		for _, buf in ipairs(all_buffers) do
	-- 			if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
	-- 				table.insert(loaded_buffers, buf)
	-- 			end
	-- 		end
	-- 		
	-- 		if #loaded_buffers > max_buffers then
	-- 			local buffers_with_time = {}
	-- 			for _, buf in ipairs(loaded_buffers) do
	-- 				local info = vim.fn.getbufinfo(buf)[1]
	-- 				table.insert(buffers_with_time, {
	-- 					buf = buf,
	-- 					lastused = info.lastused,
	-- 					modified = vim.bo[buf].modified
	-- 				})
	-- 			end
	-- 			
	-- 			table.sort(buffers_with_time, function(a, b)
	-- 				if a.modified ~= b.modified then
	-- 					return not a.modified
	-- 				end
	-- 				return a.lastused < b.lastused
	-- 			end)
	-- 			
	-- 			local current_buf = vim.api.nvim_get_current_buf()
	-- 			local closed_count = 0
	-- 			
	-- 			for i = 1, #buffers_with_time do
	-- 				if closed_count >= (#loaded_buffers - max_buffers) then
	-- 					break
	-- 				end
	-- 				
	-- 				local buf_info = buffers_with_time[i]
	-- 				if buf_info.buf ~= current_buf and not buf_info.modified then
	-- 					vim.api.nvim_buf_delete(buf_info.buf, { force = true })
	-- 					closed_count = closed_count + 1
	-- 				end
	-- 			end
	-- 		end
	-- 	end,
	-- })
end
