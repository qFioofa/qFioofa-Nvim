std = "max"
globals = { "vim" }

-- ASCII-art dashboard headers: trailing/blank whitespace is load-bearing
-- (alignment), so silence the whitespace warnings for this file only.
files["lua/qfioofa/plugins/common/snacks/options.lua"] = {
	ignore = { "611", "612", "613", "614" },
}

-- Markdown/AGENTS template prose: long string literals are intentional.
files["scripts/docs/render.lua"] = {
	ignore = { "631" },
}
