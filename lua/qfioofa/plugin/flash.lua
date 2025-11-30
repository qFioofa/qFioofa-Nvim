local PACKAGE_NAME = "flash"

local Options = {
	labels = "abcdefghijklmnopqrstuvwxyz",
	search = {
		forward = true,
		multi_window = true,
		wrap = true,
		incremental = false,
		regex = false
	},
	action = nil,
	modes = {
		char = {
			enabled = true,
			jump_labels = false,
			autohide = false,
			highlight = {groups = {"FlashMatch"}},
		},
		search = {
			enabled = true,
			highlight = {groups = {"FlashMatch", "FlashCurrent"}},
		},
		treesitter = {
			labels = "abcdefghijklmnopqrstuvwxyz",
			jump_labels = false,
			autojump = false,
			highlight = {groups = {"FlashTS", "FlashTSCurrent"}},
		},
	},
	highlight = {
		backdrop = false,
		matches = true,
	},
}

function setBinds()
	local keymap = vim.keymap

	keymap.set({'n','x','o'}, 's', function()
		require(PACKAGE_NAME).jump()
	end)
end

return function()
	local flash = require(PACKAGE_NAME)
	flash.setup(Options)
	setBinds()
end
