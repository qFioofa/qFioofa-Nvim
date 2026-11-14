local function file_exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

local function read_file(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local content = f:read("*a")
	f:close()
	return content
end

local function write_file(path, content)
	local f, err = io.open(path, "w")
	if not f then
		error("cannot write " .. path .. ": " .. tostring(err))
	end
	f:write(content)
	f:close()
end

local function shell_quote(value)
	return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function first_difference(expected, actual)
	local expected_lines = {}
	local actual_lines = {}
	for line in (expected or ""):gmatch("([^\n]*)\n?") do
		expected_lines[#expected_lines + 1] = line
	end
	for line in (actual or ""):gmatch("([^\n]*)\n?") do
		actual_lines[#actual_lines + 1] = line
	end
	local count = math.max(#expected_lines, #actual_lines)
	for i = 1, count do
		if expected_lines[i] ~= actual_lines[i] then
			return i, expected_lines[i], actual_lines[i]
		end
	end
	return nil
end

local function compare(path, expected)
	if not file_exists(path) then
		print("missing: " .. path)
		return false
	end
	local actual = read_file(path)
	if actual == expected then
		return true
	end

	local tmp = os.tmpname()
	write_file(tmp, expected)
	local diff = "diff -u " .. shell_quote(path) .. " " .. shell_quote(tmp)
	local status = os.execute(diff)
	os.remove(tmp)
	if status == 0 or status == true then
		return true
	end

	if not status or status == -1 then
		local line, want, got = first_difference(expected, actual)
		print(
			("first difference in %s at line %s"):format(path, tostring(line))
		)
		print("expected: " .. tostring(want))
		print("actual:   " .. tostring(got))
	end
	return false
end

local function find_root()
	local candidates = {
		vim.fn.getcwd(),
		vim.fn.fnamemodify(arg and arg[0] or "", ":p:h:h"),
	}
	for _, candidate in ipairs(candidates) do
		if candidate and candidate ~= "" then
			if
				file_exists(candidate .. "/lua/qfioofa/init.lua")
				and file_exists(candidate .. "/scripts/docs/meta.lua")
			then
				return candidate
			end
		end
	end
	error("cannot locate repository root (run from the config root)")
end

local function load_doc_module(root, name)
	local path = root .. "/scripts/docs/" .. name .. ".lua"
	local chunk, err = loadfile(path)
	if not chunk then
		error("cannot load " .. path .. ": " .. tostring(err))
	end
	local ok, result = pcall(chunk)
	if not ok then
		error("error loading " .. path .. ":\n" .. tostring(result))
	end
	return result
end

local function self_test(data, rendered)
	local errors = {}

	local expected = {
		"<leader>ff",
		"<leader>rn",
		"gd",
		"]c",
		"ih",
		"<C-e>",
		"<leader>jc",
		"<leader>gv",
		"<leader>hp",
		"<leader>U",
		"<leader>ss",
	}

	local seen = {}
	for _, entry in ipairs(data.entries) do
		seen[entry.lhs] = true
		if not entry.desc and entry.section ~= "neutral" then
			errors[#errors + 1] = "missing desc: "
				.. entry.lhs
				.. " in "
				.. tostring(entry.source)
		end
	end
	for _, lhs in ipairs(expected) do
		if not seen[lhs] then
			errors[#errors + 1] = "missing expected binding: " .. lhs
		end
	end

	for _, name in ipairs({ "agents", "binds" }) do
		local text = rendered[name] or ""
		if #text < 200 then
			errors[#errors + 1] = "rendered output too small: " .. name
		end
		if
			not text:find("AGENTS.md", 1, true)
			and not text:find("BINDS.md", 1, true)
		then
			errors[#errors + 1] = "rendered output has no title: " .. name
		end
	end

	if #errors > 0 then
		for _, err in ipairs(errors) do
			print("self-test: " .. err)
		end
		return false
	end
	print("self-test: ok (" .. #data.entries .. " entries)")
	return true
end

local function main()
	local root = find_root()

	local meta = load_doc_module(root, "meta")
	local collect = load_doc_module(root, "collect")
	local render = load_doc_module(root, "render")

	local mode = "check"
	for _, value in ipairs(arg or {}) do
		if
			value == "--write"
			or value == "--check"
			or value == "--self-test"
		then
			mode = value:sub(3)
		elseif value == "--help" or value == "-h" then
			print(
				"usage: nvim --clean -l scripts/gen_docs.lua [--write|--check|--self-test]"
			)
			return 0
		else
			print("unknown argument: " .. value)
			return 2
		end
	end

	local data = collect.collect({ root = root, meta = meta })
	local rendered = render.render(data, meta, root)

	local ok = true
	if #data.errors > 0 then
		ok = false
		for _, err in ipairs(data.errors) do
			print("error: " .. err)
		end
	end

	if mode == "write" then
		write_file(root .. "/AGENTS.md", rendered.agents)
		write_file(root .. "/BINDS.md", rendered.binds)
		print(
			"wrote AGENTS.md and BINDS.md ("
				.. data.stats.bindings
				.. " active bindings)"
		)
	elseif mode == "self-test" then
		local rendered_again = render.render(data, meta, root)
		if
			rendered_again.agents ~= rendered.agents
			or rendered_again.binds ~= rendered.binds
		then
			print("self-test: rendering is not deterministic")
			ok = false
		end
		ok = self_test(data, rendered) and ok
	else
		local agents_ok = compare(root .. "/AGENTS.md", rendered.agents)
		local binds_ok = compare(root .. "/BINDS.md", rendered.binds)
		ok = agents_ok and binds_ok and ok
		if ok then
			print(
				"docs are in sync ("
					.. data.stats.bindings
					.. " active bindings)"
			)
		else
			print("docs are stale; run `make docs`")
		end
	end

	return ok and 0 or 1
end

local ok, result = pcall(main)
if not ok then
	print("gen_docs: " .. tostring(result))
	os.exit(1)
end
os.exit(result)
