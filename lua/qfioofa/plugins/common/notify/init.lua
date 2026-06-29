return {
	"rcarriga/nvim-notify",
	keys = require("qfioofa.plugins.common.notify.keymaps"),
	opts = require("qfioofa.plugins.common.notify.options"),
	init = function()
		-- Set as default notification handler
		vim.notify = require("notify")
	end,
}
