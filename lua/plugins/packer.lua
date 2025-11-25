local fn = vim.fn
local PACKER_INSTALL_PATH = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"


local PACKS_LIST = {
    "wbthomason/packer.nvim", -- Have packer manage itself
    "sainnhe/gruvbox-material", -- Gruvbox-material theme
	"windwp/nvim-autopairs", -- Autopairs: {} [] () '' ""
	"kyazdani42/nvim-tree.lua", -- Nvim tree aka Explorer
	"kyazdani42/nvim-web-devicons" -- Icons extantion for nvim tree
}

local packer = nil
local PACKER_BOOTSTRAP = nil

function packer_installation()
    if fn.empty(fn.glob(PACKER_INSTALL_PATH)) > 0 then
        PACKER_BOOTSTRAP = fn.system {
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            PACKER_INSTALL_PATH,
        }
        print("Installing packer close and reopen Neovim...")
        vim.cmd([[packadd packer.nvim]])
    end
end

function init_packages()
    packer.init {
        display = {
            open_fn = function()
                local packerUtilFloat = require("packer.util").float 
                return packerUtilFloat({ 
                    border = "rounded" 
                })
            end,
        },
    }
    
    packer.startup(function(use)
        for _, pack in ipairs(PACKS_LIST) do
            use(pack)
        end
    end)
    
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end    
end

return function()
    packer_installation()

    local status_ok, _ = pcall(require, "packer")
    if not status_ok then
        vim.cmd("packadd packer.nvim")
        status_ok, _ = pcall(require, "packer")
        if not status_ok then return end
    end
    
    packer = require('packer')
    init_packages()
    
    -- Force load all plugins
    -- vim.cmd('PackerLoad')
end
