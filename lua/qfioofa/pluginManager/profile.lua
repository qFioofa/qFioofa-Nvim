local override = vim.env.NVIM_PROFILE or vim.g.qfioofa_profile
if override and override ~= "" then
	return override
end

return vim.fn.has("nvim-0.12") == 1 and "pack" or "lazy"
