local function wrap_line(line, max_width)
	local indent = line:match("^%s*") or ""
	local words = {}
	for word in line:gmatch("%S+") do
		words[#words + 1] = word
	end

	if #words == 0 then
		return { "" }
	end

	local wrapped = {}
	local current = indent
	local has_word = false
	for _, word in ipairs(words) do
		local candidate = has_word and (current .. " " .. word)
			or (current .. word)
		if not has_word or vim.fn.strdisplaywidth(candidate) <= max_width then
			current = candidate
			has_word = true
		else
			wrapped[#wrapped + 1] = current
			current = word
		end
	end
	wrapped[#wrapped + 1] = current
	return wrapped
end

local function custom_wrap(lines, max_width)
	local right_pad = "  "
	local inner_width = math.max(1, max_width - #right_pad)
	local wrapped = {}
	for _, line in ipairs(lines) do
		for _, part in ipairs(wrap_line(line, inner_width)) do
			wrapped[#wrapped + 1] = part .. right_pad
		end
	end
	return wrapped
end

return function(bufnr, notif, highlights)
	local namespace = require("notify.render.base").namespace()
	local icon = notif.icon
	local icon_length = #icon
	local wrap_width = math.max(10, math.floor(vim.o.columns * 0.35))
	local message = custom_wrap(notif.message, wrap_width)

	local title = notif.title[1]
	local default_titles = { "Error", "Warning", "Notify" }
	local has_valid_manual_title = type(title) == "string"
		and #title > 0
		and not vim.tbl_contains(default_titles, title)

	local prefix_length = 0
	if has_valid_manual_title then
		local prefix = string.format("%s %s ", icon, title)
		if notif.duplicates then
			prefix = string.format("%s x%d", prefix, #notif.duplicates)
		end
		prefix_length = #prefix
		table.insert(message, 1, prefix)
	end

	message[1] = " " .. (message[1] or "")

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, message)

	if has_valid_manual_title then
		vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
			hl_group = highlights.icon,
			end_col = icon_length + 1,
			priority = 50,
		})
		vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, icon_length + 1, {
			hl_group = highlights.title,
			end_col = prefix_length + 1,
			priority = 50,
		})
	end

	vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, prefix_length + 1, {
		hl_group = highlights.body,
		end_line = #message,
		priority = 50,
	})

	for row = 1, #message - 1 do
		vim.api.nvim_buf_set_extmark(bufnr, namespace, row, 0, {
			virt_text = { { " ", highlights.body } },
			virt_text_pos = "inline",
		})
		vim.api.nvim_buf_set_extmark(bufnr, namespace, row, 0, {
			virt_text = { { " ", highlights.body } },
			virt_text_pos = "right_align",
		})
	end
end
