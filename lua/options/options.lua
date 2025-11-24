-- Settings object of options and relative value
local Options = {
    backup = false,
    number = true,
    relativenumber = true,
    -- cursorline = true,
    autoindent = true,
    clipboard = "unnamedplus",

    guifont = "monospace:h17",
    conceallevel = 0,
    smartcase = true,
    cmdheight = 4,

    mouse = 'a',
    fileencoding = "utf-8"
}


-- Loading all options in vim
for OptionName, OptionValue in pairs(Options) do
    vim.opt[OptionName] = OptionValue
end
