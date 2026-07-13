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
	"typst",
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
	-- ponytail: treesitter indent is experimental and wrong on JS/TS (chained
	-- calls, ternaries, object args). Neovim's built-in indent/javascript.vim
	-- handles these correctly, so let it win for the js family.
	indent = {
		enable = true,
		disable = { "javascript", "typescript", "tsx", "jsx" },
	},
	highlight = {
		enable = true,
		use_languagetree = true,
		additional_vim_regex_highlighting = false,
	},
	auto_install = compiler_available,
	folds = { enable = true },
	ensure_installed = compiler_available and parsers or {},
}
