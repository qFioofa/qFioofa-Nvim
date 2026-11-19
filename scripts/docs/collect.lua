local M = {}

local function read_file(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local content = f:read("*a")
	f:close()
	return content
end

local function file_exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

local function list_dirs(path)
	local out = {}
	local ok, iter, state = pcall(vim.fs.dir, path)
	if ok and iter then
		for name, typ in iter, state do
			if typ == "directory" and name:sub(1, 1) ~= "." then
				out[#out + 1] = name
			end
		end
	else
		local p = io.popen(
			'find "'
				.. path
				.. '" -mindepth 1 -maxdepth 1 -type d -printf "%f\\n" 2>/dev/null'
		)
		if p then
			for name in p:lines() do
				if name:sub(1, 1) ~= "." then
					out[#out + 1] = name
				end
			end
			p:close()
		end
	end
	table.sort(out)
	return out
end

local function relpath(root, path)
	path = tostring(path or "")
	if path:sub(1, 1) == "@" then
		path = path:sub(2)
	end
	local prefix = root .. "/"
	if path:sub(1, #prefix) == prefix then
		return path:sub(#prefix + 1)
	end
	return path
end

local function line_of(path, needle)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local i = 0
	for line in f:lines() do
		i = i + 1
		if line:find(needle, 1, true) then
			f:close()
			return i
		end
	end
	f:close()
	return nil
end

local function line_text(path, number)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local i = 0
	local found
	for line in f:lines() do
		i = i + 1
		if i == number then
			found = line
			break
		end
	end
	f:close()
	return found
end

local function line_for(path, lhs, current_line)
	if current_line then
		local quoted = '"' .. lhs .. '"'
		for offset = 0, 8 do
			local numbers = { current_line + offset }
			if offset > 0 then
				numbers[#numbers + 1] = current_line - offset
			end
			for _, number in ipairs(numbers) do
				local text = line_text(path, number)
				if text and text:find(quoted, 1, true) then
					return number
				end
			end
		end

		local text = line_text(path, current_line)
		if text and text:find(lhs, 1, true) then
			return current_line
		end
	end
	return line_of(path, '"' .. lhs .. '"')
		or line_of(path, lhs)
		or current_line
end

local function normalize_modes(mode)
	if type(mode) ~= "table" then
		mode = { mode or "n" }
	end
	if mode[1] == "" then
		return { "n", "x", "s", "o" }
	end
	local out = {}
	for _, m in ipairs(mode) do
		if type(m) == "string" and m ~= "" and not vim.tbl_contains(out, m) then
			out[#out + 1] = m
		end
	end
	if #out == 0 then
		out[1] = "n"
	end
	return out
end

local function make_stub(name)
	local value = {}
	setmetatable(value, {
		__index = function(self, key)
			local child = make_stub(name .. "." .. tostring(key))
			rawset(self, key, child)
			return child
		end,
		__call = function()
			return make_stub(name .. "()")
		end,
		__add = function()
			return make_stub(name .. "+")
		end,
		__sub = function()
			return make_stub(name .. "-")
		end,
		__mul = function()
			return make_stub(name .. "*")
		end,
		__div = function()
			return make_stub(name .. "/")
		end,
		__mod = function()
			return make_stub(name .. "%")
		end,
		__pow = function()
			return make_stub(name .. "^")
		end,
		__unm = function()
			return make_stub(name .. "u-")
		end,
		__concat = function()
			return name
		end,
		__tostring = function()
			return name
		end,
	})
	return value
end

local function make_fnamemodify()
	return function(path, mods)
		local p = tostring(path or "")
		for mod in tostring(mods or ""):gmatch(":(%a)") do
			if mod == "p" then
				if p:sub(1, 1) ~= "/" then
					p = "/" .. p
				end
			elseif mod == "h" then
				p = p:match("^(.*)/[^/]*$") or "."
			elseif mod == "t" then
				p = p:match("([^/]+)/*$") or p
			end
		end
		return p
	end
end

local function option_proxy()
	local value
	value = setmetatable({}, {
		__index = function()
			return value
		end,
		__call = function()
			return nil
		end,
	})
	return value
end

local function make_vim(state)
	local vim = {}

	vim.g = {}
	vim.env = {}
	vim.o = setmetatable({}, {
		__index = function()
			return 0
		end,
	})
	vim.opt = setmetatable({}, {
		__index = function()
			return option_proxy()
		end,
		__newindex = function() end,
	})
	vim.opt_local = vim.opt
	vim.opt_global = vim.opt
	vim.bo = vim.opt
	vim.wo = vim.opt

	vim.log = { levels = { DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4 } }
	vim.version = { major = 0, minor = 12, patch = 0 }

	vim.tbl_contains = function(t, value)
		for _, v in ipairs(t or {}) do
			if v == value then
				return true
			end
		end
		return false
	end
	vim.tbl_keys = function(t)
		local out = {}
		for k in pairs(t or {}) do
			out[#out + 1] = k
		end
		return out
	end
	vim.tbl_filter = function(fn, t)
		local out = {}
		for _, v in ipairs(t or {}) do
			if fn(v) then
				out[#out + 1] = v
			end
		end
		return out
	end
	vim.tbl_extend = function(_, ...)
		local out = {}
		for i = 1, select("#", ...) do
			local t = select(i, ...)
			if type(t) == "table" then
				for k, v in pairs(t) do
					out[k] = v
				end
			end
		end
		return out
	end
	vim.tbl_flatten = function(t)
		local out = {}
		local function walk(v)
			for _, item in ipairs(v or {}) do
				if type(item) == "table" then
					walk(item)
				else
					out[#out + 1] = item
				end
			end
		end
		walk(t)
		return out
	end
	vim.list_extend = function(dst, src)
		for _, v in ipairs(src or {}) do
			dst[#dst + 1] = v
		end
		return dst
	end
	vim.split = function(s, sep, opts)
		local out = {}
		local pattern = "([^" .. sep .. "]+)"
		for part in tostring(s or ""):gmatch(pattern) do
			if not (opts and opts.trimempty) or part ~= "" then
				out[#out + 1] = part
			end
		end
		return out
	end
	vim.startswith = function(s, prefix)
		return tostring(s):sub(1, #prefix) == prefix
	end
	vim.endswith = function(s, suffix)
		s = tostring(s)
		return s:sub(-#suffix) == suffix
	end
	vim.deepcopy = function(t)
		if type(t) ~= "table" then
			return t
		end
		local out = {}
		for k, v in pairs(t) do
			out[k] = vim.deepcopy(v)
		end
		return out
	end

	vim.fn = {
		expand = function()
			return ""
		end,
		input = function()
			return ""
		end,
		fnameescape = function(s)
			return s
		end,
		fnamemodify = make_fnamemodify(),
		system = function()
			return 'openjdk version "21.0.2" 2024-01-16'
		end,
		systemlist = function()
			return {}
		end,
		executable = function()
			return 1
		end,
		exepath = function(name)
			return "/usr/bin/" .. tostring(name)
		end,
		glob = function(pattern, _, list)
			if list then
				return {}
			end
			if tostring(pattern):find("launcher_", 1, true) then
				return "/tmp/jdtls/launcher.jar"
			end
			return ""
		end,
		isdirectory = function()
			return 1
		end,
		filereadable = function()
			return 0
		end,
		stdpath = function(kind)
			return "/tmp/nvim-" .. tostring(kind)
		end,
		getcwd = function()
			return "/tmp/project"
		end,
		has = function()
			return 0
		end,
		line = function()
			return 1
		end,
		col = function()
			return 1
		end,
		getline = function()
			return ""
		end,
		mode = function()
			return "n"
		end,
		getbufvar = function()
			return ""
		end,
		readfile = function()
			return {}
		end,
		sign_define = function() end,
		tempname = function()
			return "/tmp/nvim-docs"
		end,
		resolve = function(p)
			return p
		end,
		exists = function()
			return 0
		end,
		getenv = function()
			return ""
		end,
		setenv = function() end,
		shellescape = function(s)
			return s
		end,
		isabs = function()
			return false
		end,
		bufnr = function()
			return 0
		end,
		win_getid = function()
			return 0
		end,
		getpos = function()
			return { 0, 0, 0, 0 }
		end,
		getcurpos = function()
			return {}
		end,
		confirm = function()
			return 0
		end,
	}

	vim.api = {
		nvim_create_user_command = function() end,
		nvim_create_autocmd = function() end,
		nvim_create_augroup = function()
			return 0
		end,
		nvim_set_hl = function() end,
		nvim_get_hl = function()
			return {}
		end,
		nvim_get_option_value = function()
			return ""
		end,
		nvim_set_option_value = function() end,
		nvim_buf_get_name = function()
			return ""
		end,
		nvim_get_current_line = function()
			return ""
		end,
		nvim_win_get_cursor = function()
			return { 1, 0 }
		end,
		nvim_buf_get_lines = function()
			return {}
		end,
		nvim_buf_line_count = function()
			return 1
		end,
		nvim_get_current_buf = function()
			return 0
		end,
		nvim_get_current_win = function()
			return 0
		end,
		nvim_win_get_config = function()
			return { relative = "" }
		end,
		nvim_tabpage_list_wins = function()
			return {}
		end,
		nvim_win_get_width = function()
			return 120
		end,
		nvim_get_mode = function()
			return { mode = "n" }
		end,
		nvim_replace_termcodes = function(s)
			return s
		end,
		nvim_feedkeys = function() end,
		nvim_win_set_cursor = function() end,
		nvim_buf_set_lines = function() end,
		nvim_buf_is_valid = function()
			return true
		end,
		nvim_win_is_valid = function()
			return true
		end,
		nvim_buf_delete = function() end,
		nvim_list_bufs = function()
			return {}
		end,
		nvim_buf_get_option = function()
			return ""
		end,
		nvim_exec_autocmds = function() end,
		nvim_clear_autocmds = function() end,
		nvim_del_augroup_by_name = function() end,
		nvim_echo = function() end,
		nvim_open_win = function()
			return 0
		end,
		nvim_win_close = function() end,
		nvim_get_current_tabpage = function()
			return 0
		end,
		nvim_tabpage_get_win = function()
			return 0
		end,
		nvim_get_option_info2 = function()
			return {}
		end,
		nvim_buf_get_var = function()
			return nil
		end,
		nvim_buf_set_var = function() end,
		nvim_get_var = function()
			return nil
		end,
		nvim_set_var = function() end,
	}

	vim.lsp = {
		protocol = {
			make_client_capabilities = function()
				return {}
			end,
		},
		get_client_by_id = function()
			return state.client
		end,
		get_clients = function()
			if state.client then
				return { state.client }
			end
			return {}
		end,
		buf_detach_client = function() end,
		start = function() end,
		enable = function() end,
		config = function() end,
		rpc = { start = function() end },
		buf = {
			rename = function() end,
			code_action = function() end,
			range_code_action = function() end,
			signature_help = function() end,
			declaration = function() end,
			request = function() end,
			document_highlight = function() end,
			clear_references = function() end,
		},
		codelens = {
			refresh = function() end,
			run = function() end,
		},
		inlay_hint = {
			enable = function() end,
			is_enabled = function()
				return false
			end,
		},
	}
	vim.diagnostic = {
		get = function()
			return {}
		end,
		setloclist = function() end,
		is_enabled = function()
			return true
		end,
		enable = function() end,
		config = function() end,
	}

	vim.fs = {
		root = function()
			return "/tmp/project"
		end,
		find = function()
			return {}
		end,
		joinpath = table.concat,
	}
	vim.uv = {
		fs_stat = function()
			return nil
		end,
	}
	vim.loop = vim.uv

	vim.keymap = {
		set = function(mode, lhs, rhs, opts)
			opts = opts or {}
			local info = debug.getinfo(2, "Sl")
			local source = relpath(state.root, info and info.source or "")
			local line = line_for(
				state.root .. "/" .. source,
				lhs,
				info and info.currentline or nil
			)
			local current = state.current or {}
			local scope = current.scope or "global"
			local context = current.context or scope
			local section = current.section or "other"
			local action = type(rhs) == "string" and rhs or nil
			local desc = opts.desc

			if opts.buffer ~= nil then
				if scope == "lsp" then
					scope = "lsp"
				end
			elseif
				scope == "lsp"
				or scope == "java"
				or scope == "ruby"
				or scope == "tree"
			then
				scope = "global"
				context = "global"
			end

			if action == "<Nop>" then
				section = "neutral"
				scope = "global"
				context = "global"
				desc = desc or "Намеренно отключено"
			end

			state.add({
				lhs = lhs,
				modes = normalize_modes(mode),
				desc = desc,
				scope = scope,
				context = context,
				section = section,
				plugin = current.plugin,
				inactive = current.inactive or false,
				action = action,
				source = source,
				line = line,
			})
		end,
		del = function() end,
	}

	vim.notify = function() end
	vim.cmd = function() end
	vim.schedule = function() end
	vim.defer_fn = function() end
	vim.ui = {
		open = function() end,
		input = function() end,
		select = function() end,
	}
	vim.hl = { on_yank = function() end }
	vim.health =
		{ ok = function() end, warn = function() end, error = function() end }
	vim.validate = function() end
	vim.inspect = function(v)
		return tostring(v)
	end
	vim.iter = make_stub("vim.iter")
	vim.json = make_stub("vim.json")
	vim.base64 = make_stub("vim.base64")

	return vim
end

local function load_module(path, env, cache, loaded)
	if loaded[path] then
		return cache[path]
	end
	local chunk, err = loadfile(path)
	if not chunk then
		error("cannot load " .. path .. ": " .. tostring(err))
	end
	setfenv(chunk, env)
	local ok, result = pcall(chunk)
	if not ok then
		error("error loading " .. path .. ":\n" .. tostring(result))
	end
	loaded[path] = true
	cache[path] = result
	return result
end

local function resolve_module(root, name)
	local rel = tostring(name):gsub("%.", "/")
	local path = root .. "/lua/" .. rel .. ".lua"
	if file_exists(path) then
		return path
	end
	path = root .. "/lua/" .. rel .. "/init.lua"
	if file_exists(path) then
		return path
	end
	return nil
end

local function make_require(root, env, cache, loaded, overrides, source_of)
	return function(name)
		if overrides[name] then
			local value = overrides[name]
			if type(value) == "function" then
				value = value(root)
			end
			return value
		end

		local path = resolve_module(root, name)
		if path then
			local value = load_module(path, env, cache, loaded)
			if type(value) == "table" then
				source_of[value] = relpath(root, path)
			end
			return value
		end

		return make_stub("require(" .. tostring(name) .. ")")
	end
end

local function normalize_specs(mod)
	if type(mod) ~= "table" then
		return {}
	end
	if type(mod[1]) == "string" then
		return { mod }
	end
	local out = {}
	for _, spec in ipairs(mod) do
		if type(spec) == "table" and type(spec[1]) == "string" then
			out[#out + 1] = spec
		end
	end
	return out
end

local function collect_keys(keys, ctx, source, state)
	if type(keys) ~= "table" then
		return 0
	end
	if type(keys[1]) == "string" then
		keys = { keys }
	end

	local count = 0
	for _, entry in ipairs(keys) do
		if type(entry) == "table" and type(entry[1]) == "string" then
			local lhs = entry[1]
			state.add({
				lhs = lhs,
				modes = normalize_modes(entry.mode or "n"),
				desc = entry.desc,
				scope = ctx.scope,
				context = ctx.context,
				section = ctx.section,
				plugin = ctx.plugin,
				inactive = ctx.inactive or false,
				action = type(entry[2]) == "string" and entry[2] or nil,
				source = source,
				line = line_for(state.root .. "/" .. source, lhs),
			})
			count = count + 1
		end
	end
	return count
end

local function make_tree_api(root, source)
	local api = {
		config = { mappings = { default_on_attach = function() end } },
		tree = {},
		node = {},
		fs = {},
		marks = {},
		live_filter = {},
	}
	local content = read_file(root .. "/" .. source) or ""
	for path in content:gmatch('path%s*=%s*"([^"]+)"') do
		local node = api
		local parts = {}
		for part in path:gmatch("[^.]+") do
			parts[#parts + 1] = part
		end
		for i, part in ipairs(parts) do
			if i == #parts then
				node[part] = function() end
			else
				node[part] = node[part] or {}
				node = node[part]
			end
		end
	end
	return api
end

function M.collect(opts)
	local root = opts.root
	local meta = opts.meta

	local state = {
		root = root,
		current = nil,
		client = nil,
		entries = {},
		inventory = { common = {}, v011 = {}, v012 = {} },
		groups = {},
		errors = {},
		sequence = 0,
	}

	state.seen = {}

	function state.add(entry)
		local key = table.concat(entry.modes or {}, ",")
			.. "|"
			.. tostring(entry.lhs)
			.. "|"
			.. tostring(entry.desc)
			.. "|"
			.. tostring(entry.scope)
			.. "|"
			.. tostring(entry.context)
			.. "|"
			.. tostring(entry.source)
			.. "|"
			.. tostring(entry.line)
		if state.seen[key] then
			return
		end
		state.seen[key] = true
		state.sequence = state.sequence + 1
		entry.order = state.sequence
		state.entries[#state.entries + 1] = entry
	end

	local cache, loaded, source_of = {}, {}, {}
	local overrides = {
		["nvim-tree.api"] = function(r)
			return make_tree_api(
				r,
				"lua/qfioofa/plugins/common/nvim-tree/keymaps.lua"
			)
		end,
	}
	local env = setmetatable({
		vim = make_vim(state),
		require = nil,
	}, { __index = _G })
	env._G = env
	env.require = make_require(root, env, cache, loaded, overrides, source_of)

	local function load_path(path)
		return load_module(root .. "/" .. path, env, cache, loaded)
	end

	local function with_context(ctx, fn)
		local previous = state.current
		state.current = ctx
		local ok, err = pcall(fn)
		state.current = previous
		if not ok then
			error(err)
		end
	end

	with_context(
		{ section = "editor", scope = "global", context = "global" },
		function()
			load_path("lua/qfioofa/options/keymaps.lua")
		end
	)

	with_context({
		section = "ruby",
		scope = "ruby",
		context = "ruby",
		plugin = "languages",
	}, function()
		local ruby = load_path("lua/qfioofa/languages/ruby.lua")
		ruby.start()
	end)

	with_context({
		section = "java",
		scope = "java",
		context = "java",
		plugin = "languages",
	}, function()
		local java = load_path("lua/qfioofa/languages/java.lua")
		java.start()
	end)

	local lsp_keymaps =
		load_path("lua/qfioofa/plugins/common/lspconfig/keymaps.lua")
	local clients = {
		{
			name = "ts_ls",
			server_capabilities = { inlayHintProvider = true },
			supports_method = function()
				return true
			end,
		},
		{
			name = "pyright",
			server_capabilities = { inlayHintProvider = true },
			supports_method = function()
				return true
			end,
		},
	}
	for _, client in ipairs(clients) do
		state.client = client
		with_context({
			section = "lsp",
			scope = "lsp",
			context = "lsp",
			plugin = "lspconfig",
		}, function()
			lsp_keymaps({ buf = 1, data = { client_id = 1 } })
		end)
	end
	state.client = nil

	with_context({
		section = "find",
		scope = "global",
		context = "global",
		plugin = "hover",
	}, function()
		local keymaps =
			load_path("lua/qfioofa/plugins/common/hover/keymaps.lua")
		keymaps()
	end)

	with_context({
		section = "ui",
		scope = "global",
		context = "global",
		plugin = "noice",
	}, function()
		local keymaps =
			load_path("lua/qfioofa/plugins/common/noice/keymaps.lua")
		keymaps()
	end)

	with_context({
		section = "inactive",
		scope = "global",
		context = "dap",
		plugin = "dap",
		inactive = true,
	}, function()
		local keymaps = load_path("lua/qfioofa/plugins/common/dap/keymaps.lua")
		keymaps()
	end)

	local tree = load_path("lua/qfioofa/plugins/common/nvim-tree/keymaps.lua")
	with_context({
		section = "tree",
		scope = "tree",
		context = "tree",
		plugin = "nvim-tree",
	}, function()
		tree.on_attach(1)
	end)
	with_context({
		section = "tree",
		scope = "global",
		context = "global",
		plugin = "nvim-tree",
	}, function()
		tree.global()
	end)

	do
		local snacks =
			load_path("lua/qfioofa/plugins/common/snacks/options.lua")
		local keys = snacks.dashboard
				and snacks.dashboard.preset
				and snacks.dashboard.preset.keys
			or {}
		for _, key in ipairs(keys) do
			state.add({
				lhs = key.key,
				modes = { "n" },
				desc = key.desc,
				scope = "dashboard",
				context = "dashboard",
				section = "dashboard",
				plugin = "snacks",
				action = key.action,
				source = "lua/qfioofa/plugins/common/snacks/options.lua",
				line = line_of(
					root .. "/lua/qfioofa/plugins/common/snacks/options.lua",
					'key = "' .. tostring(key.key) .. '"'
				),
			})
		end
	end

	do
		local cmp = load_path("lua/qfioofa/plugins/common/cmp/options.lua")
		local actual = {}
		for lhs in pairs(cmp.mapping or {}) do
			actual[lhs] = true
			local info = meta.internal.cmp[lhs]
			if not info then
				state.errors[#state.errors + 1] = "cmp: no docs metadata for "
					.. lhs
			else
				state.add({
					lhs = lhs,
					modes = info.modes,
					desc = info.desc,
					scope = "cmp",
					context = "cmp",
					section = "internal",
					plugin = "cmp",
					source = "lua/qfioofa/plugins/common/cmp/options.lua",
					line = line_of(
						root .. "/lua/qfioofa/plugins/common/cmp/options.lua",
						lhs
					),
				})
			end
		end
		for lhs in pairs(meta.internal.cmp) do
			if not actual[lhs] then
				state.errors[#state.errors + 1] = "cmp: stale docs metadata for "
					.. lhs
			end
		end
	end

	do
		local tabout =
			load_path("lua/qfioofa/plugins/common/tabout/options.lua")
		local actual = {
			[tabout.tabkey] = true,
			[tabout.backwards_tabkey] = true,
			[tabout.default_tab] = true,
			[tabout.default_shift_tab] = true,
		}
		for lhs in pairs(actual) do
			local info = meta.internal.tabout[lhs]
			if not info then
				state.errors[#state.errors + 1] = "tabout: no docs metadata for "
					.. tostring(lhs)
			else
				state.add({
					lhs = lhs,
					modes = info.modes,
					desc = info.desc,
					scope = "tabout",
					context = "tabout",
					section = "internal",
					plugin = "tabout",
					source = "lua/qfioofa/plugins/common/tabout/options.lua",
					line = line_of(
						root .. "/lua/qfioofa/plugins/common/tabout/options.lua",
						tostring(lhs)
					),
				})
			end
		end
		for lhs in pairs(meta.internal.tabout) do
			if not actual[lhs] then
				state.errors[#state.errors + 1] = "tabout: stale docs metadata for "
					.. lhs
			end
		end
	end

	do
		local telescope =
			load_path("lua/qfioofa/plugins/common/telescope/options.lua")
		local actual = {}
		for lhs in pairs(telescope.defaults.mappings.i or {}) do
			actual[lhs] = true
		end
		for lhs in pairs(telescope.pickers.buffers.mappings.i or {}) do
			actual[lhs] = true
		end
		for lhs in pairs(actual) do
			local info = meta.internal.telescope[lhs]
			if not info then
				state.errors[#state.errors + 1] = "telescope: no docs metadata for "
					.. lhs
			else
				state.add({
					lhs = lhs,
					modes = info.modes,
					desc = info.desc,
					scope = "telescope",
					context = "telescope",
					section = "internal",
					plugin = "telescope",
					source = "lua/qfioofa/plugins/common/telescope/options.lua",
					line = line_of(
						root
							.. "/lua/qfioofa/plugins/common/telescope/options.lua",
						lhs
					),
				})
			end
		end
		for lhs in pairs(meta.internal.telescope) do
			if not actual[lhs] then
				state.errors[#state.errors + 1] = "telescope: stale docs metadata for "
					.. lhs
			end
		end
	end

	do
		local dap = load_path("lua/qfioofa/plugins/common/dap/options.lua")
		for name, keys in pairs(dap.mappings or {}) do
			if type(keys) ~= "table" then
				keys = { keys }
			end
			for _, lhs in ipairs(keys) do
				state.add({
					lhs = lhs,
					modes = { "n" },
					desc = "dapui: " .. tostring(name),
					scope = "dapui",
					context = "dapui",
					section = "inactive",
					plugin = "dap",
					inactive = true,
					source = "lua/qfioofa/plugins/common/dap/options.lua",
					line = line_of(
						root .. "/lua/qfioofa/plugins/common/dap/options.lua",
						tostring(name) .. " ="
					),
				})
			end
		end
	end

	do
		local which_key =
			load_path("lua/qfioofa/plugins/common/which-key/options.lua")
		for _, item in ipairs(which_key.spec or {}) do
			if item.group and type(item[1]) == "string" then
				state.groups[#state.groups + 1] = {
					prefix = item[1],
					label = item.group,
					source = "lua/qfioofa/plugins/common/which-key/options.lua",
					line = line_of(
						root
							.. "/lua/qfioofa/plugins/common/which-key/options.lua",
						item[1]
					),
				}
			end
		end
	end

	for _, group in ipairs({ "common", "v011", "v012" }) do
		local base = root .. "/lua/qfioofa/plugins/" .. group
		for _, name in ipairs(list_dirs(base)) do
			local init_path = base .. "/" .. name .. "/init.lua"
			if file_exists(init_path) then
				local mod = load_module(init_path, env, cache, loaded)
				local specs = normalize_specs(mod)
				local inventory = state.inventory[group]
				inventory[name] = inventory[name] or { repos = {}, keys = 0 }
				local section = meta.plugin_section(name)
				for _, spec in ipairs(specs) do
					local repo = spec[1]
					if not vim.tbl_contains(inventory[name].repos, repo) then
						inventory[name].repos[#inventory[name].repos + 1] = repo
					end
					if type(spec.keys) == "table" then
						local source = source_of[spec.keys]
							or relpath(root, init_path)
						collect_keys(spec.keys, {
							section = section,
							scope = "global",
							context = "global",
							plugin = name,
							inactive = spec.enabled == false,
						}, source, state)
					end
				end
			end
		end
	end

	for _, entries in pairs(state.inventory) do
		for name, item in pairs(entries) do
			item.keys = 0
			for _, entry in ipairs(state.entries) do
				if entry.plugin == name and not entry.inactive then
					item.keys = item.keys + 1
				end
			end
		end
	end

	local section_order = {}
	for _, section in ipairs(meta.sections) do
		section_order[section.id] = section.order
	end
	table.sort(state.entries, function(a, b)
		local sa = section_order[a.section] or 999
		local sb = section_order[b.section] or 999
		if sa ~= sb then
			return sa < sb
		end
		if a.source ~= b.source then
			return a.source < b.source
		end
		local la = a.line or 0
		local lb = b.line or 0
		if la ~= lb then
			return la < lb
		end
		if a.lhs ~= b.lhs then
			return a.lhs < b.lhs
		end
		return table.concat(a.modes or {}, ",")
			< table.concat(b.modes or {}, ",")
	end)

	local groups_by_prefix = {}
	for _, group in ipairs(state.groups) do
		local prefix = group.prefix:match("^<leader>(.)$")
		if prefix then
			groups_by_prefix[prefix] = group.label
		end
	end

	local used_prefixes = {}
	for _, entry in ipairs(state.entries) do
		if not entry.inactive and entry.section ~= "internal" then
			local rest = entry.lhs:match("^<leader>(.+)$")
			if rest and #rest > 1 then
				used_prefixes[rest:sub(1, 1)] = true
			end
		end
	end
	local unknown_groups = {}
	for prefix in pairs(used_prefixes) do
		if not groups_by_prefix[prefix] then
			unknown_groups[#unknown_groups + 1] = prefix
		end
	end
	table.sort(unknown_groups)
	for _, prefix in ipairs(unknown_groups) do
		state.errors[#state.errors + 1] = "missing which-key group: <leader>"
			.. prefix
	end

	local overlaps = {}
	local by_key = {}
	for _, entry in ipairs(state.entries) do
		if
			not entry.inactive
			and entry.section ~= "neutral"
			and entry.section ~= "groups"
		then
			for _, mode in ipairs(entry.modes) do
				local key = mode .. "|" .. entry.lhs
				by_key[key] = by_key[key] or {}
				table.insert(by_key[key], entry)
			end
		end
	end

	local function context_set(entries)
		local set = {}
		for _, entry in ipairs(entries) do
			set[entry.context] = true
		end
		local out = vim.tbl_keys(set)
		table.sort(out)
		return out
	end

	for key, entries in pairs(by_key) do
		if #entries > 1 then
			local contexts = context_set(entries)
			local mode, lhs = key:match("^(.-)|(.*)$")
			local relevant = false
			if #contexts == 1 then
				relevant = true
			else
				local globals = 0
				for _, c in ipairs(contexts) do
					if c == "global" then
						globals = globals + 1
					end
				end
				if globals > 0 and #contexts == 2 then
					local other = contexts[1] == "global" and contexts[2]
						or contexts[1]
					relevant = other == "lsp"
						or other == "java"
						or other == "ruby"
				elseif
					contexts[1] == "lsp"
					and (contexts[2] == "java" or contexts[2] == "ruby")
				then
					relevant = true
				elseif contexts[1] == "cmp" and contexts[2] == "tabout" then
					relevant = true
				end
			end

			if relevant then
				local allow_key = mode
					.. "|"
					.. lhs
					.. "|"
					.. table.concat(contexts, ",")
				overlaps[#overlaps + 1] = {
					mode = mode,
					lhs = lhs,
					contexts = contexts,
					entries = entries,
					reason = meta.overlap_allowlist[allow_key],
				}
			end
		end
	end
	table.sort(overlaps, function(a, b)
		if a.lhs == b.lhs then
			return a.mode < b.mode
		end
		return a.lhs < b.lhs
	end)

	for _, overlap in ipairs(overlaps) do
		if not overlap.reason then
			state.errors[#state.errors + 1] = "undocumented overlap: "
				.. overlap.mode
				.. " "
				.. overlap.lhs
				.. " ("
				.. table.concat(overlap.contexts, ", ")
				.. ")"
		end
	end

	local active = 0
	for _, entry in ipairs(state.entries) do
		if
			not entry.inactive
			and entry.section ~= "neutral"
			and entry.section ~= "groups"
		then
			active = active + 1
		end
	end

	return {
		entries = state.entries,
		inventory = state.inventory,
		groups = state.groups,
		unknown_groups = unknown_groups,
		overlaps = overlaps,
		errors = state.errors,
		stats = {
			bindings = active,
			all_entries = #state.entries,
			sections = #meta.sections,
		},
	}
end

return M
