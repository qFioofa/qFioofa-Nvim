local utils = require("qfioofa.utils")
local root = utils.roots.options
local saveInit = utils.saveInit

local function main()
	saveInit(root .. "options", "")
	saveInit(root .. "keymaps", "")
	saveInit(root .. "autocommand", "")
end

return main

