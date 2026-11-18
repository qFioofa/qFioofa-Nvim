local M = {}

local DEFAULT_DIR = "~/tree-sitter-plantuml"
local REMOTE = "https://github.com/qFioofa/tree-sitter-plantuml"

local function local_dir()
	local dir = vim.fn.expand(vim.env.PLANTUML_TS_DIR or DEFAULT_DIR)
	if vim.fn.isdirectory(dir) == 1 then
		return dir
	end
end

function M.register_master()
	local dir = local_dir()
	local install_info

	if dir then
		install_info = {
			url = dir,
			files = { "src/parser.c", "src/scanner.c" },
			revision = "local",
		}
		vim.opt.rtp:append(dir)
	else
		install_info = {
			url = REMOTE,
			files = { "src/parser.c", "src/scanner.c" },
			branch = "main",
		}
	end

	require("nvim-treesitter.parsers").get_parser_configs().plantuml = {
		install_info = install_info,
		filetype = "plantuml",
	}
end

function M.register_main()
	local dir = local_dir()
	local install_info

	if dir then
		install_info = { path = dir, queries = "queries" }
	else
		install_info = {
			url = REMOTE,
			branch = "main",
			queries = "queries",
		}
	end

	require("nvim-treesitter.parsers").plantuml = {
		install_info = install_info,
		tier = 3,
	}
end

return M
