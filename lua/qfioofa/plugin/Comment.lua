local PACKAGE_NAME = "Comment"

local Options = {
	toggler = {
		line = "gcc",
		block = "gbc",
	},
	opleader = {
		line = "gc",
		block = "gb",
	},
	extra = {
		above = "gcO",
		below = "gco",
		eol = "gcA",
	},
	mappings = {
		basic = true,
		extra = true,
		extended = false,
	},
	pre_hook = nil,
	post_hook = nil,
}

return function()
	local Comment = require(PACKAGE_NAME)
	Comment.setup(Options)
end
