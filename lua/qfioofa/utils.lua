local CONFIG_ROOT = "qfioofa."
local OPTIONS_ROOT = CONFIG_ROOT .. "options."
local PLUGINS_ROOT = CONFIG_ROOT .. "plugins."
local THEME_ROOT = "theme."
local PLUGINMANAGER_ROOT = "pluginManager."

local NOTIFY = true

local function is_editable(bufnr)
	if bufnr == nil or bufnr == 0 then
		bufnr = vim.api.nvim_get_current_buf()
	end
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end

	local bo = vim.bo[bufnr]
	if bo.buftype ~= "" or bo.readonly or not bo.modifiable then
		return false
	end

	local name = vim.api.nvim_buf_get_name(bufnr)
	if
		name:match("^diffview://")
		or name:match("^fugitive://")
		or name:match("^oil://")
		or name:match("^term://")
	then
		return false
	end

	return true
end

local function nWarn(message)
	if not message or type(message) ~= "string" then
		vim.notify("nWarn: need message to display", vim.log.levels.ERROR)
		return
	end
	vim.notify(message, vim.log.levels.WARN)
end

local function nError(message)
	if not message or type(message) ~= "string" then
		vim.notify("nError: need message to display", vim.log.levels.ERROR)
		return
	end
	vim.notify(message, vim.log.levels.ERROR)
end

local function saveInit(path, root)
	if not path or type(path) ~= "string" then
		if NOTIFY then
			nWarn("[saveInit] | path | Should be provided or string")
		end
		return
	end

	local _root = root or CONFIG_ROOT
	local full_module_path = _root .. path

	local success, Function = pcall(require, full_module_path)

	if not success then
		if NOTIFY then
			nWarn(
				"[saveInit] | "
					.. full_module_path
					.. " | Error in loading relative path |\n"
					.. Function
			)
		end
		return
	end

	if type(Function) == "function" then
		Function()
	end
end

return {
	saveInit = saveInit,
	is_editable = is_editable,
	notify = NOTIFY,
	nWarn = nWarn,
	nError = nError,
	roots = {
		config = CONFIG_ROOT,
		options = OPTIONS_ROOT,
		plugins = PLUGINS_ROOT,
		theme = THEME_ROOT,
		pluginManager = PLUGINMANAGER_ROOT,
	},
}
