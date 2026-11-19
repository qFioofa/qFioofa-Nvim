local permissions = require("qfioofa.plugins.v012.mcphub.permissions")

local config_dir = vim.fn.stdpath("config")

return {
	config = config_dir .. "/mcp/servers.json",
	use_bundled_binary = true,
	auto_approve = permissions.auto_approve,
	auto_toggle_mcp_servers = true,
	extensions = {
		avante = {
			enabled = true,
			make_slash_commands = true,
		},
	},
	builtin_tools = {
		edit_file = {
			parser = {
				track_issues = true,
				extract_inline_content = true,
			},
			locator = {
				fuzzy_threshold = 0.8,
				enable_fuzzy_matching = true,
			},
			feedback = {
				include_parser_feedback = true,
				include_locator_feedback = true,
				include_ui_summary = true,
			},
		},
	},
	workspace = {
		enabled = true,
		look_for = {
			".mcphub/servers.json",
			".vscode/mcp.json",
			".cursor/mcp.json",
		},
		reload_on_dir_changed = true,
	},
	log = {
		level = vim.log.levels.WARN,
	},
}
