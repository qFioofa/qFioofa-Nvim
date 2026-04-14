local utils = require("qfioofa.utils")
local pRoot = utils.roots.plugins

local function main()
	local lazy = require("lazy")

	lazy.setup({
		{
			"qFioofa/physical-keyboard.nvim",
			event = "VeryLazy",
			opts = {
				active_layouts = {
					"ru-en",
				},
			},
		},
		-- {
		-- 	"jellisonleao/gruvbox.nvim",
		-- 	lazy = false,
		-- 	priority = 1000,
		-- 	config = function()
		-- 		vim.cmd("colorscheme gruvbox")
		-- 	end,
		-- },
		-- {
		-- 	"bettervim/yugen",
		-- 	config = function()
		-- 		vim.cmd("colorscheme yugen")
		-- 	end,
		-- 	priority = 1000,
		-- },
		-- {
		-- 	"rose-pine/neovim",
		-- 	name = "rose-pine",
		-- 	config = function()
		-- 		vim.cmd("colorscheme rose-pine")
		-- 		require("rose-pine").setup({
		-- 			variant = "main",
		-- 		})
		-- 	end,
		-- },
		{
			"qfioofa/yugen-ash.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd("colorscheme yugen-ash")
			end,
		},
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
			"okuuva/auto-save.nvim",
			lazy = false,
			keys = {
				{
					"<leader>as",
					"<cmd>ASToggle<CR>",
					desc = "Toggle auto-save",
				},
			},
			opts = {
				enabled = true,
				trigger_events = {
					immediate_save = { "BufLeave" },
					defer_save = {},
					cancel_deferred_save = {},
				},
				condition = function(buf)
					local excluded_filetypes = {
						"nvimtree",
						"NvimTree",
						"gitcommit",
						"help",
						"man",
						"TelescopePrompt",
						"toggleterm",
						"oil",
						"neo-tree",
						"alpha",
						"dashboard",
						"lazygit",
						"Outline",
						"prompt",
					}

					local filetype = vim.fn.getbufvar(buf, "&filetype")
					local buftype = vim.fn.getbufvar(buf, "&buftype")

					if vim.tbl_contains(excluded_filetypes, filetype) then
						return false
					end

					if buftype ~= "" then
						return false
					end

					return true
				end,
				write_all_buffers = false,
				noautocmd = false,
				lockmarks = false,
				debounce_delay = 1000,
				debug = false,
			},
		},
		{
			"rmagatti/auto-session",
			lazy = false,
			opts = {
				auto_restore_last_session = true,
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
			opts = {
				bind = true,
				handler_opts = {
					border = "rounded",
				},
			},
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				{ "williamboman/mason.nvim", config = true },
				"williamboman/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				{ "j-hui/fidget.nvim", opts = {} },
				{ "folke/neodev.nvim", opts = {} },
			},
			config = function()
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup(
						"kickstart-lsp-attach",
						{ clear = true }
					),
					callback = function(event)
						-- Keymaps
						vim.keymap.set("n", "<leader>tl", function()
							local clients = vim.lsp.get_clients({ bufnr = 0 })
							if next(clients) then
								for _, client in ipairs(clients) do
									vim.lsp.buf_detach_client(0, client.id)
								end
								vim.notify("LSP OFF", vim.log.levels.WARN)
							else
								vim.cmd("edit")
								vim.notify("LSP ON", vim.log.levels.INFO)
							end
						end, { desc = "Toggle LSP (Detach/Reload)" })

						--- Messages with error
						vim.keymap.set("n", "<leader>to", function()
							local errs = vim.diagnostic.get(0)
							if #errs > 0 then
								vim.diagnostic.setloclist({ open = true })
							end
						end, { desc = "Open lsp error messages" })

						---
						vim.keymap.set("n", "<leader>te", function()
							local buf = vim.api.nvim_get_current_buf()
							local state =
								vim.diagnostic.is_enabled({ bufnr = buf })
							vim.diagnostic.enable(not state, { bufnr = buf })
							vim.notify(
								state and "Diagnostic hidden"
									or "Diagnostic shown",
								vim.log.levels.INFO
							)
						end, { desc = "Toggle Errors Visibility" })
						-- NOTE: Remember that Lua is a real programming language, and as such it is possible
						-- to define small helper and utility functions so you don't have to repeat yourself.
						--
						-- In this case, we create a function that lets us more easily define mappings specific
						-- for LSP related items. It sets the mode, buffer and description for us each time.
						local map = function(keys, func, desc)
							vim.keymap.set(
								"n",
								keys,
								func,
								{ buffer = event.buf, desc = "LSP: " .. desc }
							)
						end

						-- Jump to the definition of the word under your cursor.
						--  This is where a variable was first declared, or where a function is defined, etc.
						--  To jump back, press <C-t>.
						map(
							"gd",
							require("telescope.builtin").lsp_definitions,
							"[G]oto [D]efinition"
						)

						-- Find references for the word under your cursor.
						map(
							"gr",
							require("telescope.builtin").lsp_references,
							"[G]oto [R]eferences"
						)

						-- Jump to the implementation of the word under your cursor.
						--  Useful when your language has ways of declaring types without an actual implementation.
						map(
							"gI",
							require("telescope.builtin").lsp_implementations,
							"[G]oto [I]mplementation"
						)

						-- Jump to the type of the word under your cursor.
						--  Useful when you're not sure what type a variable is and you want to see
						--  the definition of its *type*, not where it was *defined*.
						map(
							"<leader>D",
							require("telescope.builtin").lsp_type_definitions,
							"Type [D]efinition"
						)

						-- Fuzzy find all the symbols in your current document.
						--  Symbols are things like variables, functions, types, etc.
						map(
							"<leader>ds",
							require("telescope.builtin").lsp_document_symbols,
							"[D]ocument [S]ymbols"
						)

						-- Fuzzy find all the symbols in your current workspace.
						--  Similar to document symbols, except searches over your entire project.
						map(
							"<leader>ws",
							require("telescope.builtin").lsp_dynamic_workspace_symbols,
							"[W]orkspace [S]ymbols"
						)

						-- Rename the variable under your cursor.
						--  Most Language Servers support renaming across files, etc.
						map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

						-- Execute a code action, usually your cursor needs to be on top of an error
						-- or a suggestion from your LSP for this to activate.
						map(
							"<leader>ca",
							vim.lsp.buf.code_action,
							"[C]ode [A]ction"
						)

						-- Opens a popup that displays documentation about the word under your cursor
						--  See `:help K` for why this keymap.
						map("K", vim.lsp.buf.hover, "Hover Documentation")

						-- WARN: This is not Goto Definition, this is Goto Declaration.
						--  For example, in C this would take you to the header.
						map(
							"gD",
							vim.lsp.buf.declaration,
							"[G]oto [D]eclaration"
						)

						-- The following two autocommands are used to highlight references of the
						-- word under your cursor when your cursor rests there for a little while.
						--    See `:help CursorHold` for information about when this is executed
						--
						-- When you move your cursor, the highlights will be cleared (the second autocommand).
						local client =
							vim.lsp.get_client_by_id(event.data.client_id)
						if
							client
							and client.server_capabilities.documentHighlightProvider
						then
							local highlight_augroup =
								vim.api.nvim_create_augroup(
									"kickstart-lsp-highlight",
									{ clear = false }
								)
							vim.api.nvim_create_autocmd(
								{ "CursorHold", "CursorHoldI" },
								{
									buffer = event.buf,
									group = highlight_augroup,
									callback = vim.lsp.buf.document_highlight,
								}
							)

							vim.api.nvim_create_autocmd(
								{ "CursorMoved", "CursorMovedI" },
								{
									buffer = event.buf,
									group = highlight_augroup,
									callback = vim.lsp.buf.clear_references,
								}
							)
						end

						-- The following autocommand is used to enable inlay hints in your
						-- code, if the language server you are using supports them
						--
						-- This may be unwanted, since they displace some of your code
						if
							client
							and client.server_capabilities.inlayHintProvider
							and vim.lsp.inlay_hint
						then
							map("<leader>th", function()
								vim.lsp.inlay_hint.enable(
									not vim.lsp.inlay_hint.is_enabled()
								)
							end, "[T]oggle Inlay [H]ints")
						end
					end,
				})

				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup(
						"kickstart-lsp-detach",
						{ clear = true }
					),
					callback = function(event)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({
							group = "kickstart-lsp-highlight",
							buffer = event.buf,
						})
					end,
				})

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities = vim.tbl_deep_extend(
					"force",
					capabilities,
					require("cmp_nvim_lsp").default_capabilities()
				)

				-- NOTE: LSP servers
				local servers = {
					eslint = {},
					svelte = {},
					["typescript-language-server"] = {},
					["clang-format"] = {},
					["clangd"] = {},
					lua_ls = {
						settings = {
							Lua = {
								runtime = {
									version = "LuaJIT",
								},
								diagnostics = {
									globals = { "vim" },
									enable = false,
								},
								workspace = {
									library = vim.api.nvim_get_runtime_file(
										"",
										true
									),
									checkThirdParty = false,
								},
								telemetry = {
									enable = false,
								},
							},
						},
					},
				}

				-- UML LSP installation
				-- Install go
				-- sudo apt install golang-go
				--
				-- install lsp
				-- go install github.com/ptdewey/plantuml-lsp@latest

				local lspconfig = require("lspconfig")
				local configs = require("lspconfig.configs")
				if not configs.plantuml_lsp then
					configs.plantuml_lsp = {
						default_config = {
							cmd = {
								"plantuml-lsp",
								"--exec-path=plantuml",
							},
							filetypes = { "plantuml", "uml", "puml" },
							root_dir = function(fname)
								return lspconfig.util.find_git_ancestor(fname)
									or lspconfig.util.path.dirname(fname)
							end,
							settings = {},
						},
					}
				end
				lspconfig.plantuml_lsp.setup({})

				vim.diagnostic.config({
					virtual_text = true,
					signs = false,
					underline = true,
				})

				require("mason").setup()

				local ensure_installed = vim.tbl_keys(servers or {})
				vim.list_extend(ensure_installed, {
					"stylua",
				})
				require("mason-tool-installer").setup({
					ensure_installed = ensure_installed,
				})

				require("mason-lspconfig").setup({
					handlers = {
						function(server_name)
							local server = servers[server_name] or {}
							server.capabilities = vim.tbl_deep_extend(
								"force",
								{},
								capabilities,
								server.capabilities or {}
							)
							require("lspconfig")[server_name].setup(server)
						end,
					},
				})
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			commit = "42fc28b",
			build = ":TSUpdate",
			main = "nvim-treesitter.configs",
			dependencies = {
				"nvim-treesitter/playground",
			},
			opts = {
				indent = { enable = true },
				highlight = {
					enable = true,
					use_languagetree = true,
					additional_vim_regex_highlighting = false,
				},
				auto_installed = true,
				folds = { enable = true },
				ensure_installed = {
					"comment",
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
		{
			"rcarriga/nvim-notify",
			opts = {
				level = 2,
				max_height = function()
					return math.floor(vim.o.lines * 0.35)
				end,
				max_width = function()
					return math.floor(vim.o.columns * 0.35)
				end,
				render = "compact",
				stages = "fade", -- "fade_in_slide_out", "fade", "slide", "static"
				timeout = 1500,
				top_down = false,
				icons = {
					ERROR = "",
					WARN = "",
					INFO = "",
					DEBUG = "",
					TRACE = "✎",
				},
				-- highlight = {
				--   ERROR = "NotifyERRORBody",
				--   WARN = "NotifyWARNBody",
				--   INFO = "NotifyINFOBody",
				--   DEBUG = "NotifyDEBUGBody",
				--   TRACE = "NotifyTRACEBody",
				-- },
				background_colour = "#000000",
				minimum_width = 10,
			},
			keys = {
				{
					"<leader>un",
					function()
						require("notify").dismiss({
							silent = true,
							pending = true,
						})
					end,
					desc = "Dismiss All Notifications",
				},
			},
			init = function()
				-- Set as default notification handler
				vim.notify = require("notify")
			end,
		},
		{
			"utilyre/barbecue.nvim",
			name = "barbecue",
			version = "*",
			opts = {
				attach_navic = true,
				modifiers = {
					dirname = ":~:.",
					basename = "",
				},
				show_dirname = false,
				show_path = false,
				show_filename = true,
				show_context = true,
				show_modified = true,
				context_follow_cursor = true,
				symbols = {
					modified = "●",
					unnamed = "[No Name]",
				},
			},
			dependencies = {
				"SmiteshP/nvim-navic",
				"nvim-tree/nvim-web-devicons",
			},
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			event = "BufReadPost",
			config = function()
				require("treesitter-context").setup({
					enable = true,
					max_lines = 0,
					min_window_height = 0,
					line_numbers = false,
					mode = "cursor",
				})
			end,
		},
		{
			"kdheepak/lazygit.nvim",
			lazy = true,
			cmd = {
				"LazyGit",
				"LazyGitConfig",
				"LazyGitCurrentFile",
				"LazyGitFilter",
				"LazyGitFilterCurrentFile",
			},
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			keys = {
				{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
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
		-- {
		-- 	"3rd/image.nvim",
		-- 	build = false,
		-- 	opts = {
		-- 		processor = "magick_cli",
		-- 	},
		-- },
	})
end

return main
