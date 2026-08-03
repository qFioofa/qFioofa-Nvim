local M = {}

local ROOT_MARKERS = {
	".git",
	"mvnw",
	"gradlew",
	"pom.xml",
	"build.gradle",
	"build.gradle.kts",
	"settings.gradle",
}
M.root_markers = ROOT_MARKERS

local function java_major(bin)
	local out = vim.fn.system({ bin, "-version" })
	local v = out:match('version%s+"([^"]+)"')
	if not v then
		return 0
	end
	return tonumber(v:match("^1%.(%d+)") or v:match("^(%d+)")) or 0
end

local function find_java(min)
	local list, seen = {}, {}
	local function add(p)
		if p and p ~= "" and not seen[p] then
			seen[p] = true
			list[#list + 1] = p
		end
	end
	add(vim.env.JDTLS_JAVA_HOME and vim.env.JDTLS_JAVA_HOME .. "/bin/java")
	add(vim.env.JAVA_HOME and vim.env.JAVA_HOME .. "/bin/java")
	add("/run/current-system/sw/bin/java")
	add(vim.fn.exepath("java"))
	for _, g in
		ipairs(vim.fn.glob("/nix/store/*-openjdk-21*/bin/java", true, true))
	do
		add(g)
	end
	for _, g in ipairs(vim.fn.glob("/usr/lib/jvm/*/bin/java", true, true)) do
		add(g)
	end
	for _, c in ipairs(list) do
		if vim.fn.executable(c) == 1 and java_major(c) >= min then
			return c
		end
	end
end

function M.bundles(mason)
	local bundles = {}
	vim.list_extend(
		bundles,
		vim.split(
			vim.fn.glob(
				mason
					.. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
				true
			),
			"\n",
			{ trimempty = true }
		)
	)
	vim.list_extend(
		bundles,
		vim.split(
			vim.fn.glob(
				mason .. "/packages/java-test/extension/server/*.jar",
				true
			),
			"\n",
			{ trimempty = true }
		)
	)
	return bundles
end

function M.build()
	local java_bin = vim.g.jdtls_java or find_java(21)
	if not java_bin then
		vim.notify(
			"jdtls: no JDK 21+ found. Set $JAVA_HOME (or $JDTLS_JAVA_HOME) to a JDK 21+.",
			vim.log.levels.ERROR
		)
		return
	end
	vim.g.jdtls_java = java_bin
	local java_home = vim.fn.fnamemodify(java_bin, ":h:h")

	local mason = vim.fn.stdpath("data") .. "/mason"
	local jdtls_pkg = mason .. "/packages/jdtls"
	if vim.fn.isdirectory(jdtls_pkg) == 0 then
		vim.notify(
			"jdtls not installed yet — run :MasonToolsInstall, then reopen.",
			vim.log.levels.WARN
		)
		return
	end

	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local workspace_dir = vim.fn.stdpath("cache")
		.. "/jdtls-workspace/"
		.. project_name

	local system_os = "linux"
	if vim.fn.has("mac") == 1 then
		system_os = "mac"
	elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
		system_os = "win"
	end

	local launcher =
		vim.fn.glob(jdtls_pkg .. "/plugins/org.eclipse.equinox.launcher_*.jar")
	local lombok = jdtls_pkg .. "/lombok.jar"

	local cmd = {
		java_bin,
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx4g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		launcher,
		"-configuration",
		jdtls_pkg .. "/config_" .. system_os,
		"-data",
		workspace_dir,
	}
	if vim.fn.filereadable(lombok) == 1 then
		table.insert(cmd, 8, "-javaagent:" .. lombok)
	end

	return {
		java_bin = java_bin,
		mason = mason,
		cmd = cmd,
		root_dir = vim.fs.root(0, ROOT_MARKERS),
		settings = {
			java = {
				home = java_home,
				eclipse = { downloadSources = true },
				maven = { downloadSources = true },
				references = { includeDecompiledSources = true },
				implementationsCodeLens = { enabled = false },
				referencesCodeLens = { enabled = false },
				signatureHelp = { enabled = true },
				format = { enabled = true },
				completion = {
					importOrder = { "java", "javax", "com", "org" },
				},
				sources = {
					organizeImports = {
						starThreshold = 9999,
						staticStarThreshold = 9999,
					},
				},
			},
		},
	}
end

local function map(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, { buffer = true, silent = true, desc = desc })
end

-- Fallback-only helpers (used when nvim-jdtls isn't installed).
local function setup_native_dap()
	local ok, dap = pcall(require, "dap")
	if not ok or dap.adapters.java then
		return
	end
	dap.adapters.java = function(callback)
		vim.lsp.buf_request(0, "workspace/executeCommand", {
			command = "vscode.java.startDebugSession",
		}, function(err, port)
			if err then
				vim.notify("jdtls: " .. err.message, vim.log.levels.ERROR)
				return
			end
			callback({ type = "server", host = "127.0.0.1", port = port })
		end)
	end
	if not dap.configurations.java then
		dap.configurations.java = {
			{
				type = "java",
				request = "attach",
				name = "Debug (Attach) - Current",
				hostName = "localhost",
				port = 5005,
			},
			{
				type = "java",
				request = "launch",
				name = "Debug (Launch) - Current File",
				mainClass = "${file}",
			},
		}
	end
end

local function class_lnum()
	for i = 1, vim.api.nvim_buf_line_count(0) do
		local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1] or ""
		if line:match("^%s*[%w_%s<>?,%.]*%s+class%s+[%w_]+") then
			return i
		end
	end
end

local function run_lens_at(lnum)
	if lnum then
		vim.api.nvim_win_set_cursor(0, { lnum, 0 })
	end
	vim.lsp.codelens.run()
end

function M.start()
	local cfg = M.build()
	if not cfg then
		return
	end

	local has_jdtls, jdtls = pcall(require, "jdtls")
	if has_jdtls then
		-- Full nvim-jdtls path (lazy profile and, since v012, the pack profile).
		-- Gives test class/method, DAP, extended symbols and jdtls:// sources.
		jdtls.start_or_attach(vim.tbl_extend("force", {
			cmd = cfg.cmd,
			root_dir = cfg.root_dir,
			settings = cfg.settings,
			capabilities = (function()
				local has_cmp, cmp = pcall(require, "cmp_nvim_lsp")
				return has_cmp and cmp.default_capabilities()
					or vim.lsp.protocol.make_client_capabilities()
			end)(),
			init_options = {
				bundles = M.bundles(cfg.mason),
				extendedClientCapabilities = jdtls.extendedClientCapabilities,
			},
		}, {
			on_attach = function()
				pcall(jdtls.setup_dap, { hotcodereplace = "auto" })
				pcall(require("jdtls.dap").setup_dap_main_class_configs)
			end,
			-- jdtls echoes its "0% Starting Java Language Server" / "Ready" /
			-- "ServiceReady" status lines via `:echo`, which noice then renders
			-- as notification popups. The status is redundant (lualine/navic
			-- show the important state), so swallow it. The ServiceReady
			-- source-path wiring still runs inside nvim-jdtls itself.
			handlers = {
				["language/status"] = function() end,
			},
		}))

		map("<leader>jc", jdtls.test_class, "Java: test class")
		map("<leader>jm", jdtls.test_nearest_method, "Java: test nearest method")
		map("<leader>jt", jdtls.pick_test, "Java: pick test")
		map("<leader>jo", jdtls.organize_imports, "Java: organize imports")
		map("<leader>jp", jdtls.update_project_config, "Java: reload project config")
		map("<leader>jb", jdtls.compile, "Java: build workspace")
		map("<leader>js", jdtls.extended_symbols, "Java: extended symbols (incl. inherited)")
		map("<leader>jS", jdtls.super_implementation, "Java: go to super implementation")
		return
	end

	-- Fallback: nvim-jdtls not installed. Bundle the debug/test extensions so
	-- the java-test code lens ("run tests | debug tests") and DAP still work.
	vim.lsp.start({
		name = "jdtls",
		cmd = cfg.cmd,
		root_dir = cfg.root_dir,
		settings = cfg.settings,
		capabilities = vim.lsp.protocol.make_client_capabilities(),
		init_options = { bundles = M.bundles(cfg.mason) },
	})
	setup_native_dap()

	map("<leader>jo", function()
		vim.lsp.buf.code_action({
			context = { only = { "source.organizeImports" } },
			apply = true,
		})
	end, "Java: organize imports")
	map("<leader>jc", function()
		run_lens_at(class_lnum())
	end, "Java: test class (code lens)")
	map("<leader>jm", function()
		run_lens_at(vim.api.nvim_win_get_cursor(0)[1])
	end, "Java: test nearest method (code lens)")
end

return M
