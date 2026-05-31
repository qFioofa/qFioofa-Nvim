-- Enable Neovim's bytecode/module cache (0.9+) for faster startup.
vim.loader.enable()

require("qfioofa.pluginManager.initManager")()
require("qfioofa.init")()
