local FOLDER = "plugins."

local plugins = {
	"autopairs",
	"nvim-tree",
	"stay-centered",
	"nvim-colorizer",
	"oil",
	"Comment",
	"flash",
	"render-markdown",
	"tabout",
	"bufferline",
	"dashboard",
}

function loadPluginManager()
	local fPacker = require(FOLDER .. "packer")
	fPacker()
end

function loadPlugins()
	for _, pluginName in ipairs(plugins) do
		local success, packageFunction = pcall(
			require, FOLDER .. pluginName
		)
		
		if not success or type(packageFunction) ~= 'function' then
			vim.notify('Plugin with relative name: ' .. pluginName .. ' is not loaded', vim.log.levels.WARN)        
		else
			packageFunction()
		end
	end
end

return function()
	-- Main package manager
	local loaded, _ = pcall(loadPluginManager)

	if not loaded then
		vim.notify("Plugin manager is not loaded.")
	end
	
	-- Loading plunigs
	loadPlugins()
    vim.cmd('PackerLoad')
end
