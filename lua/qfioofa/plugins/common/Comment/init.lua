local function config()
	local ok, comment = pcall(require, "Comment")
	if not ok then
		return
	end

	comment.setup(require("qfioofa.plugins.common.Comment.options"))
end

return {
	"numToStr/Comment.nvim",
	config = config,
}
