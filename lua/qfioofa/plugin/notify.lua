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
}

return function()
	local status_ok, notify = pcall(require, PACKAGE_NAME)
	if not status_ok then
		return
	end

	notify.setup(Options)
	vim.notify = notify
end
