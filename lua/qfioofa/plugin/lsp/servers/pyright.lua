local settings = {
	python = {
		analysis = {
			typeCheckingMode = "basic",
			autoSearchPaths = true,
			useLibraryCodeForTypes = true,
			diagnosticMode = "workspace",
		},
	},
}

return function()
	return {
		settings = settings,
	}
end
