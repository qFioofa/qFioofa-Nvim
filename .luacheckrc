std = "max"
globals = { "vim" }

-- ASCII-art dashboard headers: trailing/blank whitespace is load-bearing
-- (alignment), so silence the whitespace warnings for this file only.
files["lua/qfioofa/plugins/snacks/options.lua"] = {
	ignore = { "611", "612", "613", "614" },
}
