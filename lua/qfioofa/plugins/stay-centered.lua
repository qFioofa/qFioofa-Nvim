local PACKAGE_NAME = "stay-centered"

local Options = {
	allow_scroll_move = true,
	disable_on_mouse = true,
}

return function()
	local stay_centered = require(PACKAGE_NAME)

	stay_centered.setup(Options)
end
