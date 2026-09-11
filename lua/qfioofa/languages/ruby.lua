local M = {}

local function map(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, { buffer = true, silent = true, desc = desc })
end

function M.start()
	-- ruby_lsp is already started via vim.lsp.config + vim.lsp.enable in
	-- shared.lua — no manual start_or_attach needed here. Only buffer-local
	-- Ruby/Rails keymaps.

	map("<leader>rr", function()
		vim.cmd("!ruby %")
	end, "Ruby: run file")

	map("<leader>rt", function()
		vim.cmd("!rails test")
	end, "Rails: run tests")

	map("<leader>rn", function()
		vim.cmd("!rails test " .. vim.fn.expand("%") .. ":" .. vim.fn.line("."))
	end, "Rails: run nearest test")

	map("<leader>rg", function()
		local cmd = vim.fn.input("rails generate ", "")
		if cmd ~= "" then
			vim.cmd("!rails generate " .. cmd)
		end
	end, "Rails: generate")

	map("<leader>rs", function()
		vim.cmd("!rails server")
	end, "Rails: server")

	map("<leader>rc", function()
		local cmd = vim.fn.input("rails console ", "")
		if cmd ~= "" then
			vim.cmd("!rails console " .. cmd)
		end
	end, "Rails: console")

	map("<leader>rk", function()
		vim.cmd("!rubocop -A %")
	end, "Rubocop: autocorrect file")

	map("<leader>rd", function()
		vim.cmd("!rdbg %")
	end, "Ruby: debug file")

	map("<leader>rb", function()
		vim.cmd("!bundle exec rspec " .. vim.fn.expand("%") .. ":" .. vim.fn.line("."))
	end, "RSpec: run nearest spec")

	map("<leader>ra", function()
		vim.cmd("!bundle exec rspec")
	end, "RSpec: run all specs")
end

return M
