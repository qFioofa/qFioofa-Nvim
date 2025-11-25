local fPlugins = require("plugins.init")
local fOptions = require("options.init")
local fTheme = require("themes.init")

function init_all()
    fPlugins()
    fOptions()
    fTheme()
end

init_all()