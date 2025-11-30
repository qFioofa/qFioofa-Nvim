local utils = require("qfioofa.utils")
local pRoot = utils.roots.plugins

local function main()
	local lazy = require("lazy")
	
	lazy.setup({
		{
			"sainnhe/gruvbox-material",
			priority = 1000,
			config = function()
				vim.cmd.colorscheme('gruvbox-material')
			end
		},
		{
			"SmiteshP/nvim-navic",
			config = function() end
		},
		{
			"MunifTanjim/nui.nvim",
			config = function() end
		},
		{
			"utilyre/barbecue.nvim",
			requires = {
				"SmiteshP/nvim-navic",
				"nvim-tree/nvim-web-devicons", 
			},
			after = "nvim-web-devicons",
			config = require(pRoot .. "barbecue")
		},
		{
			"rmagatti/auto-session",
			lazy = false,
			opts = {
				suppressed_dirs = { 
					"~/", 
					"~/Projects", 
					"~/Downloads", 
					"/" 
				},
			}
		},
		{
			"folke/snacks.nvim",
			priority = 1000,
			config = require(pRoot .. "snacks")
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = require(pRoot .. "lualine")
		},
		{
			"kyazdani42/nvim-tree.lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = require(pRoot .. "nvim-tree")
		},
		{
			"kyazdani42/nvim-web-devicons",
			enabled = true
		},
		{
			"arnamak/stay-centered.nvim",
			config = require(pRoot .. "stay-centered")
		},
		{
			"norcalli/nvim-colorizer.lua",
			config = require(pRoot .. "colorizer")
		},
		{
			"numToStr/Comment.nvim",
			config = require(pRoot .. "Comment")
		},
		{
			"abecodes/tabout.nvim",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
			},
			config = require(pRoot .. "tabout")
		},
		{
			"folke/flash.nvim",
			config = require(pRoot .. "flash")
		},
		{
			"akinsho/bufferline.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = require(pRoot .. "bufferline")
		},
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-nvim-lsp",
			},
			config = require(pRoot .. "cmp")
		},
		{
			"lewis6991/hover.nvim",
			config = require(pRoot .. "hover")
		},
		{
			"nvim-mini/mini.animate",
			enabled = true,
			config = require(pRoot .. "mini-animate")
		},
		{
			"folke/noice.nvim",
			enabled = true,
			-- event = "VeryLazy",
			-- commit = "5a78b42",
			dependencies = {
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			},
			config = require(pRoot .. "noice"),
		},
		{
			'meanderingprogrammer/render-markdown.nvim',
			dependencies = { 
				'nvim-treesitter/nvim-treesitter', 
				'nvim-mini/mini.nvim' 
			},
		}
	})
end

return main
