local utils = require("qfioofa.utils")
local root = utils.roots.plugins .. "lsp.servers."

local servers = {
	["emmylua_ls"] = require(root .. "emmylua_ls"),
	["pylyzer"] = require(root .. "pylyzer"),
	["svelte"] = require(root .. "svelte"),
	["eslint"] = require(root .. "eslint"),
}

return servers
