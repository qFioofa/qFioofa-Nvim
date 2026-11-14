local endwise_vars = {
	"endwise_addition",
	"endwise_words",
	"endwise_pattern",
	"endwise_end_pattern",
	"endwise_syngroups",
}

local function clear(bufnr)
	for _, name in ipairs(endwise_vars) do
		pcall(vim.api.nvim_buf_del_var, bufnr, name)
	end
end

local function config()
	local utils = require("qfioofa.utils")
	local group = vim.api.nvim_create_augroup("qfioofa_endwise", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "InsertEnter" }, {
		group = group,
		pattern = "*",
		callback = function(args)
			if not utils.is_editable(args.buf) or vim.wo.diff then
				clear(args.buf)
			end
		end,
	})

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if
			vim.api.nvim_buf_is_loaded(bufnr)
			and not utils.is_editable(bufnr)
		then
			clear(bufnr)
		end
	end
end

return {
	"tpope/vim-endwise",
	config = config,
}
