local PACKAGE_NAME = "conform"

local function setup_formatters()
	return {
		bash = { "beautysh" },
		lua = { "stylua" },
		python = { "black", "isort" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		json = { "clang-format" },
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		markdown = { "prettier" },
		yaml = { "prettier" },
		rust = { "rustfmt" },
		go = { "gofmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		java = { "google-java-format" },
	}
end

local Options = {
	formatters_by_ft = setup_formatters(),

	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},

	formatters = {
		["clang-format"] = {
			"--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Always}",
		},
		prettier = {
			"--tab-width",
			"4",
			"--print-width",
			"100",
			"--use-tabs",
			"true",
		},
	},
}

local function setBinds()
	vim.keymap.set({ "n", "v" }, "<leader>cf", function()
		require(PACKAGE_NAME).format({
			async = true,
			lsp_fallback = true,
			timeout_ms = 1000,
		})
	end, { desc = "Format buffer/selection" })
end

return function()
	local status_ok, conform = pcall(require, PACKAGE_NAME)
	if not status_ok then
		return
	end

	conform.setup(Options)
	setBinds()
end
