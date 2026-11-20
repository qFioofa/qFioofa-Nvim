-- snacks.image measures and transcodes every placement with ImageMagick, so a
-- missing `magick`/`convert` binary turns into a per-image "Image Conversion
-- Failed" instead of one clear error. Warn once and point at the fix.
local function warn_missing_converter()
	if
		vim.fn.executable("magick") == 1
		or vim.fn.executable("convert") == 1
	then
		return
	end
	vim.defer_fn(function()
		vim.notify(
			"snacks.image: ImageMagick not found (`magick`/`convert`), images will not render",
			vim.log.levels.WARN
		)
	end, 2000)
end

local function config()
	local ok, snacks = pcall(require, "snacks")
	if not ok then
		return
	end

	snacks.setup(require("qfioofa.plugins.common.snacks.options"))
	warn_missing_converter()
end

return {
	"folke/snacks.nvim",
	priority = 1000,
	config = config,
}
