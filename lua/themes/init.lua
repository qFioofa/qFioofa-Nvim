local FOLDER = "themes."

return function()
    require(FOLDER .. "setTheme")
	require(FOLDER .. "setCharacters")
	require(FOLDER .. "setNumbers")
end
