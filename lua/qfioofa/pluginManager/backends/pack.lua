-- vim.pack backend (Neovim >= 0.12). Reads the existing lazy specs and drives
-- vim.pack.add + setup. Loads eagerly: event/ft/cmd/lazy are ignored as
-- triggers; `keys` are applied as real mappings.

local GROUPS = { "common", "v012" }

local function modname_candidates(repo)
	local seg = repo:match("[^/]+$") or repo
	seg = seg:gsub("%.git$", ""):gsub("%.nvim$", "")
	return { seg, (seg:gsub("^nvim%-", "")), (seg:gsub("%-nvim$", "")) }
end

local function url(repo)
	return "https://github.com/" .. repo
end

-- A single spec has a repo string at [1]; a list-of-specs has a table at [1].
local function as_specs(mod)
	if type(mod) ~= "table" then
		return {}
	end
	if type(mod[1]) == "string" then
		return { mod }
	end
	return mod
end

-- Depth-first: dependencies before their dependent.
local function collect(spec, out, builds, seen)
	if type(spec) == "string" then
		spec = { spec }
	end
	local repo = spec[1]
	if type(repo) ~= "string" then
		return
	end

	for _, dep in ipairs(spec.dependencies or {}) do
		collect(dep, out, builds, seen)
	end

	local name = spec.name or repo:match("[^/]+$")
	if spec.build then
		builds[name] = spec.build
	end

	if not seen[repo] then
		seen[repo] = true
		out[#out + 1] = {
			spec = spec,
			entry = {
				src = url(repo),
				name = spec.name,
				version = spec.version
					or spec.commit
					or spec.tag
					or spec.branch,
			},
		}
	end
end

local function run_setup(spec)
	if type(spec.init) == "function" then
		spec.init()
	end

	if type(spec.config) == "function" then
		spec.config()
	elseif spec.opts ~= nil or spec.config == true then
		local opts = spec.opts or {}
		local mod
		if spec.main then
			local ok, m = pcall(require, spec.main)
			mod = ok and m or nil
		else
			for _, cand in ipairs(modname_candidates(spec[1])) do
				local ok, m = pcall(require, cand)
				if ok and type(m) == "table" then
					mod = m
					break
				end
			end
		end
		if mod and type(mod.setup) == "function" then
			mod.setup(opts)
		end
	end

	for _, key in ipairs(spec.keys or {}) do
		if type(key) == "table" and key[2] ~= nil then
			vim.keymap.set(key.mode or "n", key[1], key[2], {
				desc = key.desc,
				silent = key.silent,
				expr = key.expr,
			})
		end
	end
end

local function scan_specs(group)
	local dir = vim.fn.stdpath("config") .. "/lua/qfioofa/plugins/" .. group
	local fs = vim.uv.fs_scandir(dir)
	local specs = {}
	while fs do
		local nm, typ = vim.uv.fs_scandir_next(fs)
		if not nm then
			break
		end
		if typ == "directory" then
			local ok, mod =
				pcall(require, "qfioofa.plugins." .. group .. "." .. nm)
			if ok then
				for _, s in ipairs(as_specs(mod)) do
					specs[#specs + 1] = s
				end
			else
				vim.notify(
					"[pack] failed to load "
						.. group
						.. "."
						.. nm
						.. "\n"
						.. mod,
					vim.log.levels.ERROR
				)
			end
		end
	end
	-- priority desc so colorscheme (1000) loads first.
	table.sort(specs, function(a, b)
		return (a.priority or 50) > (b.priority or 50)
	end)
	return specs
end

local function register_builds(builds)
	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local build = builds[ev.data.spec.name]
			if
				not build
				or (ev.data.kind ~= "install" and ev.data.kind ~= "update")
			then
				return
			end
			if not ev.data.active then
				pcall(vim.cmd.packadd, ev.data.spec.name)
			end
			if build:sub(1, 1) == ":" then
				vim.cmd(build:sub(2))
			else
				vim.system(
					vim.split(build, "%s+", { trimempty = true }),
					{ cwd = ev.data.path }
				)
			end
		end,
	})
end

local function main()
	local ordered, builds, seen = {}, {}, {}
	for _, group in ipairs(GROUPS) do
		for _, s in ipairs(scan_specs(group)) do
			collect(s, ordered, builds, seen)
		end
	end

	register_builds(builds)

	local add = {}
	for _, item in ipairs(ordered) do
		add[#add + 1] = item.entry
	end
	vim.pack.add(add)

	for _, item in ipairs(ordered) do
		local ok, err = pcall(run_setup, item.spec)
		if not ok then
			vim.notify(
				"[pack] setup failed: " .. item.spec[1] .. "\n" .. err,
				vim.log.levels.ERROR
			)
		end
	end
end

-- :lua require("qfioofa.pluginManager.backends.pack").demo()
local function demo()
	assert(modname_candidates("folke/flash.nvim")[1] == "flash")
	assert(modname_candidates("rcarriga/nvim-notify")[2] == "notify")
	assert(url("folke/flash.nvim") == "https://github.com/folke/flash.nvim")

	local single = as_specs({ "a/b", opts = {} })
	assert(#single == 1 and single[1][1] == "a/b")
	assert(#as_specs({ { "a/b" }, { "c/d" } }) == 2)
	assert(#as_specs({}) == 0)

	local out, builds, seen = {}, {}, {}
	collect({
		"a/main",
		commit = "deadbee",
		build = ":TSUpdate",
		dependencies = { "a/dep", { "a/dep2", build = "make" } },
	}, out, builds, seen)
	assert(out[1].spec[1] == "a/dep")
	assert(out[3].spec[1] == "a/main")
	assert(out[3].entry.version == "deadbee")
	assert(builds["main"] == ":TSUpdate" and builds["dep2"] == "make")

	print("pack.demo: ok")
end

return setmetatable({ demo = demo }, { __call = main })
