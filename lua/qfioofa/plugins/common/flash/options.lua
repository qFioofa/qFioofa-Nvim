-- flash.nvim configuration (passed to require("flash").setup()).
return {
	-- Labels used for jump targets.
	labels = "asdfghjklqwertyuiopzxcvbnm",
	search = {
		-- Jump across all visible windows, not just the current one.
		multi_window = true,
		wrap = true,
		-- "exact" | "search" | "fuzzy" — how the search string is matched.
		mode = "exact",
	},
	jump = {
		-- Clear search highlight after jumping.
		nohlsearch = true,
		-- Wait for a label even when only one match remains.
		autojump = false,
	},
	modes = {
		-- Enhance `f`/`F`/`t`/`T` with flash continuation (`;`/`,`).
		char = {
			enabled = true,
			jump_labels = false,
		},
		-- Don't hijack the regular `/` and `?` search by default;
		-- toggle it on demand with <C-s> (see keymaps).
		search = {
			enabled = false,
		},
	},
}
