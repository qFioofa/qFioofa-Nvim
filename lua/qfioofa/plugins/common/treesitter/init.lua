local function main_branch()
	return vim.fn.has("nvim-0.12") == 1
end

local function config_master()
	require("qfioofa.plugins.common.treesitter.plantuml").register_master()
	require("nvim-treesitter.configs").setup(
		require("qfioofa.plugins.common.treesitter.options")
	)
	if main_branch() then
		require("qfioofa.plugins.common.treesitter.patch")()
	end
end

local function config_main()
	require("qfioofa.plugins.common.treesitter.main")()
end

local function has_main_api()
	local ok, ts = pcall(require, "nvim-treesitter")
	return ok and type(ts.install) == "function"
end

return {
	"nvim-treesitter/nvim-treesitter",
	branch = main_branch() and "main" or "master",
	build = ":TSUpdate",
	config = function()
		if has_main_api() then
			config_main()
		else
			config_master()
		end
	end,
}
