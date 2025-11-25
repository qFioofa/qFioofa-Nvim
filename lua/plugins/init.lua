local FOLDER = "plugins."

return function()
	-- Main package manager
	local fPacker = require(FOLDER .. "packer")
	fPacker()

	-- Plugins conflig loading
	local fAutoPairs = require(FOLDER .. "autopairs")
	fAutoPairs()
	local fNvimTree = require(FOLDER .. "nvim-tree")
	fNvimTree()
end
