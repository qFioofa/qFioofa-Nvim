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

local function dirs()
	local home = config_home()
	local cwd = vim.fn.getcwd()
	return {
		vim.fs.joinpath(home, "opencode", "skills"),
		vim.fs.joinpath(cwd, ".opencode", "skills"),
		vim.fs.joinpath(home, "claude", "skills"),
		vim.fs.joinpath(cwd, ".claude", "skills"),
	}
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

local function frontmatter(text)
	local lines = vim.split(text, "\n")
	if lines[1] ~= "---" then
		return nil, nil
	end
	local name, description
	for i = 2, #lines do
		if lines[i] == "---" then
			break
		end
		local key, value = lines[i]:match("^(%w[%w_-]*):%s*(.*)$")
		if key == "name" then
			name = value
		elseif key == "description" then
			description = value
		end
	end
	return clean(name), clean(description)
end

function M.scan()
	local seen, out = {}, {}
	for _, dir in ipairs(dirs()) do
		local files = vim.fn.globpath(dir, "*/SKILL.md", false, true)
		for _, path in ipairs(files) do
			local text = read_file(path)
			if text then
				local name, description = frontmatter(text)
				name = name or vim.fs.basename(vim.fs.dirname(path))
				if name and not seen[name] then
					seen[name] = true
					out[#out + 1] = {
						name = name,
						description = description or "",
						path = path,
						text = text,
					}
				end
			end
		end
	end
	table.sort(out, function(a, b)
		return a.name < b.name
	end)
	return out
end

function M.index()
	local skills = M.scan()
	if #skills == 0 then
		return ""
	end
	local lines = {
		"AVAILABLE SKILLS",
		"Load a matching skill with the `skill` tool before starting the task.",
	}
	for _, skill in ipairs(skills) do
		lines[#lines + 1] = "- " .. skill.name .. ": " .. skill.description
	end
	return table.concat(lines, "\n")
end

M.tool = {
	name = "skill",
	description = "Load a skill's full SKILL.md instructions by name. "
		.. "Call without a name to list available skills.",
	param = {
		type = "table",
		fields = {
			{
				name = "name",
				description = "Skill name (omit to list skills)",
				type = "string",
				optional = true,
			},
		},
	},
	returns = {
		{
			name = "result",
			description = "Skill instructions or the skill index",
		},
	},
	func = function(params)
		local name = params and params.name or nil
		if not name or name == "" then
			return M.index()
		end
		for _, skill in ipairs(M.scan()) do
			if skill.name == name then
				return skill.text
			end
		end
		return nil, "Unknown skill: " .. tostring(name)
	end,
}

return M
