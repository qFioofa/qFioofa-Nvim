local utils = require("qfioofa.utils")
local saveInit = utils.saveInit
local root = utils.roots.pluginManager

local function main()
	saveInit(root .. "initPlugins")
end

return main
