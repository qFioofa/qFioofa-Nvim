local M = {}

M.base_disabled = {
	"view",
	"write_to_file",
	"insert",
	"str_replace",
	"edit_file",
	"undo_edit",
	"ls",
	"glob",
	"bash",
	"move_path",
	"copy_path",
	"delete_path",
	"create_dir",
	"read_global_file",
	"write_global_file",
	"run_python",
}

local plan_disabled = {
	"write_to_file",
	"insert",
	"str_replace",
	"edit_file",
	"undo_edit",
	"move_path",
	"copy_path",
	"delete_path",
	"create_dir",
	"bash",
	"run_python",
	"write_global_file",
}

local function disabled_for(mode)
	local tools = vim.deepcopy(M.base_disabled)
	if mode == "plan" then
		for _, name in ipairs(plan_disabled) do
			if not vim.tbl_contains(tools, name) then
				tools[#tools + 1] = name
			end
		end
	end
	return tools
end

function M.apply()
	local ok, config = pcall(require, "avante.config")
	if not ok then
		return
	end
	config.disabled_tools = disabled_for(M.current())
end

function M.current()
	return vim.g.qfioofa_agent_mode or "build"
end

function M.set(mode)
	mode = tostring(mode or ""):lower()
	if mode ~= "plan" and mode ~= "build" then
		vim.notify("AgentMode: expected plan or build", vim.log.levels.WARN)
		return
	end
	vim.g.qfioofa_agent_mode = mode
	M.apply()
	vim.notify("Agent mode: " .. mode, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("AgentMode", function(opts)
	M.set(opts.args)
end, {
	nargs = 1,
	complete = function()
		return { "plan", "build" }
	end,
	desc = "Set the Avante agent mode",
})

return M
