local PACKAGE_NAME = "which-key"

local Options = {
	plugins = {
		presets = {
			operators = false,
			motions = false,
			text_objects = false,
			windows = true,
			nav = true,
		},
	},
	window = {
		border = "single",
		position = "bottom",
	},
	layout = {
		height = { min = 4, max = 25 },
		width = { min = 20, max = 50 },
	},
}

return function()
	local status_ok, which_key = pcall(require, PACKAGE_NAME)
	if not status_ok then
		return
	end

	which_key.setup(Options)
end
