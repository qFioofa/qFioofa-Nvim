return {
	"rcarriga/nvim-notify",
	keys = require("qfioofa.plugins.notify.keymaps"),
	opts = require("qfioofa.plugins.notify.options"),
	init = function()
		-- Set as default notification handler
		vim.notify = require("notify")
	end,
}
