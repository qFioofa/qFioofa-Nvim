local initList = {
	require("options.init"),
	require("plugins.init"),
	require("themes.init")
}

function init_all()
	for _, initFunction in ipairs(initList) do
		local success, result = pcall(
			initFunction
		)
	end
end

init_all()
