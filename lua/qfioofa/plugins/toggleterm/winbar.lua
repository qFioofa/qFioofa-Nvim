-- Renders the user's full lualine statusline inside a toggleterm window's
-- winbar (top of the window).
--
-- A floating terminal can't draw a real statusline, but it *can* show a
-- window-local winbar. Rather than hand-rolling the bar, we reuse lualine's own
-- renderer so the contents match the configured sections exactly -- mode (with
-- its mode-matching colors), branch, diagnostics, location, etc. The toggleterm
-- lualine extension swaps the filename slot for the shell terminal name (see
-- lua/qfioofa/plugins/lualine/options.lua).

local M = {}

-- Statusline expression body: lualine renders for the window currently being
-- drawn. Evaluated outside a refresh cycle, lualine dispatches on the current
-- buffer's filetype ("toggleterm"), so it picks up our toggleterm extension.
function M.render()
	local ok, lualine = pcall(require, "lualine")
	if not ok then
		return ""
	end
	return lualine.statusline(true) or ""
end

---Attach the winbar to a toggleterm terminal window (float or split).
---@param term table Terminal instance passed to the `on_open` callback.
function M.attach(term)
	if
		not term
		or not term.window
		or not vim.api.nvim_win_is_valid(term.window)
	then
		return
	end
	vim.wo[term.window].winbar =
		"%{%v:lua.require('qfioofa.plugins.toggleterm.winbar').render()%}"

	-- Pre-build lualine's transitional separator highlights for this window now,
	-- outside a redraw. Creating highlight groups during the winbar's draw-time
	-- evaluation can silently fail, which would drop the rounded separators.
	vim.api.nvim_win_call(term.window, function()
		pcall(M.render)
	end)
end

-- Terminal mode transitions (e.g. <C-\><C-n>) don't always trigger a winbar
-- redraw on their own, so nudge it when the mode changes in a terminal buffer.
vim.api.nvim_create_autocmd({ "ModeChanged", "TermEnter", "TermLeave" }, {
	group = vim.api.nvim_create_augroup("QfTermWinbar", { clear = true }),
	callback = function()
		if vim.bo.buftype == "terminal" then
			vim.cmd("redrawstatus")
		end
	end,
})

return M
