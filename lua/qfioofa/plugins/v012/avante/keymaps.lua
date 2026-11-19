local function agent_mode(name)
	return "<cmd>lua require('qfioofa.plugins.v012.avante.mode').set('"
		.. name
		.. "')<cr>"
end

return {
	{
		"<leader>ic",
		"<cmd>AvanteChat<cr>",
		desc = "Avante: chat",
	},
	{
		"<leader>ia",
		"<cmd>AvanteAsk<cr>",
		desc = "Avante: ask",
	},
	{
		"<leader>in",
		"<cmd>AvanteChatNew<cr>",
		desc = "Avante: new chat",
	},
	{
		"<leader>ir",
		"<cmd>Avante resume<cr>",
		desc = "Avante: resume session",
	},
	{
		"<leader>it",
		"<cmd>Avante toggle<cr>",
		desc = "Avante: toggle sidebar",
	},
	{
		"<leader>if",
		"<cmd>AvanteFocus<cr>",
		desc = "Avante: focus sidebar",
	},
	{
		"<leader>is",
		"<cmd>AvanteStop<cr>",
		desc = "Avante: stop request",
	},
	{
		"<leader>ie",
		"<cmd>AvanteEdit<cr>",
		mode = "v",
		desc = "Avante: edit selection",
	},
	{
		"<leader>ix",
		"<cmd>AvanteClear<cr>",
		desc = "Avante: clear history",
	},
	{
		"<leader>iM",
		"<cmd>AvanteSwitchProvider<cr>",
		desc = "Avante: switch provider",
	},
	{
		"<leader>iP",
		agent_mode("plan"),
		desc = "Agent: plan mode",
	},
	{
		"<leader>ib",
		agent_mode("build"),
		desc = "Agent: build mode",
	},
}
