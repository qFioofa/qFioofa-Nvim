-- sql-language-server (mason package "sqlls") ships pinned copies of
-- vscode-languageserver-* / vscode-jsonrpc whose package.json `exports` only
-- expose the top-level entry points. The server itself still `require()`s deep
-- `./lib/...` subpaths, which Node >= 20 rejects with ERR_PACKAGE_PATH_NOT_EXPORTED,
-- so the client crashes immediately ("quit with exit code 1").
--
-- Re-add the `./lib/*` subpaths to every nested package that has both an object
-- `exports` map and a `lib/` directory. Idempotent, so it is safe to run on every
-- Mason update; it must re-run because Mason overwrites node_modules on reinstall.
--
-- See memory: this is a Node strict-exports issue, not a NixOS one.

local M = {}

local uv = vim.uv or vim.loop

local function patch_one(pkg_json)
	local fd = io.open(pkg_json, "r")
	if not fd then
		return false
	end
	local raw = fd:read("*a")
	fd:close()

	local ok, data = pcall(vim.json.decode, raw)
	if not ok or type(data) ~= "table" then
		return false
	end

	local exports = data.exports
	if type(exports) ~= "table" or exports["./lib/*"] then
		return false
	end

	-- Only meaningful if there is actually a lib/ dir next to package.json.
	local dir = vim.fs.dirname(pkg_json)
	if uv.fs_stat(dir .. "/lib") == nil then
		return false
	end

	exports["./lib/*.js"] = "./lib/*.js"
	exports["./lib/*"] = "./lib/*.js"

	local out = io.open(pkg_json, "w")
	if not out then
		return false
	end
	out:write(vim.json.encode(data))
	out:close()
	return true
end

-- Recursively collect package.json paths under `dir`.
local function collect(dir, acc)
	local handle = uv.fs_scandir(dir)
	if not handle then
		return
	end
	while true do
		local name, typ = uv.fs_scandir_next(handle)
		if not name then
			break
		end
		local path = dir .. "/" .. name
		if typ == "directory" then
			collect(path, acc)
		elseif name == "package.json" then
			acc[#acc + 1] = path
		end
	end
end

-- Patch the sqlls install in place. Returns the number of packages patched.
function M.run()
	local root = vim.fn.stdpath("data")
		.. "/mason/packages/sqlls/node_modules"
	if uv.fs_stat(root) == nil then
		return 0
	end

	local files = {}
	collect(root, files)

	local patched = 0
	for _, f in ipairs(files) do
		if patch_one(f) then
			patched = patched + 1
		end
	end
	return patched
end

return M
