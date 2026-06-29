-- "lazy" (lazy.nvim + nvim-cmp, <0.12) | "pack" (vim.pack + native completion, >=0.12).
-- Override with NVIM_PROFILE or vim.g.qfioofa_profile.
local override = vim.env.NVIM_PROFILE or vim.g.qfioofa_profile
if override and override ~= "" then
	return override
end

return vim.fn.has("nvim-0.12") == 1 and "pack" or "lazy"
