return {
	-- Run automatically when a buffer is loaded.
	auto_cmd = true,
	-- Don't print the detected indentation on every file open.
	override_editorconfig = false,
	-- Filetypes/buftypes where detection should be skipped.
	filetype_exclude = {
		"netrw",
		"tutor",
		"NvimTree",
	},
	buftype_exclude = {
		"help",
		"nofile",
		"terminal",
		"prompt",
	},
}
