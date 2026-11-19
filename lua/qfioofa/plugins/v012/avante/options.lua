vim.env.OMNIROUTE_API_KEY = vim.env.OMNIROUTE_API_KEY or "not-needed"

local mode = require("qfioofa.plugins.v012.avante.mode")

local function read_file(path)
	local fd = io.open(path, "r")
	if not fd then
		return nil
	end
	local text = fd:read("*a")
	fd:close()
	return text
end

local function config_home()
	return vim.env.XDG_CONFIG_HOME or vim.fs.dirname(vim.fn.stdpath("config"))
end

local function global_rules()
	local path = vim.fs.joinpath(config_home(), "opencode", "AGENTS.md")
	return read_file(path)
end

local function mcp_prompt()
	local ok, mcphub = pcall(require, "mcphub")
	if not ok or type(mcphub.get_hub_instance) ~= "function" then
		return nil
	end
	local hub = mcphub.get_hub_instance()
	if not hub or type(hub.get_active_servers_prompt) ~= "function" then
		return nil
	end
	local prompt = hub:get_active_servers_prompt()
	if prompt and prompt ~= "" then
		return prompt
	end
	return nil
end

local function system_prompt()
	local parts = {}
	local rules = global_rules()
	if rules and rules ~= "" then
		parts[#parts + 1] = rules
	end

	local ok, skills = pcall(require, "qfioofa.plugins.v012.avante.skills")
	if ok then
		local index = skills.index()
		if index and index ~= "" then
			parts[#parts + 1] = index
		end
	end

	local servers = mcp_prompt()
	if servers then
		parts[#parts + 1] = servers
	end

	if vim.g.qfioofa_agent_mode == "plan" then
		parts[#parts + 1] = table.concat({
			"PLAN MODE: you are read-only.",
			"Do not modify files, do not run mutating commands,",
			"and do not use edit_file, write_file, move_item or delete_items.",
			"Investigate, read, search, run read-only commands, and return a concrete plan.",
		}, "\n")
	end

	parts[#parts + 1] = table.concat({
		"TOOL ROUTING (Neovim MCP)",
		"- File and shell operations go through `use_mcp_tool` with server `neovim`.",
		"- Available tools: read_file, read_multiple_files, write_file,",
		"edit_file, find_files, list_directory, move_item, delete_items,",
		"execute_command.",
		"- `edit_file` takes one or more SEARCH/REPLACE blocks:",
		"  <<<<<<< SEARCH",
		"  exact text",
		"  =======",
		"  replacement",
		"  >>>>>>> REPLACE",
		"- Prefer `grep` for content search and `fetch` for URLs.",
		"- Use `write_todos` and `read_todos` for multi-step work.",
		"- Use `dispatch_agent` for read-only exploration.",
		"- Load a matching skill with the `skill` tool before specialized tasks.",
	}, "\n")

	return table.concat(parts, "\n\n")
end

return {
	provider = "omniroute",
	mode = "agentic",
	system_prompt = system_prompt,
	providers = {
		omniroute = {
			__inherited_from = "openai",
			endpoint = "http://localhost:20128/v1",
			model = "opencode-go/deepseek-v4.1-flash",
			api_key_name = "OMNIROUTE_API_KEY",
			context_window = 200000,
			extra_request_body = {
				max_tokens = 16384,
				temperature = 0.2,
			},
		},
	},
	behaviour = {
		auto_suggestions = false,
		auto_set_keymaps = false,
		auto_add_current_file = false,
		auto_apply_diff_after_generation = false,
		confirmation_ui_style = "inline_buttons",
		use_cwd_as_project_root = true,
		allow_access_to_git_ignored_files = false,
		auto_approve_tool_permissions = {
			"grep",
			"fetch",
			"get_diagnostics",
			"read_todos",
			"write_todos",
			"think",
			"dispatch_agent",
			"attempt_completion",
			"skill",
			"use_mcp_tool",
			"access_mcp_resource",
		},
	},
	input = {
		provider = "snacks",
	},
	selector = {
		provider = "snacks",
	},
	windows = {
		position = "right",
		wrap = true,
		width = 34,
	},
	disabled_tools = mode.base_disabled,
	custom_tools = function()
		local tools = {}
		local ok_skills, skills =
			pcall(require, "qfioofa.plugins.v012.avante.skills")
		if ok_skills then
			tools[#tools + 1] = skills.tool
		end
		local ok_mcp, ext = pcall(require, "mcphub.extensions.avante")
		if ok_mcp and type(ext.mcp_tool) == "function" then
			local use_tool, resource_tool = ext.mcp_tool()
			if use_tool then
				tools[#tools + 1] = use_tool
			end
			if resource_tool then
				tools[#tools + 1] = resource_tool
			end
		end
		return tools
	end,
	shortcuts = {},
	prompt_logger = {
		enabled = false,
	},
}
