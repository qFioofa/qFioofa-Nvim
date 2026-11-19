local M = {}

local plan_mutation_tools = {
	edit_file = true,
	write_file = true,
	move_item = true,
	delete_items = true,
}

local plan_mutating_commands = {
	"^%s*rm%s",
	"^%s*mv%s",
	"^%s*cp%s",
	"^%s*dd%s",
	"^%s*truncate%s",
	"^%s*sed%s+%-i",
	"^%s*perl%s+%-pi",
	"^%s*git%s+commit",
	"^%s*git%s+push",
	"^%s*git%s+checkout%s+%-%-",
	"^%s*npm%s+install",
	"^%s*bundle%s+install",
	"^%s*make%s",
	"^%s*kamal%s",
	"^%s*terraform%s",
	"^%s*kubectl%s",
	">",
	"|%s*tee%s",
}

local function command_permission(command)
	local cmd = vim.trim(tostring(command or ""))
	if cmd == "" then
		return true
	end

	if
		cmd:match("^%s*rm%s")
		and (cmd:match("%-[%w]*r[%w]*f") or cmd:match("%-[%w]*f[%w]*r"))
	then
		return "Denied by policy: rm -rf"
	end
	if cmd:match("^%s*kamal%s+setup") then
		return "Denied by policy: kamal setup"
	end
	if cmd:match("^%s*terraform%s+apply") then
		return "Denied by policy: terraform apply"
	end
	if cmd:match("^%s*kubectl%s+delete") then
		return "Denied by policy: kubectl delete"
	end
	if cmd:match("^%s*git%s+push") then
		return false
	end
	if cmd:match("^%s*kamal%s+deploy") then
		return false
	end
	return true
end

local function plan_allows_command(command)
	local cmd = tostring(command or "")
	for _, pattern in ipairs(plan_mutating_commands) do
		if cmd:match(pattern) then
			return false
		end
	end
	return true
end

function M.auto_approve(params)
	params = params or {}
	local server = params.server_name or ""
	local tool = params.tool_name or ""
	local args = params.arguments or {}
	local plan = vim.g.qfioofa_agent_mode == "plan"

	if plan then
		if server == "neovim" and plan_mutation_tools[tool] then
			return "Plan mode: file mutations are disabled."
		end
		if
			server == "neovim"
			and tool == "execute_command"
			and not plan_allows_command(args.command)
		then
			return "Plan mode: mutating commands are disabled."
		end
	end

	if params.is_auto_approved_in_server then
		return true
	end

	if server == "neovim" then
		if tool == "execute_command" then
			return command_permission(args.command)
		end
		if
			tool == "read_file"
			or tool == "read_multiple_files"
			or tool == "find_files"
			or tool == "list_directory"
		then
			return true
		end
		if tool == "edit_file" or tool == "write_file" then
			return false
		end
		if tool == "move_item" or tool == "delete_items" then
			return false
		end
		if tool == "execute_lua" then
			return false
		end
	end

	return false
end

return M
