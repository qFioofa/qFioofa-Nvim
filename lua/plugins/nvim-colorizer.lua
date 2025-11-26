local PACKAGE_NAME = "colorizer"

local Options = {
	"*",
    user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = 'background',
        virtualtext = '■',
    },
}

return function()
	local colorizer = require(PACKAGE_NAME)
	colorizer.setup(Options)
end
