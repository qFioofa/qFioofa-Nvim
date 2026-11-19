local M = {}

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

local function clean(value)
	if not value then
		return nil
	end
	value = vim.trim(value)
	value = value:gsub('^"', ""):gsub('"$', "")
	value = value:gsub("^'", ""):gsub("'$", "")
	if value == "" then
		return nil
	end
	return value
end

local function strip_frontmatter(text)
	local lines = vim.split(text, "\n")
	if lines[1] ~= "---" then
		return text
	end
	for i = 2, #lines do
		if lines[i] == "---" then
			return table.concat(lines, "\n", i + 1)
		end
	end
	return text
end

local function frontmatter_value(text, key)
	local lines = vim.split(text, "\n")
	if lines[1] ~= "---" then
		return nil
	end
	for i = 2, #lines do
		if lines[i] == "---" then
			break
		end
		local k, v = lines[i]:match("^(%w[%w_-]*):%s*(.*)$")
		if k == key then
			return clean(v)
		end
	end
	return nil
end

local function sanitize(name)
	return (name:gsub("[^%w_-]+", "-"))
end

local function load_dir(dir, kind)
	local out = {}
	for _, path in ipairs(vim.fn.globpath(dir, "*.md", false, true)) do
		local text = read_file(path)
		if text then
			local body = vim.trim(strip_frontmatter(text))
			body = body:gsub("%$ARGUMENTS", "")
			body = vim.trim(body)
			if body ~= "" then
				local name = sanitize(vim.fs.basename(path):gsub("%.md$", ""))
				local description = frontmatter_value(text, "description")
					or body:match("^%s*([^\n]+)")
					or name
				local prompt
				if kind == "agent" then
					prompt = "Adopt the following role and instructions.\n\n"
						.. body
						.. "\n\nTask: "
				else
					prompt = body .. "\n\n"
				end
				out[#out + 1] = {
					name = name,
					description = description,
					prompt = prompt,
				}
			end
		end
	end
	return out
end

function M.load()
	local home = config_home()
	local seen, out = {}, {}
	local sources = {
		{ vim.fs.joinpath(home, "opencode", "agents"), "agent" },
		{ vim.fs.joinpath(home, "opencode", "commands"), "command" },
	}
	for _, source in ipairs(sources) do
		for _, shortcut in ipairs(load_dir(source[1], source[2])) do
			if not seen[shortcut.name] then
				seen[shortcut.name] = true
				out[#out + 1] = shortcut
			end
		end
	end
	return out
end

return M
