-- nvim-treesitter needs a C compiler to build parsers. If none is available
-- we skip parser installation so startup is not spammed with
-- "No C compiler found!" errors. Install any of cc/gcc/clang/cl/zig and the
-- parsers below will be installed automatically on the next start.
local function has_compiler()
	for _, exe in ipairs({ "cc", "gcc", "clang", "cl", "zig" }) do
		if vim.fn.executable(exe) == 1 then
			return true
		end
	end
	return false
end

local parsers = {
	"comment",
	"bash",
	"c",
	"diff",
	"dockerfile",
	"go",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"jsonc",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"printf",
	"python",
	"query",
	"regex",
	"sql",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
	"svelte",
}

local compiler_available = has_compiler()

return {
	indent = { enable = true },
	highlight = {
		enable = true,
		use_languagetree = true,
		additional_vim_regex_highlighting = false,
	},
	auto_install = compiler_available,
	folds = { enable = true },
	ensure_installed = compiler_available and parsers or {},
}
