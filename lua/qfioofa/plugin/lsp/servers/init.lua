-- local servers = {}
--
-- local function load_server_configs()
-- 	servers = {
-- 		lua_ls = require("lsp.servers.lua_ls"),
-- 		pyright = require("lsp.servers.pyright"),
-- 	}
-- end
--
-- local function get_servers_list()
-- 	return vim.tbl_keys(servers)
-- end
--
-- return function()
-- 	load_server_configs()
--
-- 	return servers
-- end
--
--
return {
	-- lua_ls = {
	-- 	settings = {
	-- 		Lua = {
	-- 			completion = {
	-- 				callSnippet = "Replace",
	-- 			},
	-- 			diagnostics = {
	-- 				globals = { "vim" },
	-- 			},
	-- 			workspace = {
	-- 				library = {
	-- 					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
	-- 					[vim.fn.stdpath("config") .. "/lua"] = true,
	-- 				},
	-- 				checkThirdParty = false,
	-- 			},
	-- 			telemetry = {
	-- 				enable = false,
	-- 			},
	-- 		},
	-- 	},
	-- },
	pyright = {
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "basic",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
				},
			},
		},
	},
}
