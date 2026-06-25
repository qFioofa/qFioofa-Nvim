local ok, jdtls = pcall(require, "jdtls")
if not ok then
	return
end

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

local java_bin = vim.g.jdtls_java
if not java_bin then
	java_bin = find_java(21)
	if java_bin then
		vim.g.jdtls_java = java_bin
	end
end
if not java_bin then
	vim.notify(
		"jdtls: no JDK 21+ found. Set $JAVA_HOME (or $JDTLS_JAVA_HOME) to a JDK 21+.",
		vim.log.levels.ERROR
	)
	return
end
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
		vim.fn.glob(mason .. "/packages/java-test/extension/server/*.jar", true),
		"\n",
		{ trimempty = true }
	)
)

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

local config = {
	cmd = cmd,
	root_dir = require("jdtls.setup").find_root({
		".git",
		"mvnw",
		"gradlew",
		"pom.xml",
		"build.gradle",
		"build.gradle.kts",
		"settings.gradle",
	}),

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

	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	flags = { allow_incremental_sync = true },
	init_options = {
		bundles = bundles,
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
	},
}

config.on_attach = function(_, _)
	jdtls.setup_dap({ hotcodereplace = "auto" })
	require("jdtls.dap").setup_dap_main_class_configs()
end

jdtls.start_or_attach(config)

local opts = { buffer = true, silent = true }
vim.keymap.set(
	"n",
	"<leader>co",
	jdtls.organize_imports,
	vim.tbl_extend("force", opts, { desc = "Java: organize imports" })
)
vim.keymap.set(
	"n",
	"<leader>tc",
	jdtls.test_class,
	vim.tbl_extend("force", opts, { desc = "Java: test class" })
)
vim.keymap.set(
	"n",
	"<leader>tm",
	jdtls.test_nearest_method,
	vim.tbl_extend("force", opts, { desc = "Java: test nearest method" })
)
