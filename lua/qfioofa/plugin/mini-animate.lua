local PACKAGE_NAME = "mini.animate"


local Options = nil
local mini_animate = nil


local function getOptions()
	return {
		cursor = {
		timing = mini_animate.gen_timing.quartic({ duration = 150, unit = "total" }),
			path = mini_animate.gen_path.angle({
			  predicate = function(destination)
				return math.abs(destination[1]) > 3 or math.abs(destination[2]) > 20
			  end,
			}),
		},
		scroll = {
			timing = mini_animate.gen_timing.linear({ duration = 150, unit = "total" }),
			subscroll = mini_animate.gen_subscroll.equal({ max_output_steps = 30 }),
		},
		resize = {
			timing = mini_animate.gen_timing.linear({ duration = 200, unit = "total" }),
		}
	}
end


return function()
	local status_ok, animate = pcall(require, PACKAGE_NAME)
	if not status_ok then
		return
	end
	
	mini_animate = animate
	Options = getOptions()
	animate.setup(Options)
end
