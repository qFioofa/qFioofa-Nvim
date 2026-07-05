-- No LSP notifications via notify, for any server. Progress ($/progress) is
-- disabled globally in noice; window/showMessage + window/logMessage are
-- swallowed here. Errors still surface inline as diagnostics (virtual_lines).
local M = {}

function M.install_handlers()
	for _, method in ipairs({ "window/showMessage", "window/logMessage" }) do
		vim.lsp.handlers[method] = function() end
	end
end

return M
