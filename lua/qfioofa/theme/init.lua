local utils = require("qfioofa.utils")
local saveInit = utils.saveInit
local root = utils.roots.theme

local themeParts = {
	"mainTheme",
	"setColors",
}

function loadAll()
	for _, themePartName in ipairs(themeParts) do
		saveInit(root .. themePartName)
	end
end

return loadAll
