-- local fn = vim.fn
-- local PACKER_INSTALL_PATH = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"


-- local PACKS_LIST = {
--     "wbthomason/packer.nvim", -- Have packer manage itself
--     "sainnhe/gruvbox-material" -- Gruvbox-material theme
-- }

-- local packer = nil
-- local PACKER_BOOTSTRAP = nil

-- function packer_installation()
--     if fn.empty(fn.glob(PACKER_INSTALL_PATH)) > 0 then
--         PACKER_BOOTSTRAP = fn.system {
--             "git",
--             "clone",
--             "--depth",
--             "1",
--             "https://github.com/wbthomason/packer.nvim",
--             PACKER_INSTALL_PATH,
--         }
--         print("Installing packer close and reopen Neovim...")
--         vim.cmd([[packadd packer.nvim]])
--     end
-- end

-- function init_packages()
--     packer.init {
--         display = {
--             open_fn = function()
--                 local packerUtilFloat = require("packer.util").float 
--                 return packerUtilFloat({ 
--                     border = "rounded" 
--                 })
--             end,
--         },
--     }
    
--     packer.startup(function(use)
--         for _, pack in ipairs(PACKS_LIST) do
--             use(pack)
--         end
--     end)
    
--     if PACKER_BOOTSTRAP then
--         require("packer").sync()
--     end    
-- end

-- return function()
--     packer_installation()

--     local status_ok, _ = pcall(require, "packer")
--     if not status_ok then
--         vim.cmd("packadd packer.nvim")
--         status_ok, _ = pcall(require, "packer")
--         if not status_ok then return end
--     end
    
--     packer = require('packer')
--     init_packages()
    
--     -- Force load all plugins
--     vim.cmd('PackerLoad')
-- end

local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

  -- Colorschemes
  -- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  use "lunarvim/darkplus.nvim"
  use "sainnhe/gruvbox-material"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)