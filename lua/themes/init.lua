local FOLDER = "themes."

local themeParts = {
	"setTheme",
	"setCharacters",
	"setNumbers",
	"setFlash"
}

function loadAll()
	for _, themePartName in ipairs(themeParts) do
		require(FOLDER .. themePartName)
	end
end

return function()
	loadAll()
end
