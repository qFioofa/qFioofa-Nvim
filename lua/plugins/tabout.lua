local PACKAGE_NAME = "tabout"

local Options = {
	tabkey = '<Tab>',
    backwards_tabkey = '<S-Tab>',
    act_as_tab = true,
    act_as_shift_tab = false,   
	default_tab = '<C-t>',
	default_shift_tab = '<C-d>',
    enable_backwards = true, 
    completion = true, 
	tabouts = {
      {open = "'", close = "'"},
      {open = '"', close = '"'},
      {open = '`', close = '`'},
      {open = '(', close = ')'},
      {open = '[', close = ']'},
      {open = '{', close = '}'}
    },
    ignore_beginning = true,
    exclude = {} 
}

return function()
	local tabout = require(PACKAGE_NAME)
	tabout.setup(Options)
end
