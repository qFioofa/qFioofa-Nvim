local M = {}

function M.start()
	vim.bo.commentstring = "' %s"
end

return M
