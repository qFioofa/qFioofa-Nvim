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
	"java",
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
	"elixir",
	"erlang",
	"heex",
	"eex",
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
