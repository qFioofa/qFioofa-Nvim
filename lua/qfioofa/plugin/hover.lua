local PACKAGE_NAME = "hover"

local function setup_providers()
	return {
		"hover.providers.diagnostic",
		"hover.providers.lsp",
		"hover.providers.dap",
		"hover.providers.man",
		"hover.providers.dictionary",
		-- "hover.providers.gh",
		-- "hover.providers.gh_user",
		-- "hover.providers.jira",
		-- "hover.providers.fold_preview",
		-- "hover.providers.highlight",
	}
end

local function setup_mouse_providers()
	return {
		"hover.providers.lsp",
	}
end

local function setup_preview_opts()
	return {
		border = "single",
	}
end

local function setup_keymaps()
	local keymaps = {
		{
			"n",
			"K",
			function()
				require("hover").open()
			end,
			{ desc = "hover.nvim (open)" },
		},
		{
			"n",
			"gK",
			function()
				require("hover").enter()
			end,
			{ desc = "hover.nvim (enter)" },
		},
		{
			"n",
			"<C-p>",
			function()
				require("hover").switch("previous")
			end,
			{ desc = "hover.nvim (previous source)" },
		},
		{
			"n",
			"<C-n>",
			function()
				require("hover").switch("next")
			end,
			{ desc = "hover.nvim (next source)" },
		},
		{
			"n",
			"<MouseMove>",
			function()
				require("hover").mouse()
			end,
			{ desc = "hover.nvim (mouse)" },
		},
	}

	for _, keymap in ipairs(keymaps) do
		vim.keymap.set(keymap[1], keymap[2], keymap[3], keymap[4])
	end
end

local Options = {
	providers = setup_providers(),
	preview_opts = setup_preview_opts(),
	-- Whether the contents of a currently open hover window should be moved
	-- to a :h preview-window when pressing the hover keymap.
	preview_window = true,
	title = true,
	mouse_providers = setup_mouse_providers(),
	mouse_delay = 1000,
}

return function()
	local status_ok, hover = pcall(require, PACKAGE_NAME)
	if not status_ok then
		return
	end

	hover.config(Options)
	setup_keymaps()

	vim.o.mousemoveevent = true
end
