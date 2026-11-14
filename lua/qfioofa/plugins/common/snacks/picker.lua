local function file_header(item, picker)
	local snacks = require("snacks")
	local ret = {}
	local icon, hl = snacks.util.icon(item.file, "file", {
		fallback = picker.opts.icons.files,
	})
	if icon then
		ret[#ret + 1] = { icon, hl, virtual = true }
	end
	ret[#ret + 1] = { vim.fn.fnamemodify(item.file, ":t"), "SnacksPickerFile" }
	local dir = vim.fn.fnamemodify(item.file, ":h")
	if dir ~= "." and dir ~= "" then
		ret[#ret + 1] = { " " }
		ret[#ret + 1] = { dir, "SnacksPickerDir" }
	end
	return ret
end

local function grep_format(item, picker)
	if item.group_file then
		return file_header(item, picker)
	end

	local ret = { { "   ", "SnacksPickerTree" } }
	if item.pos then
		ret[#ret + 1] = { tostring(item.pos[1]), "SnacksPickerRow" }
		ret[#ret + 1] = { ":", "SnacksPickerDelim" }
		if item.pos[2] and item.pos[2] > 0 then
			ret[#ret + 1] = { tostring(item.pos[2]), "SnacksPickerCol" }
			ret[#ret + 1] = { ":", "SnacksPickerDelim" }
		end
		ret[#ret + 1] = { " ", "SnacksPickerDelim" }
	end
	if item.line then
		local snacks = require("snacks")
		if item.positions then
			local offset = snacks.picker.highlight.offset(ret)
			snacks.picker.highlight.matches(ret, item.positions, offset)
		end
		snacks.picker.highlight.format(item, item.line, ret)
	end
	return ret
end

local function grep_grouped(opts, ctx)
	local grep = require("snacks.picker.source.grep")
	local search = grep.grep(opts, ctx)
	local headers = {}

	return function(cb)
		search(function(item)
			if not item.file then
				return cb(item)
			end
			local header = headers[item.file]
			if not header then
				header = {
					text = item.file,
					file = item.file,
					group_file = true,
					parent = { root = true },
				}
				headers[item.file] = header
				cb(header)
			end
			item.parent = header
			cb(item)
		end)
	end
end

return {
	sources = {
		grep_grouped = {
			finder = grep_grouped,
			format = grep_format,
			preview = "file",
			regex = true,
			hidden = true,
			live = true,
			supports_live = true,
			need_search = true,
			matcher = { keep_parents = true },
			sort = { fields = { "file", "idx" } },
		},
	},
}
