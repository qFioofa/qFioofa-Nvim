-- Global nvim-dap mappings. Called once from the dap plugin's config().
-- Ported from bcampolo/nvim-starter-kit (java branch); <leader>dd was left
-- alone because this config already maps it to "delete entire buffer", so
-- disconnect lives on <leader>dx instead.
return function()
	local dap = require("dap")
	local map = function(keys, fn, desc)
		vim.keymap.set("n", keys, fn, { desc = desc })
	end

	-- Breakpoints (<leader>b)
	map("<leader>bb", dap.toggle_breakpoint, "Toggle breakpoint")
	map("<leader>bc", function()
		dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, "Conditional breakpoint")
	map("<leader>bl", function()
		dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
	end, "Log point")
	map("<leader>br", dap.clear_breakpoints, "Clear breakpoints")
	map(
		"<leader>ba",
		"<cmd>Telescope dap list_breakpoints<cr>",
		"List breakpoints"
	)

	-- Stepping / session control (<leader>d)
	map("<leader>dc", dap.continue, "Continue / Start")
	map("<leader>dj", dap.step_over, "Step over")
	map("<leader>dk", dap.step_into, "Step into")
	map("<leader>do", dap.step_out, "Step out")
	map("<leader>dr", dap.repl.toggle, "Toggle REPL")
	map("<leader>dl", dap.run_last, "Run last")
	map("<leader>dx", function()
		dap.disconnect()
		require("dapui").close()
	end, "Disconnect")
	map("<leader>dt", function()
		dap.terminate()
		require("dapui").close()
	end, "Terminate")

	-- Inspect (<leader>d)
	map("<leader>di", function()
		require("dap.ui.widgets").hover()
	end, "Hover variable")
	map("<leader>d?", function()
		local widgets = require("dap.ui.widgets")
		widgets.centered_float(widgets.scopes)
	end, "Scopes")
	map("<leader>df", "<cmd>Telescope dap frames<cr>", "Frames")
	map("<leader>dh", "<cmd>Telescope dap commands<cr>", "Commands")
	map("<leader>du", function()
		require("dapui").toggle()
	end, "Toggle DAP UI")
end
