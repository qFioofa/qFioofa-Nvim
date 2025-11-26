-- Settings object of options and relative value
local Options = {
    -- General
    backup = false,
    clipboard = "unnamedplus",

    -- Leftside numbers
    number = true,
    relativenumber = true,

    --Tabs
    showtabline = 0,
    shiftwidth = 4,
    tabstop = 4,
    smartindent = true, 
    autoindent = true,

    -- Line
    linebreak = true,
    wrap = true,
    whichwrap = "bs<>[]hl",

    -- Windows
    title = true,
    splitright = true,
    splitbelow = true,

    fillchars = {
        eob = ' '
    },
    list = true,
    listchars = {
        tab = '│ '
    },
    signcolumn = "yes",
    termguicolors = true,

    -- Sounds
    errorbells = false,
    visualbell = false,

    -- Unicode
    emoji = true,
    encoding = "utf-8",
    guifont = "monospace:h17",

    -- Cmd
    cmdheight = 4,

    -- Other
    mouse = 'a',
}


-- Loading all options in vim
for OptionName, OptionValue in pairs(Options) do
    vim.opt[OptionName] = OptionValue
end
