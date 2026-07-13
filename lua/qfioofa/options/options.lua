-- ponytail: shim the deprecated vim.tbl_flatten (removed API, still called by
-- several plugins) to its non-deprecated equivalent so it stops emitting the
-- deprecation warning. Must run before plugins load. Drop when every plugin
-- migrates off it.
vim.tbl_flatten = function(t)
	return vim.iter(t):flatten(math.huge):totable()
end

local Options = {
	-- General
	backup = false,
	clipboard = "unnamedplus",
	undofile = true,

	-- Leftside numbers
	number = true,
	relativenumber = true,
	cursorline = true,
	cursorlineopt = "number",

	-- Tabline
	showtabline = 0,

	expandtab = false,
	shiftwidth = 4,
	tabstop = 4,
	autoindent = true,

	-- Line
	linebreak = true,
	wrap = true,
	whichwrap = "bs<>[]hl",

	-- Windows
	title = true,
	splitright = true,
	splitbelow = true,

	fillchars = {
		eob = " ",
	},
	list = true,
	listchars = {
		tab = "│ ",
		nbsp = "·",
		trail = "•",
	},
	signcolumn = "yes",
	termguicolors = true,

	-- Sounds
	errorbells = false,
	visualbell = false,

	-- Unicode
	emoji = true,
	encoding = "utf-8",
	guifont = "monospace:h17",

	-- Cmd
	cmdheight = 0,
	wildoptions = "tagfile",

	-- Other
	mouse = "a",
}

for OptionName, OptionValue in pairs(Options) do
	vim.opt[OptionName] = OptionValue
end

-- Set PowerShell as default shell on Windows
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
	local find_powershell = function()
		if vim.fn.executable("pwsh") == 1 then
			return "pwsh"
		end
		if vim.fn.executable("powershell") == 1 then
			return "powershell"
		end
		-- Fallback to absolute Windows path
		return os.getenv("SystemRoot")
			.. "\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
	end

	vim.o.shell = find_powershell()
	vim.o.shellcmdflag = "-NoLogo"
	vim.o.shellredir = "| Out-File -Encoding UTF8 %s"
	vim.o.shellquote = ""
	vim.o.shellxquote = ""
end
