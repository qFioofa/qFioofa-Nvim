return {
	level = 2,
	max_height = function()
		return math.floor(vim.o.lines * 0.35)
	end,
	max_width = function()
		return math.floor(vim.o.columns * 0.35)
	end,
	render = "compact",
	stages = "fade", -- "fade_in_slide_out", "fade", "slide", "static"
	timeout = 1500,
	top_down = false,
	icons = {
		ERROR = "",
		WARN = "",
		INFO = "",
		DEBUG = "",
		TRACE = "",
	},
	background_colour = "#000000",
	minimum_width = 10,
}
