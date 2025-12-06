local PACKAGE_NAME = "lualine"

local function get_lsp_status()
	local clients = vim.lsp.get_clients()
	if #clients == 0 then
		return "LSP: Off"
	end

	local current_file = vim.api.nvim_buf_get_name(0)
	if current_file == "" then
		return "LSP: No File"
	end

	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	if filetype == "" then
		return "LSP: No FT"
	end

	local active_clients = {}
	for _, client in ipairs(clients) do
		if client.config and client.config.filetypes then
			for _, ft in ipairs(client.config.filetypes) do
				if ft == filetype then
					table.insert(active_clients, client.name)
					break
				end
			end
		end
	end

	if #active_clients == 0 then
		return "LSP: No Client"
	else
		return "LSP: " .. table.concat(active_clients, ", ")
	end
end

local Options = {
	options = {
		theme = {
			normal = {
				a = { bg = "#d65d0e", fg = "#ffffff" },
				b = { bg = "#2d2d2d", fg = "#ffffff" },
				c = { bg = "#2d2d2d", fg = "#ffffff" },
			},
			insert = {
				a = { bg = "#98971a", fg = "#ffffff" },
				b = { bg = "#2d2d2d", fg = "#ffffff" },
				c = { bg = "#2d2d2d", fg = "#ffffff" },
			},
			visual = {
				a = { bg = "#d79921", fg = "#ffffff" },
				b = { bg = "#2d2d2d", fg = "#ffffff" },
				c = { bg = "#2d2d2d", fg = "#ffffff" },
			},
			replace = {
				a = { bg = "#8ec07c", fg = "#ffffff" },
				b = { bg = "#2d2d2d", fg = "#ffffff" },
				c = { bg = "#2d2d2d", fg = "#ffffff" },
			},
			command = {
				a = { bg = "#d3869b", fg = "#ffffff" },
				b = { bg = "#2d2d2d", fg = "#ffffff" },
				c = { bg = "#2d2d2d", fg = "#ffffff" },
			},
			terminal = {
				a = { bg = "#1d1d1d", fg = "#ffffff" },
				b = { bg = "#2d2d2d", fg = "#ffffff" },
				c = { bg = "#2d2d2d", fg = "#ffffff" },
			},
		},
		component_separators = { left = " |", right = "| " },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff" },
		lualine_c = { "filename", get_lsp_status },
		lualine_x = { "diagnostics", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
}

return function()
	local status_ok, lualine = pcall(require, PACKAGE_NAME)
	if not status_ok then
		return
	end

	lualine.setup(Options)
end
