local parsers = require("qfioofa.plugins.common.treesitter.parsers")
local plantuml = require("qfioofa.plugins.common.treesitter.plantuml")

local INDENT_DISABLED = {
	javascript = true,
	typescript = true,
	tsx = true,
	jsx = true,
}

local function supported_parsers()
	local registry = require("nvim-treesitter.parsers")
	local list = {}
	for _, lang in ipairs(parsers) do
		if lang == "plantuml" or registry[lang] then
			list[#list + 1] = lang
		end
	end
	return list
end

local function attach(args)
	local bufnr = args.buf
	local ft = vim.bo[bufnr].filetype
	local lang = vim.treesitter.language.get_lang(ft)

	if not lang or not pcall(vim.treesitter.language.add, lang) then
		return
	end

	pcall(vim.treesitter.start, bufnr, lang)
	vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.wo.foldmethod = "expr"

	if
		not INDENT_DISABLED[ft] and vim.treesitter.query.get(lang, "indents")
	then
		vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

return function()
	local ts = require("nvim-treesitter")

	ts.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })

	vim.api.nvim_create_autocmd("User", {
		pattern = "TSUpdate",
		callback = plantuml.register_main,
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup(
			"qfioofa-treesitter",
			{ clear = true }
		),
		callback = attach,
	})

	ts.install(supported_parsers())
end
