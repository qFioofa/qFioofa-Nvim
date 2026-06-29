-- Detects each file's existing indentation (tabs vs spaces, width) on open and
-- sets expandtab/shiftwidth/tabstop to match. Pure Lua, so it works on every
-- platform. Your defaults in options.lua (shiftwidth/tabstop = 4) still apply
-- to brand-new files; guess-indent only overrides when a file has a clear style.
return {
	"NMAC427/guess-indent.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = require("qfioofa.plugins.common.guess-indent.options"),
}
