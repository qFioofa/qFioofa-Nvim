-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s("date", t(os.date("%Y-%m-%d"))),

	s("todo", { t("-- TODO: "), i(1) }),
}
