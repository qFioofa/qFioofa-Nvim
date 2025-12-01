local PACKAGE_NAME = "notify"

local Options = {
	fps = 30,
	level = 2,
	minimum_width = 50,
	render = "minimal",
	stages = "fade",
	time_formats = {
		notification = "%T",
		notification_history = "%FT%T"
	},
	timeout = 3000,
	top_down = true,
	background_colour = "Normal",
	icons = {
		ERROR = "",
		WARN = "",
		INFO = "",
		DEBUG = "",
		TRACE = "✎"
	},
	max_width = function()
		return math.floor(vim.o.columns * 0.75)
	end,
	max_height = function()
		return math.floor(vim.o.lines * 0.75)
	end,
	minimum_height = 1,
	border = "rounded",
	width = nil,
	height = nil,
	spacing = 1,
	padding = 1,
	hide_from_history = false,
	on_open = nil,
	on_close = nil,
	on_visual_close = nil,
	render_events = {},
	corner_radius = 0,
	hl_lookup = {
		ERROR = "ErrorMsg",
		WARN = "WarningMsg",
		INFO = "MoreMsg",
		DEBUG = "Debug",
		TRACE = "Comment",
	},
	max_notifications = 10,
	title = "Notification",
	title_pos = "center",
}

return function()
	local status_ok, notify = pcall(require, PACKAGE_NAME)
	if not status_ok then
		return
	end

	notify.setup(Options)
	vim.notify = notify
end

