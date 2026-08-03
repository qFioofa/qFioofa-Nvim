-- Quick Java file creation with the correct `package` statement, optional
-- imports and a starter body (class/interface/enum/record/...).
--
-- Usage (the :JNew command registered in setup()):
--   :JNew                        interactive prompt (type + name)
--   :JNew class User             class in the current package
--   :JNew record Point int x, int y
--   :JNew class com.example.controller.UserController
--   :JNew src/main/java/com/example/App.java
--   :JNew main App java.util.List java.util.Map
--
-- Anything after the file name that contains a "." is treated as an import.
-- <leader>fn also routes into this when a Java source root is present.

local M = {}

local SOURCE_ROOTS = { "src/main/java", "src/test/java", "src/java" }
M.SOURCE_ROOTS = SOURCE_ROOTS

local TYPES = { "class", "interface", "enum", "record", "main", "file" }

-- `___CURSOR___` marks where the cursor lands after creation.
local TEMPLATES = {
	file = function()
		return {}
	end,
	class = function(name)
		return { "public class " .. name .. " {", "___CURSOR___", "}" }
	end,
	main = function(name)
		return {
			"public class " .. name .. " {",
			"	public static void main(String[] args) {",
			"		___CURSOR___",
			"	}",
			"}",
		}
	end,
	interface = function(name)
		return { "public interface " .. name .. " {", "___CURSOR___", "}" }
	end,
	enum = function(name)
		return { "public enum " .. name .. " {", "	___CURSOR___,", "}" }
	end,
	record = function(name, components)
		return {
			"public record " .. name .. "(" .. (components or "") .. ") {",
			"___CURSOR___",
			"}",
		}
	end,
}

-- Walk up from `start` (dir or current buffer dir) until a known Java source
-- root (src/main/java, src/test/java, src/java) is found.
function M.find_source_root(start)
	local dir = vim.fn.fnamemodify(start or vim.fn.getcwd(), ":p")
	dir = dir:gsub("/+$", "")
	while true do
		-- `dir` itself is a source root (we started inside one).
		for _, root in ipairs(SOURCE_ROOTS) do
			if dir == root or vim.endswith(dir, "/" .. root) then
				return dir
			end
		end
		-- `dir` contains a source root.
		for _, root in ipairs(SOURCE_ROOTS) do
			if vim.fn.isdirectory(dir .. "/" .. root) == 1 then
				return dir .. "/" .. root
			end
		end
		local parent = vim.fn.fnamemodify(dir, ":h")
		if parent == dir then
			return nil
		end
		dir = parent
	end
end

-- "src/main/java/com/example/App.java" + root -> "com.example"
function M.package_from_path(path, root)
	if not root then
		return ""
	end
	local dir = vim.fn.fnamemodify(path, ":p:h")
	local prefix = vim.fn.fnamemodify(root, ":p")
	if dir == prefix then
		return ""
	end
	if vim.startswith(dir, prefix .. "/") then
		return dir:sub(#prefix + 2):gsub("/", ".")
	end
	return ""
end

-- Read `package x.y.z;` from the current buffer, if any.
function M.current_package()
	local last = math.min(10, vim.api.nvim_buf_line_count(0))
	for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, last, false)) do
		local pkg = line:match("^%s*package%s+([%w%.]+)%s*;")
		if pkg then
			return pkg
		end
	end
	return ""
end

-- Directory the current buffer's package maps to (under its own source root).
function M.current_package_dir()
	local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
	if not bufname:match("%.java$") then
		return nil
	end
	local dir = vim.fn.fnamemodify(bufname, ":h")
	local root = M.find_source_root(dir)
	if not root then
		return nil
	end
	local pkg = M.package_from_path(bufname, root)
	if pkg == "" then
		return dir
	end
	return root .. "/" .. pkg:gsub("%.", "/")
end

-- Resolve a user-supplied name/path into an absolute target path.
--   com.example.App          -> <root>/com/example/App.java
--   src/main/java/...        -> path relative to cwd
--   /abs/path[.java]         -> absolute path
--   App                      -> current package dir (or <root>) / App.java
function M.resolve_path(name, root)
	local cleaned = name:gsub("%.java$", "")

	if cleaned:find("/", 1, true) then
		return vim.fn.fnamemodify(cleaned, ":p") .. ".java"
	end

	if cleaned:find(".", 1, true) then
		return root .. "/" .. cleaned:gsub("%.", "/") .. ".java"
	end

	if not cleaned:match("^[%a_][%w_]*$") then
		return nil
	end

	local pkg_dir = M.current_package_dir()
	if pkg_dir and pkg_dir:sub(1, #root) == root then
		return pkg_dir .. "/" .. cleaned .. ".java"
	end

	return root .. "/" .. cleaned .. ".java"
end

-- Build the file content: package + sorted imports + body.
function M.assemble(pkg, imports, body)
	local lines = {}
	if pkg and pkg ~= "" then
		lines[#lines + 1] = "package " .. pkg .. ";"
		lines[#lines + 1] = ""
	end
	if #imports > 0 then
		table.sort(imports)
		for _, imp in ipairs(imports) do
			lines[#lines + 1] = "import " .. imp .. ";"
		end
		lines[#lines + 1] = ""
	end
	for _, line in ipairs(body) do
		lines[#lines + 1] = line
	end
	return lines
end

function M.create(opts)
	opts = opts or {}
	local typ = opts.type or "class"
	local name = opts.name or ""

	local root = opts.root or M.find_source_root()
	if not root then
		vim.notify(
			"JNew: no Java source root found (src/main/java, src/test/java)",
			vim.log.levels.WARN
		)
		return false
	end

	local path = opts.path or M.resolve_path(name, root)
	if not path then
		vim.notify("JNew: invalid file name: " .. tostring(name), vim.log.levels.WARN)
		return false
	end

	local filename = vim.fn.fnamemodify(path, ":t:r")

	local body
	if typ == "record" then
		body = TEMPLATES.record(filename, opts.components or "")
	else
		body = (TEMPLATES[typ] or TEMPLATES.class)(filename)
	end

	local lines = M.assemble(M.package_from_path(path, root), opts.imports or {}, body)

	local dir = vim.fn.fnamemodify(path, ":h")
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end

	local fd = io.open(path, "w")
	if not fd then
		vim.notify("JNew: cannot write " .. path, vim.log.levels.ERROR)
		return false
	end
	fd:write(table.concat(lines, "\n") .. "\n")
	fd:close()

	vim.cmd("edit " .. vim.fn.fnameescape(path))

	-- Land on the ___CURSOR___ marker (and delete it).
	local jumped = false
	for i, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
		local col = line:find("___CURSOR___", 1, true)
		if col then
			local prefix = line:sub(1, col - 1)
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { prefix })
			vim.fn.cursor(i, #prefix + 1)
			jumped = true
			break
		end
	end

	if jumped then
		vim.cmd("startinsert")
	end

	return true
end

function M.setup()
	vim.api.nvim_create_user_command("JNew", function(o)
		local args = vim.split(o.args, "%s+", { trimempty = true })

		if #args == 0 then
			local typ = vim.fn.input("Type [" .. table.concat(TYPES, "/") .. "]: ", "class")
			local name = vim.fn.input("Name or package.Name: ", "")
			if name == "" then
				return
			end
			M.create({ type = typ, name = name })
			return
		end

		local typ = "class"
		if vim.tbl_contains(TYPES, args[1]) then
			typ = table.remove(args, 1)
		end

		local name = table.remove(args, 1) or ""
		if name == "" then
			vim.notify("JNew: missing file name", vim.log.levels.WARN)
			return
		end

		local imports, comps = {}, {}
		for _, arg in ipairs(args) do
			if arg:find(".", 1, true) then
				imports[#imports + 1] = arg
			else
				comps[#comps + 1] = arg
			end
		end

		M.create({
			type = typ,
			name = name,
			imports = imports,
			components = table.concat(comps, " "),
		})
	end, {
		nargs = "*",
		desc = "Create Java file with package/imports/type",
		complete = function(arglead, cmdline, _)
			local rest = cmdline:match("^JNew%s+(.*)$") or ""
			if not rest:find("%s") then
				return vim.tbl_filter(function(t)
					return vim.startswith(t, arglead)
				end, TYPES)
			end
			return {}
		end,
	})
end

return M
