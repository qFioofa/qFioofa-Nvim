-- Documentation metadata for scripts/gen_docs.lua.
--
-- This file is the only hand-maintained part of the generated docs pipeline:
-- section order, plugin -> section assignments, and descriptions for mappings
-- that live inside plugin option tables (cmp/tabout/telescope/dapui) where the
-- source does not carry a `desc`.

local M = {}

M.sections = {
	{
		id = "editor",
		title = "Редактор, файлы, буферы, окна",
		order = 10,
	},
	{ id = "find", title = "Поиск и навигация", order = 20 },
	{ id = "git", title = "Git и история", order = 30 },
	{ id = "lsp", title = "LSP и код", order = 40 },
	{ id = "debug", title = "Отладка (DAP)", order = 50 },
	{ id = "java", title = "Java (buffer-local)", order = 60 },
	{ id = "ruby", title = "Ruby / Rails (buffer-local)", order = 70 },
	{
		id = "tree",
		title = "Дерево файлов (nvim-tree)",
		order = 80,
	},
	{ id = "dashboard", title = "Dashboard (snacks)", order = 85 },
	{ id = "terminal", title = "Терминал (toggleterm)", order = 90 },
	{ id = "ui", title = "UI и уведомления", order = 100 },
	{ id = "session", title = "Сессии и auto-save", order = 110 },
	{ id = "misc", title = "Markdown, undo и прочее", order = 120 },
	{
		id = "internal",
		title = "Внутренние маппинги плагинов",
		order = 130,
	},
	{
		id = "groups",
		title = "which-key: группы префиксов",
		order = 140,
	},
	{
		id = "neutral",
		title = "Намеренно нейтрализованные клавиши",
		order = 150,
	},
	{
		id = "inactive",
		title = "Неактивные / мёртвые маппинги",
		order = 160,
	},
	{ id = "other", title = "Прочие плагины", order = 170 },
}

M.plugin_sections = {
	["auto-save"] = "session",
	["auto-session"] = "session",
	["cmp"] = "internal",
	["conform"] = "lsp",
	["dap"] = "debug",
	["diffview"] = "git",
	["flash"] = "find",
	["gitsigns"] = "git",
	["hover"] = "find",
	["lazygit"] = "git",
	["lspconfig"] = "lsp",
	["lspsaga"] = "lsp",
	["neogen"] = "lsp",
	["noice"] = "ui",
	["notify"] = "ui",
	["nvim-tree"] = "tree",
	["render-markdown"] = "misc",
	["snacks"] = "dashboard",
	["tabout"] = "internal",
	["telescope"] = "find",
	["toggleterm"] = "terminal",
	["undotree"] = "misc",
}

-- Descriptions for mappings configured through plugin option tables instead of
-- vim.keymap.set / lazy `keys` specs. The collector validates that keys in the
-- config still match these tables; an unknown key is a hard error.
M.internal = {
	cmp = {
		["<C-k>"] = {
			modes = { "i", "c" },
			desc = "Выбрать предыдущий пункт",
		},
		["<C-j>"] = {
			modes = { "i", "c" },
			desc = "Выбрать следующий пункт",
		},
		["<C-b>"] = {
			modes = { "i", "c" },
			desc = "Прокрутить документацию вверх",
		},
		["<C-f>"] = {
			modes = { "i", "c" },
			desc = "Прокрутить документацию вниз",
		},
		["<C-Space>"] = {
			modes = { "i", "c" },
			desc = "Запустить completion",
		},
		["<C-y>"] = {
			modes = { "i", "c" },
			desc = "Отключено (cmp.config.disable)",
		},
		["<C-e>"] = {
			modes = { "i", "c" },
			desc = "Прервать / закрыть меню",
		},
		["<CR>"] = {
			modes = { "i", "c" },
			desc = "Подтвердить выбранный пункт",
		},
		["<Tab>"] = {
			modes = { "i", "s" },
			desc = "Следующий пункт / jump по сниппету",
		},
		["<S-Tab>"] = {
			modes = { "i", "s" },
			desc = "Предыдущий пункт / jump назад",
		},
	},
	telescope = {
		["<C-j>"] = {
			modes = { "i" },
			desc = "Следующий результат / файл",
		},
		["<C-k>"] = {
			modes = { "i" },
			desc = "Предыдущий результат / файл",
		},
		["<C-u>"] = {
			modes = { "i" },
			desc = "Прокрутить preview вверх",
		},
		["<C-d>"] = {
			modes = { "i" },
			desc = "Прокрутить preview вниз",
		},
		["<C-q>"] = {
			modes = { "i" },
			desc = "Отправить в quickfix и открыть",
		},
		["<esc>"] = { modes = { "i" }, desc = "Закрыть Telescope" },
		["<C-x>"] = {
			modes = { "i" },
			desc = "Удалить буфер (buffers picker)",
		},
	},
	tabout = {
		["<Tab>"] = {
			modes = { "i" },
			desc = "Выйти из пары/скобки вперёд",
		},
		["<S-Tab>"] = {
			modes = { "i" },
			desc = "Выйти из пары/скобки назад",
		},
		["<C-t>"] = { modes = { "i" }, desc = "Обычный Tab" },
		["<C-d>"] = { modes = { "i" }, desc = "Обычный Shift-Tab" },
	},
}

-- Overlaps that are intentional or already documented as known problems.
-- Key format: "<mode>|<lhs>|<contexts sorted and joined by comma>".
M.overlap_allowlist = {
	["n|<leader>th|global,lsp"] = "toggleterm horizontal split перекрывается buffer-local LSP inlay hints",
	["n|<leader>rn|lsp,ruby"] = "LSP rename перекрывается Ruby Rails nearest test",
	["i|<Tab>|cmp,tabout"] = "cmp и tabout оба переопределяют Tab в insert; проверить порядок загрузки",
	["i|<S-Tab>|cmp,tabout"] = "cmp и tabout оба переопределяют S-Tab в insert; проверить порядок загрузки",
}

-- Plugin -> section fallback when a new plugin directory has no entry above.
M.default_plugin_section = "other"

function M.section_by_id(id)
	for _, section in ipairs(M.sections) do
		if section.id == id then
			return section
		end
	end
	return nil
end

function M.plugin_section(name)
	return M.plugin_sections[name] or M.default_plugin_section
end

return M
