local utils = require("qfioofa.utils")
local saveInit = utils.saveInit

local order = {
	"options",
	"pluginManager",
}

local function main()
	local enter = ".init"

	for _, pack in ipairs(order) do
		saveInit(pack .. enter)
	end
end

return main
