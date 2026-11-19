local M = {}

local function escape_md(value)
	value = tostring(value or "")
	value = value:gsub("|", "\\|")
	value = value:gsub("\n", " ")
	return value
end

local function code(value)
	return "`" .. tostring(value) .. "`"
end

local function mode_text(modes)
	return table.concat(modes or {}, ", ")
end

local function source_link(entry)
	local text = entry.source
	if entry.line then
		text = text .. ":" .. entry.line
	end
	return "["
		.. text
		.. "]("
		.. entry.source
		.. (entry.line and ("#L" .. entry.line) or "")
		.. ")"
end

local function scope_text(scope)
	local labels = {
		global = "глобально",
		lsp = "buffer: LSP",
		java = "buffer: Java",
		ruby = "buffer: Ruby",
		tree = "nvim-tree",
		buffers = "neo-tree",
		dashboard = "dashboard",
		cmp = "cmp",
		tabout = "tabout",
		telescope = "Telescope prompt",
		dapui = "dapui",
	}
	return labels[scope] or scope
end

local function list_dir(path)
	local out = {}
	local ok, iter, state = pcall(vim.fs.dir, path)
	if not ok then
		return out
	end
	for name, typ in iter, state do
		if name:sub(1, 1) ~= "." then
			out[#out + 1] = { name = name, type = typ }
		end
	end
	table.sort(out, function(a, b)
		return a.name < b.name
	end)
	return out
end

local function count_files(path)
	local count = 0
	for _, item in ipairs(list_dir(path)) do
		if item.type == "file" then
			count = count + 1
		elseif item.type == "directory" then
			count = count + count_files(path .. "/" .. item.name)
		end
	end
	return count
end

local function count_dirs(path)
	local count = 0
	for _, item in ipairs(list_dir(path)) do
		if item.type == "directory" then
			count = count + 1
		end
	end
	return count
end

local function plugin_inventory(data)
	local groups = { "common", "v011", "v012" }
	local lines = {}
	for _, group in ipairs(groups) do
		local entries = data.inventory[group] or {}
		local names = vim.tbl_keys(entries)
		table.sort(names)
		lines[#lines + 1] = "### " .. group
		lines[#lines + 1] = ""
		lines[#lines + 1] = "| Module | Repository | Custom keys |"
		lines[#lines + 1] = "| --- | --- | ---: |"
		for _, name in ipairs(names) do
			local item = entries[name]
			local repos = {}
			for _, repo in ipairs(item.repos) do
				repos[#repos + 1] = code(repo)
			end
			local repo_text = #repos > 0 and table.concat(repos, "<br>")
				or "—"
			lines[#lines + 1] = ("| %s | %s | %d |"):format(
				code(name),
				repo_text,
				item.keys
			)
		end
		lines[#lines + 1] = ""
	end
	return table.concat(lines, "\n")
end

local function project_table(root)
	local rows = {
		{
			"lua/qfioofa/options",
			"global options, keymaps, commands, autocmds",
		},
		{ "lua/qfioofa/pluginManager", "profile selection and backends" },
		{ "lua/qfioofa/plugins/common", "plugins shared by both profiles" },
		{ "lua/qfioofa/plugins/v011", "lazy profile only (<0.12)" },
		{ "lua/qfioofa/plugins/v012", "pack profile only (>=0.12)" },
		{ "lua/qfioofa/languages", "FileType language modules" },
		{ "lua/qfioofa/java", ":JNew command and Java templates" },
		{ "scripts", "deploy/cleanup and docs generator" },
		{ "scripts/docs", "collect/render AGENTS and BINDS" },
		{ "snippets", "LuaSnip snippets" },
		{ ".github/workflows", "CI checks" },
	}
	local lines = { "| Path | Files | Purpose |", "| --- | ---: | --- |" }
	for _, row in ipairs(rows) do
		local path = root .. "/" .. row[1]
		local count = count_files(path)
		if row[1] == "lua/qfioofa/plugins/common" then
			count = count .. " / " .. count_dirs(path) .. " plugin dirs"
		end
		lines[#lines + 1] = ("| %s | %s | %s |"):format(
			code(row[1]),
			count,
			row[2]
		)
	end
	return table.concat(lines, "\n")
end

local function render_binds(data, meta)
	local lines = {}
	local function add(line)
		lines[#lines + 1] = line or ""
	end

	add("# BINDS.md")
	add("")
	add(
		"> Карта кастомных клавиатурных сокращений этого Neovim-конфига."
	)
	add(">")
	add(
		"> Файл генерируется командой `make docs`; не редактируйте его вручную."
	)
	add(
		"> Источник данных — Lua-файлы конфига. Проверка синхронизации: `make check-docs`."
	)
	add("")
	add("## Легенда")
	add("")
	add('- `<leader>` — пробел (`vim.g.mapleader = " "`).')
	add(
		"- Режимы: `n` normal, `i` insert, `v` visual/select, `x` visual block, `o` operator-pending, `t` terminal, `c` command-line, `s` select."
	)
	add(
		"- Область: `глобально`, `buffer: LSP`, `buffer: Java`, `buffer: Ruby`, `nvim-tree`, `neo-tree`, `dashboard`, `cmp`, `tabout`, `Telescope prompt`, `dapui`."
	)
	add(
		"- В таблицах указаны только маппинги, которые заданы или переопределены этим конфигом; встроенные default-маппинги плагинов не перечислены."
	)
	add("")
	add("## Сводка")
	add("")
	add(
		"- Кастомных активных маппингов: **"
			.. data.stats.bindings
			.. "**"
	)
	add(
		"- Всего записей, включая неактивные и нейтрализованные: **"
			.. data.stats.all_entries
			.. "**"
	)
	add("- Секций: **" .. data.stats.sections .. "**")
	add(
		"- Межпрофильных исходников: `common`, `v011`, `v012`"
	)
	add("")

	for _, section in ipairs(meta.sections) do
		local entries = {}
		for _, entry in ipairs(data.entries) do
			if entry.section == section.id then
				entries[#entries + 1] = entry
			end
		end
		if #entries > 0 then
			add("## " .. section.title)
			add("")
			if section.id == "neutral" then
				add(
					"Эти клавиши намеренно отключены, чтобы не ждать `timeoutlen` или не конфликтовать с другим префиксом."
				)
				add("")
			elseif section.id == "inactive" then
				add(
					"Файлы/опции существуют в репозитории, но не подключены к активному конфигу. Раздел нужен, чтобы мёртвый код не терялся из виду."
				)
				add("")
			end
			add(
				"| Клавиши | Режим | Описание | Область | Источник |"
			)
			add("| --- | --- | --- | --- | --- |")
			for _, entry in ipairs(entries) do
				local desc = escape_md(entry.desc or "—")
				if entry.inactive then
					desc = desc .. " *(неактивно)*"
				end
				add(
					("| %s | %s | %s | %s | %s |"):format(
						code(entry.lhs),
						mode_text(entry.modes),
						desc,
						scope_text(entry.scope),
						source_link(entry)
					)
				)
			end
			add("")
		end
	end

	add("## which-key: группы префиксов")
	add("")
	add("| Префикс | Группа | Источник |")
	add("| --- | --- | --- |")
	for _, group in ipairs(data.groups) do
		add(
			("| %s | %s | %s |"):format(
				code(group.prefix),
				escape_md(group.label),
				source_link(group)
			)
		)
	end
	add("")

	add("## Пересечения клавиш")
	add("")
	if #data.overlaps == 0 then
		add("Не обнаружено.")
	else
		add(
			"| Клавиши | Режим | Контексты | Что перекрывается | Статус |"
		)
		add("| --- | --- | --- | --- | --- |")
		for _, overlap in ipairs(data.overlaps) do
			local items = {}
			for _, entry in ipairs(overlap.entries) do
				items[#items + 1] = ("%s — %s"):format(
					escape_md(entry.desc or "—"),
					source_link(entry)
				)
			end
			local status = overlap.reason
					and ("известно: " .. escape_md(overlap.reason))
				or "**ТРЕБУЕТ РЕШЕНИЯ**"
			add(
				("| %s | %s | %s | %s | %s |"):format(
					code(overlap.lhs),
					overlap.mode,
					table.concat(overlap.contexts, ", "),
					table.concat(items, "<br>"),
					status
				)
			)
		end
	end
	add("")

	if #data.unknown_groups > 0 then
		add("## Нет группы в which-key")
		add("")
		add(
			"Для этих `<leader>`-префиксов есть маппинги, но нет записи `group` в `which-key/options.lua`:"
		)
		add("")
		for _, prefix in ipairs(data.unknown_groups) do
			add("- `<leader>" .. prefix .. "`")
		end
		add("")
	end

	add("## Как обновлять")
	add("")
	add("1. Измените Lua-конфиг.")
	add("2. Запустите `make docs`.")
	add("3. Проверьте diff в `BINDS.md` и `AGENTS.md`.")
	add(
		"4. Запустите `make check-docs` (в CI это делается автоматически)."
	)
	add("")
	add(
		"Если маппинг задан через option-таблицу плагина (cmp, tabout, Telescope prompt, dapui), обновите `scripts/docs/meta.lua`: генератор специально падает, если описание или набор клавиш там устарели."
	)
	add("")

	return table.concat(lines, "\n")
end

local function render_agents(data, root)
	local known_issues = {
		"- `<leader>rn` is buffer-local LSP rename in any LSP buffer, but Ruby also maps it to `rails test <file>:<line>`. Whichever attaches last wins; resolve the binding before relying on it.",
		"- `<leader>th` is the global toggleterm horizontal split, but LSP buffers shadow it with the inlay-hints toggle. The BINDS overlap table records both.",
		"- `<Tab>` and `<S-Tab>` are mapped by both cmp and tabout in insert mode; the last-loaded mapping wins. Resolve or document the intended precedence.",
		"- `<leader>tl`, `<leader>to`, and `<leader>te` are registered from `LspAttach` without `buffer`, so they become global after the first LSP attach even though their section is LSP.",
		'- `lua/qfioofa/plugins/common/dap/keymaps.lua` and `dap/options.lua` are not wired into the active DAP spec (and `dapui` is not installed). They are listed under "inactive" in BINDS.',
		"- `lua/qfioofa/java.lua` is a legacy duplicate of the build helpers in `lua/qfioofa/languages/java.lua`; nothing requires it.",
		"- README mentions Neovim 0.11.5; the flake pins 0.11.7 for the lazy profile and 0.12.x for the pack profile. Treat the flake as the source of truth.",
		"- `nvim-pack-lock.json` and `lazy-lock.json` are gitignored because they are written at runtime; never hand-edit or commit them.",
		"- On NixOS, Mason servers need the FHS wrapper in `flake.nix`; Java needs JDK 21+ (`JAVA_HOME` or `JDTLS_JAVA_HOME`).",
		"- Ruby LSP falls back to `BUNDLE_GEMFILE=/dev/null` when the project Ruby version does not match the running interpreter.",
		"- `vim.tbl_flatten` is shimmed in `options/options.lua` for plugins that still call the removed API.",
		"- Avante v0.5.0 requires Neovim 0.12+ and lives in `plugins/v012`; the lazy profile (0.11 and lazy on 0.12) does not load it.",
		"- Avante plan mode is a prompt + tool-filter layer, not a separate read-only agent with its own model.",
		"- MCPHub permissions are per tool call and match shell commands by pattern; complex shell wrappers can bypass the intended rule.",
		"- `mcp/servers.json` is the Neovim-side MCP list; it must be kept in sync with the opencode MCP config.",
		"- First install builds Avante from source and bundles `mcp-hub`, so it needs `node`, `npm`, `cargo`, `make` and network access.",
	}
	if #data.unknown_groups > 0 then
		known_issues[#known_issues + 1] = "- Missing which-key group definitions for: "
			.. table.concat(data.unknown_groups, ", ")
			.. "."
	end

	local template = [==[
# AGENTS.md

This file is for coding agents working on this repository. Global agent rules live
in `~/.config/opencode/AGENTS.md`; this file adds project-specific facts and
constraints. `README.md` is for end users and installation; do not duplicate it.

> The "Repository map", "Plugin inventory", and "Current stats" blocks are
> generated by `make docs`. Hand-written rules live in `scripts/docs/render.lua`.
> Run `make docs` after any config change; `make check-docs` must pass before a PR.

## 1. Purpose

This is a personal Neovim configuration that supports two plugin backends:

- **lazy profile** (`<0.12`): `lazy.nvim`, imports `plugins/common` and `plugins/v011`.
- **pack profile** (`>=0.12`): native `vim.pack`, scans `plugins/common` and `plugins/v012`.

Select a backend with `NVIM_PROFILE=lazy|pack` or `vim.g.qfioofa_profile`.
The default is `pack` on Neovim 0.12+ and `lazy` otherwise.

## 2. Repository map

<!-- BEGIN GENERATED: PROJECT MAP -->
__PROJECT_TABLE__
<!-- END GENERATED: PROJECT MAP -->

Fixed top-level layout:

```text
.
├── init.lua                 -- vim.loader.enable(); require("qfioofa.init")()
├── flake.nix / flake.lock   -- Nix packages and Home Manager module
├── lua/qfioofa/             -- all config modules
├── mcp/servers.json         -- MCPHub servers (Avante native tools)
├── snippets/                -- LuaSnip snippets
├── scripts/                 -- deploy/cleanup + docs generator
├── Makefile                 -- fmt, lint, docs, check targets
├── AGENTS.md                -- this file
├── BINDS.md                 -- generated keymap reference
└── README.md                -- user-facing install/usage docs
```

### Plugin inventory

<!-- BEGIN GENERATED: PLUGIN INVENTORY -->
__PLUGIN_INVENTORY__
<!-- END GENERATED: PLUGIN INVENTORY -->

### Current stats

<!-- BEGIN GENERATED: STATS -->
__STATS__
<!-- END GENERATED: STATS -->

## 3. Boot flow

1. `init.lua` enables the Lua loader and calls `require("qfioofa.init")()`.
2. `lua/qfioofa/init.lua` loads, in order: `options`, `pluginManager`, `languages`.
3. `options/init.lua` loads `options`, `keymaps`, `commands`, `autocommand`.
4. `pluginManager/init.lua` reads the profile and calls the matching backend.
5. `languages/init.lua` registers a `FileType` autocmd that calls each language
   module's `start()` function.

`utils.saveInit(path, root)` is the loader helper. `utils.roots` owns module
prefixes; use it instead of hard-coded `"qfioofa."` strings in new code.

## 4. Directory conventions

- `lua/qfioofa/options/` — global editor options, keymaps, user commands, autocmds.
- `lua/qfioofa/pluginManager/` — profile selection and backends. Do not require
  `lazy.nvim` outside `backends/lazy.lua`.
- `lua/qfioofa/plugins/common/<plugin>/` — plugin specs shared by both profiles.
  A plugin directory is discovered automatically; there is no central plugin list.
- `lua/qfioofa/plugins/v011/<plugin>/` and `v012/<plugin>/` — profile-specific
  specs or overrides only.
- `lua/qfioofa/languages/` — language-specific setup and buffer-local keymaps.
- `lua/qfioofa/java/newfile.lua` — the `:JNew` command and Java templates.
- `lua/qfioofa/plugins/v012/avante/` — Avante agent config, tools, modes and
  prompts. Avante v0.5.0 requires Neovim 0.12+, so it is pack-only.
- `lua/qfioofa/plugins/v012/mcphub/` — MCPHub client, permissions and the
  built-in `neovim` MCP server used by Avante.
- `mcp/servers.json` — MCP server definitions; keep it in sync with
  `~/.config/opencode/opencode.jsonc`.
- `snippets/` — own LuaSnip snippets, loaded with priority over friendly-snippets.

Each plugin directory normally contains:

```text
init.lua      -- returns one spec or an array of specs
options.lua   -- plain table passed to setup()/opts (optional)
keymaps.lua   -- keys spec table or a function that registers maps (optional)
```

Keep options and keymaps out of `init.lua` when they grow beyond a few lines.

## 5. Plugin spec contract

A spec is a lazy.nvim-compatible table:

```lua
return {
    "owner/repo",
    event = "VeryLazy",          -- lazy only; ignored by pack
    cmd = "SomeCommand",         -- lazy only; ignored by pack
    ft = "java",                 -- lazy only; ignored by pack
    dependencies = { "owner/other" },
    build = ":TSUpdate",
    opts = require("qfioofa.plugins.common.example.options"),
    keys = require("qfioofa.plugins.common.example.keymaps"),
    config = function() ... end,
}
```

Critical: the **pack backend does not implement lazy-loading semantics** for
`event`, `cmd`, `ft`, or `lazy`. It registers `keys` itself, installs all specs,
and runs `init`/`config` during startup. Do not make correctness depend on a
plugin loading later. Optional plugin dependencies must tolerate `pcall(require,
...)` failure.

`build` strings are supported by both backends. `keys` is the only lazy-loading
mechanism that works consistently: keep user-facing mappings there (or in a
plugin's `keymaps.lua`) and always include `desc`.

## 6. Keymap contract

- Every custom mapping needs a `desc`. which-key and `:map` use it.
- Global editor mappings belong in `options/keymaps.lua`.
- Language and LSP mappings are **buffer-local** (`buffer = bufnr` or `buffer = true`).
- Add a new `<leader>` prefix both to the mapping and to
  `plugins/common/which-key/options.lua` as a `group`.
- Do not introduce two mappings with the same `(mode, lhs)` in the same scope.
  Global vs buffer-local shadowing and buffer-vs-buffer conflicts must be recorded
  in `BINDS.md` (the generator fails on undocumented overlaps).
- Mappings for plugin option tables (cmp, tabout, Telescope prompt, dapui) need
  an entry in `scripts/docs/meta.lua`; the generator validates both directions.
- After any keymap change: `make docs && make check-docs`.

## 7. Recipes

### Add a plugin

1. Create `lua/qfioofa/plugins/common/<name>/init.lua`.
2. Put non-trivial options in `options.lua`, keymaps in `keymaps.lua`.
3. Verify both profiles: `NVIM_PROFILE=lazy nvim` and `NVIM_PROFILE=pack nvim`.
4. Add the plugin to a BINDS section in `scripts/docs/meta.lua` if it has custom
   mappings; otherwise it falls into "other".
5. Run `make docs`.

### Add a keymap

1. Put it in the right scope (global editor vs language/LSP buffer).
2. Add `desc`.
3. Add the which-key group if you introduced a new prefix.
4. Run `make docs`; fix any overlap reported by `make check-docs`.

### Add a language

1. Create `lua/qfioofa/languages/<ft>.lua` with `M.start()`.
2. Register it in `lua/qfioofa/languages/init.lua`.
3. Keep keymaps buffer-local and add them to BINDS via the generator.

### Add an option, autocmd, or command

- Global options: `options/options.lua`.
- Autocmds: `options/autocommand.lua`.
- User commands: `options/commands.lua` or the owning module's `setup()`.

## 8. Commands

```bash
make docs          # regenerate AGENTS.md and BINDS.md
make check-docs    # fail if docs are stale or overlaps/metadata are wrong
make self-test     # generator assertions (expected bindings, desc, determinism)
make fmt           # stylua lua scripts
make fmt-check     # stylua --check lua scripts
make lint          # luacheck lua scripts
make check         # lint + check-docs

NVIM_PROFILE=lazy nvim
NVIM_PROFILE=pack nvim
nix run .#nvim-0_11
nix run .#nvim-0_12

bash scripts/deploy.sh -b
bash scripts/cleanup.sh
```

`stylua` and `luacheck` are not guaranteed to be on `PATH`. With Nix:

```bash
nix shell nixpkgs#stylua 'nixpkgs#luaPackages.luacheck' -c make check
```

On Windows, run the generator directly:

```powershell
nvim --clean -l scripts/gen_docs.lua --write
```

User commands owned by this config:

- `:JNew` — create a Java file with package, imports and a starter type.
- `:AgentMode plan|build` — switch the Avante agent between read-only planning
  and editing; plan mode also blocks MCP mutations.
- `:PackUpdate`, `:PackList`, `:PackDel` — native `vim.pack` management (pack profile).
- `:MasonToolsInstall` — install/update Mason tools when the LSP bootstrap asks for it.

## 9. Style and safety

- Lua with tabs, `stylua` config in `stylua.toml` (80 columns, sorted requires).
- `luacheck` uses `std = "max"` and global `vim`.
- Prefer `pcall(require, ...)` for optional plugins; never let a missing optional
  plugin abort startup.
- Do not edit `lazy-lock.json`, `nvim-pack-lock.json`, runtime data, or `result/`.
- Do not add secrets, tokens, or machine-specific absolute paths.
- Keep Windows compatibility: use `vim.fn.stdpath`, `vim.fs`, and the existing
  PowerShell branch in `options/options.lua`.
- Do not commit or push unless the user explicitly asks.

## 10. Known issues and caveats

__KNOWN_ISSUES__

## 11. Documentation sync contract

- The Lua config is the source of truth; `AGENTS.md` and `BINDS.md` are generated
  artifacts (except the hand-written prose templates in `scripts/docs/render.lua`).
- Never hand-edit generated blocks. Change the config or `scripts/docs/meta.lua`,
  then run `make docs`.
- `make check-docs` regenerates into a temporary file and diffs it against the
  repository. CI runs the same command and fails on drift.
- Unknown overlaps, missing `desc`, stale internal metadata, and missing
  which-key groups are hard failures.
- If a new plugin/keymap does not fit an existing section, add the mapping to
  `scripts/docs/meta.lua` instead of accepting a misleading BINDS entry.

## 12. References

- `README.md` — installation, wipe, Nix, useful commands.
- `BINDS.md` — complete generated keymap reference.
- `flake.nix` — pinned Neovim builds, FHS wrapper, Home Manager module.
- `scripts/docs/meta.lua` — section order and curated internal descriptions.
]==]

	local stats = {
		"- Active custom mappings: **" .. data.stats.bindings .. "**",
		"- All captured entries (including inactive/neutral): **"
			.. data.stats.all_entries
			.. "**",
		"- Plugin modules: `common` = "
			.. #vim.tbl_keys(data.inventory.common)
			.. ", `v011` = "
			.. #vim.tbl_keys(data.inventory.v011)
			.. ", `v012` = "
			.. #vim.tbl_keys(data.inventory.v012),
		"- Language modules: " .. table.concat(
			(function()
				local names = {}
				for _, item in
					ipairs(list_dir(root .. "/lua/qfioofa/languages"))
				do
					if
						item.name:match("%.lua$")
						and item.name ~= "init.lua"
					then
						names[#names + 1] = code(item.name:gsub("%.lua$", ""))
					end
				end
				return names
			end)(),
			", "
		),
	}

	local text = template
	text = text:gsub("__PROJECT_TABLE__", function()
		return project_table(root)
	end)
	text = text:gsub("__PLUGIN_INVENTORY__", function()
		return plugin_inventory(data)
	end)
	text = text:gsub("__STATS__", function()
		return table.concat(stats, "\n")
	end)
	text = text:gsub("__KNOWN_ISSUES__", function()
		return table.concat(known_issues, "\n")
	end)
	return text
end

function M.render(data, meta, root)
	return {
		agents = render_agents(data, root),
		binds = render_binds(data, meta),
	}
end

return M
