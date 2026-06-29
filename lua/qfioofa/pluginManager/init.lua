local function main()
	local profile = require("qfioofa.pluginManager.profile")
	local backend = require("qfioofa.pluginManager.backends." .. profile)
	backend()
end

return main
