-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
--
-- Java snippets. Loaded only for `java` filetype via the from_lua loader.
-- `override_priority` in the luasnip config makes these replace the
-- friendly-snippets duplicates (class, ctor, fori, ...).

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

-- Uppercase the first character (used for getter/setter names).
local function capitalize(args)
	local str = args[1][1] or ""
	return str:sub(1, 1):upper() .. str:sub(2)
end

-- The public class name from the current buffer (used by ctor/logger).
local function class_name()
	for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 40, false)) do
		local name = line:match("%s*public%s+class%s+([%w_]+)")
		if name then
			return name
		end
	end
	return "Name"
end

-- Collect `private Type field;` declarations from the buffer so `ctor` can
-- build a real constructor from them.
local function collect_fields()
	local fields = {}
	for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
		local typ, name = line:match(
			"^%s*(?:private|protected|public)%s+([%w_<>%.,%[%]]+)%s+([%w_]+)%s*;"
		)
		if typ and name and not name:match("^%u") and typ ~= "return" then
			fields[#fields + 1] = { typ = typ, name = name }
		end
	end
	return fields
end

local function ctor_dynamic()
	local fields = collect_fields()

	if #fields == 0 then
		return sn(nil, fmt([[
public {}({}) {{
	{}
}}
]], { i(1, class_name()), i(2, "Type arg"), i(3, "this.arg = arg;") }))
	end

	local params = {}
	local assigns = {}
	for _, field in ipairs(fields) do
		params[#params + 1] = field.typ .. " " .. field.name
		assigns[#assigns + 1] = "this." .. field.name .. " = " .. field.name .. ";"
	end

	return sn(nil, fmt([[
public {}({}) {{
	{}
}}
]], {
	t(class_name()),
	t(table.concat(params, ", ")),
	t(table.concat(assigns, "\n\t")),
}))
end

return {
	s("class", fmt([[
public class {} {{

}}
]], { i(1, "Name") })),

	s("main", fmt([[
public class {} {{
	public static void main(String[] args) {{
		{}
	}}
}}
]], { i(1, "Main"), i(2) })),

	s("psvm", fmt([[
public static void main(String[] args) {{
	{}
}}
]], { i(1) })),

	s("sout", fmt("System.out.println({});", { i(1) })),

	s("interface", fmt([[
public interface {} {{

}}
]], { i(1, "Name") })),

	s("enum", fmt([[
public enum {} {{
	{},
}}
]], { i(1, "Name"), i(2, "VALUE") })),

	s("record", fmt([[
public record {}({}) {{

}}
]], { i(1, "Name"), i(2, "Type field") })),

	s("ctor", d(1, ctor_dynamic, {})),

	s("getter", fmt([[
public {} get{}() {{
	return {};
}}
]], { i(1, "Type"), f(capitalize, { 2 }), rep(2) })),

	s("setter", fmt([[
public void set{}({} {}) {{
	this.{} = {};
}}
]], { f(capitalize, { 2 }), i(1, "Type"), i(2, "field"), rep(2), rep(2) })),

	s("fori", fmt([[
for (int i = 0; i < {}; i++) {{
	{}
}}
]], { i(1, "n"), i(2) })),

	s("foreach", fmt([[
for ({} {} : {}) {{
	{}
}}
]], { i(1, "Type"), i(2, "var"), i(3, "items"), i(4) })),

	s("ifn", fmt([[
if ({} == null) {{
	{}
}}
]], { i(1, "obj"), i(2) })),

	s("ifnn", fmt([[
if ({} != null) {{
	{}
}}
]], { i(1, "obj"), i(2) })),

	s("try", fmt([[
try {{
	{}
}} catch ({} e) {{
	{}
}}
]], { i(1), i(2, "Exception"), i(3) })),

	s("tryw", fmt([[
try ({}) {{
	{}
}} catch ({} e) {{
	{}
}}
]], { i(1, "AutoCloseable res"), i(2), i(3, "Exception"), i(4) })),

	s("logger", fmt([[
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

private static final Logger logger = LoggerFactory.getLogger({}.class);
]], { t(class_name()) })),
}
