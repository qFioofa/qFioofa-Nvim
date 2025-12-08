local utils = require("qfioofa.utils")
local pRoot = utils.roots.plugins

local function main()
	local lazy = require("lazy")

	lazy.setup({
		-- {
		-- 	"akinsho/bufferline.nvim",
		-- 	enable = false,
		-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
		-- 	config = require(pRoot .. "bufferline"),
		-- },
		{
			"qfioofa/yugen-ash.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd("colorscheme yugen-ash")
			end,
		},
		-- {
		-- 	"bettervim/yugen",
		-- 	config = function()
		-- 		vim.cmd("colorscheme yugen")
		-- 	end,
		-- 	priority = 1000,
		-- },
		{
			"SmiteshP/nvim-navic",
			dependencies = {
				"neovim/nvim-lspconfig",
			},
			config = require(pRoot .. "navic"),
		},
		{
			"MunifTanjim/nui.nvim",
			config = function() end,
		},
		{
			"rmagatti/auto-session",
			lazy = false,
			opts = {
				suppressed_dirs = {
					"~/",
					"~/Projects",
					"~/Downloads",
					"/",
				},
			},
		},
		{
			"windwp/nvim-autopairs",
			config = require(pRoot .. "autopairs"),
		},
		{
			"folke/snacks.nvim",
			priority = 1000,
			config = require(pRoot .. "snacks"),
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = require(pRoot .. "lualine"),
		},
		{
			"kyazdani42/nvim-tree.lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = require(pRoot .. "nvim-tree"),
		},
		{
			"arnamak/stay-centered.nvim",
			config = require(pRoot .. "stay-centered"),
		},
		{
			"norcalli/nvim-colorizer.lua",
			config = require(pRoot .. "colorizer"),
		},
		{
			"numToStr/Comment.nvim",
			config = require(pRoot .. "Comment"),
		},
		{
			"abecodes/tabout.nvim",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
			},
			config = require(pRoot .. "tabout"),
		},
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-nvim-lsp",
				"saghen/blink.cmp",
			},
			config = require(pRoot .. "cmp"),
		},
		{
			"lewis6991/hover.nvim",
			config = require(pRoot .. "hover"),
		},
		{
			"folke/noice.nvim",
			enabled = true,
			event = "VeryLazy",
			dependencies = {
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			},
			config = require(pRoot .. "noice"),
		},
		{
			"meanderingprogrammer/render-markdown.nvim",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"nvim-mini/mini.nvim",
			},
		},
		{
			"nvim-telescope/telescope.nvim",
			dependencies = {
				"nvim-telescope/telescope-media-files.nvim",
			},
			config = require(pRoot .. "telescope"),
		},
		{
			"stevearc/conform.nvim",
			config = require(pRoot .. "conform"),
		},
		{
			"ray-x/lsp_signature.nvim",
			event = "InsertEnter",
			config = require(pRoot .. "lsp-signature"),
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				"mason-org/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				{ "j-hui/fidget.nvim", opts = {} },
				"saghen/blink.cmp",
			},
			config = require(pRoot .. "lsp"),
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			main = "nvim-treesitter.configs",
			opts = {
				indent = { enable = true },
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				auto_installed = true,
				folds = { enable = true },
				ensure_installed = {
					"bash",
					"c",
					"diff",
					"html",
					"javascript",
					"jsdoc",
					"json",
					"jsonc",
					"lua",
					"luadoc",
					"luap",
					"markdown",
					"markdown_inline",
					"printf",
					"python",
					"query",
					"regex",
					"toml",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"xml",
					"yaml",
					"python",
					"typescript",
					"svelte",
				},
			},
		},
		-- UML
		{
			"javiorfo/nvim-soil",
			dependencies = { "javiorfo/nvim-nyctophilia" },
			lazy = true,
			ft = "plantuml",
			opts = {
				actions = {
					redraw = false,
				},
				image = {
					darkmode = false,
					format = "png",
				},
			},
		},
	})
end

return main
