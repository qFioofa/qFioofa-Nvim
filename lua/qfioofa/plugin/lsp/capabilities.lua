local capabilities = nil

local function setup_capabilities()
	local base_capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = vim.tbl_deep_extend("force", base_capabilities, require("cmp_nvim_lsp").default_capabilities())
end

local function get_capabilities()
	return capabilities
end

return function()
	setup_capabilities()

	return {
		get_capabilities = get_capabilities,
	}
end
