local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		--vim.o.runtimepath = vim.fn.stdpath "data" .. "/site/pack/*/start/*," .. vim.o.runtimepath
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use("nvim-lua/plenary.nvim") -- don't forget to add this one if you don't have it yet!
	use({
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	use({
		"nvim-telescope/telescope.nvim", --, tag = '0.1.1', -- , branch = '0.1.x',
		branch = "master",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	})
	require("telescope").load_extension("fzf")

	-- use({ 'rose-pine/neovim', as = 'rose-pine' })
	-- vim.cmd('colorscheme rose-pine')
	use({ "sainnhe/gruvbox-material", as = "gruvbox-material" })
	vim.cmd("colorscheme gruvbox-material")

	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("nvim-treesitter/playground")
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})

	use("mbbill/undotree")

	-- use('tpope/vim-fugitive')

	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{
				-- Optional
				"williamboman/mason.nvim",
				run = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "L3MON4D3/LuaSnip" }, -- Required
		},
	})

	-- use 'hrsh7th/cmp-nvim-lsp-signature-help'
	-- use 'ray-x/lsp_signature.nvim'
	use({ "Issafalcon/lsp-overloads.nvim" })

	use({
		"Pocco81/auto-save.nvim",
		config = function()
			require("auto-save").setup({
				-- your config goes here
				-- or just leave it empty :)
			})
		end,
	})

	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
	})

	-- use {
	--     'phaazon/hop.nvim',
	--     branch = 'v2', -- optional but strongly recommended
	--     config = function()
	--         -- you can configure Hop the way you like here; see :h hop-config
	--         require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
	--     end
	-- }
	use({
		"ggandor/leap.nvim",
		requires = {
			"tpope/vim-repeat",
		},
	})

	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})
	-- use({'mhinz/vim-signify',
	--     config = function()
	--         require("vim-signify").setup({
	--             update_time = 100
	--         })
	--     end
	-- })
	use("voldikss/vim-floaterm")
	if packer_bootstrap then
		require("packer").sync()
	end

	use({
		"lewis6991/gitsigns.nvim",
		-- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
	})

	-- use {
	--     "windwp/nvim-autopairs",
	--     config = function() require("nvim-autopairs").setup {} end
	-- }
	use({
		"altermo/ultimate-autopair.nvim",
		-- event = { "InsertEnter", "CmdlineEnter" },
		branch = "v0.6", --recomended as each new version will have breaking changes
		config = function()
			require("ultimate-autopair").setup({
				--Config goes here
			})
		end,
	})

	-- install without yarn or npm
	use({
		"wzf03/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})

	-- use({
	--     "iamcco/markdown-preview.nvim",
	--     run = "cd app && npm install",
	--     setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
	--     ft = { "markdown" },
	-- })

	-- use("petertriho/nvim-scrollbar")

	use("kevinhwang91/nvim-hlslens")

	use("mfussenegger/nvim-dap")
	use("mfussenegger/nvim-dap-python")
	use({ "nvim-neotest/nvim-nio" })
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	use("theHamsta/nvim-dap-virtual-text")
	use("JRasmusBm/telescope-dap.nvim")

	use({
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})

	use({
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
		},
	})
	use("nvim-neotest/neotest-python")

	use("folke/neodev.nvim")

	use({
		"andythigpen/nvim-coverage",
		requires = "nvim-lua/plenary.nvim",
		-- Optional: needed for PHP when using the cobertura parser
		-- rocks = { 'lua-xmlreader' },
		config = function()
			require("coverage").setup()
		end,
	})

	use("mfussenegger/nvim-jdtls")

	use("crhf/symbols-outline.nvim")

	-- use "m4xshen/hardtime.nvim"

	use({
		"cameron-wags/rainbow_csv.nvim",
		config = function()
			require("rainbow_csv").setup()
		end,
		-- optional lazy-loading below
		module = {
			"rainbow_csv",
			"rainbow_csv.fns",
		},
		ft = {
			"csv",
			"tsv",
			"csv_semicolon",
			"csv_whitespace",
			"csv_pipe",
			"rfc_csv",
			"rfc_semicolon",
		},
	})

	-- use({
	-- 	"nvim-lualine/lualine.nvim",
	-- 	requires = { "nvim-tree/nvim-web-devicons", opt = true },
	-- })

	use({
		"windwp/windline.nvim",
		config = function()
			require("wlsample.airline")
		end,
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})

	use({
		"utilyre/barbecue.nvim",
		tag = "*",
		requires = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		after = "nvim-web-devicons", -- keep this if you're using NvChad
		config = function()
			require("barbecue").setup({
				attach_navic = false,
			})
		end,
	})

	use("lukas-reineke/indent-blankline.nvim")
	--
	-- use {
	--     "Shatur/neovim-session-manager",
	--     requires = { { 'nvim-lua/plenary.nvim' } }
	-- }
	use({
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
			})
		end,
	})

	use({
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		-- tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!:).
		run = "make install_jsregexp",
	})
	use({ "saadparwaiz1/cmp_luasnip" })
	use("rafamadriz/friendly-snippets")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")

	-- use "dhruvasagar/vim-zoom"

	-- use "Hoffs/omnisharp-extended-lsp.nvim"

	use({
		"Zeioth/compiler.nvim",
		requires = {
			{
				"stevearc/overseer.nvim",
				commit = "19aac0426710c8fc0510e54b7a6466a03a1a7377",
				config = function()
					require("overseer").setup({
						task_list = {
							direction = "bottom",
							min_height = 25,
							max_height = 25,
							default_detail = 1,
							bindings = {
								["q"] = function()
									vim.cmd("OverseerClose")
								end,
							},
						},
					})
				end,
			},
		},
		config = function()
			require("compiler").setup()

			-- Open compiler
			vim.keymap.set("n", "<F6>", "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })
			--
			-- -- Redo last selected option
			vim.keymap.set("n", "<S-F6>", function()
				vim.cmd("CompilerStop") -- (Optional, to dispose all tasks before redo)
				vim.cmd("CompilerRedo")
			end, { noremap = true, silent = true })
			--
			-- -- Toggle compiler results
			vim.keymap.set("n", "<S-F7>", "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })
		end,
	})

	use({
		"monkoose/matchparen.nvim",
		config = function()
			require("matchparen").setup()
		end,
	})

	-- use({
	-- 	"RRethy/vim-illuminate",
	-- 	config = function()
	-- 		require("illuminate").configure({
	-- 			-- providers: provider used to get references in the buffer, ordered by priority
	-- 			providers = {
	-- 				"lsp",
	-- 				"treesitter",
	-- 				"regex",
	-- 			},
	-- 			-- delay: delay in milliseconds
	-- 			delay = 100,
	-- 			-- filetype_overrides: filetype specific overrides.
	-- 			-- The keys are strings to represent the filetype while the values are tables that
	-- 			-- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
	-- 			filetype_overrides = {},
	-- 			-- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
	-- 			filetypes_denylist = {
	-- 				"dirvish",
	-- 				"fugitive",
	-- 				"NvimTree",
	-- 				"harpoon",
	-- 				"telescope",
	-- 				"TelescopePrompt",
	-- 			},
	-- 			-- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
	-- 			filetypes_allowlist = {},
	-- 			-- modes_denylist: modes to not illuminate, this overrides modes_allowlist
	-- 			-- See `:help mode()` for possible values
	-- 			modes_denylist = {},
	-- 			-- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
	-- 			-- See `:help mode()` for possible values
	-- 			modes_allowlist = {},
	-- 			-- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
	-- 			-- Only applies to the 'regex' provider
	-- 			-- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
	-- 			providers_regex_syntax_denylist = {},
	-- 			-- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
	-- 			-- Only applies to the 'regex' provider
	-- 			-- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
	-- 			providers_regex_syntax_allowlist = {},
	-- 			-- under_cursor: whether or not to illuminate under the cursor
	-- 			under_cursor = true,
	-- 			-- large_file_cutoff: number of lines at which to use large_file_config
	-- 			-- The `under_cursor` option is disabled when this cutoff is hit
	-- 			large_file_cutoff = nil,
	-- 			-- large_file_config: config to use for large files (based on large_file_cutoff).
	-- 			-- Supports the same keys passed to .configure
	-- 			-- If nil, vim-illuminate will be disabled for large files.
	-- 			large_file_overrides = nil,
	-- 			-- min_count_to_highlight: minimum number of matches required to perform highlighting
	-- 			min_count_to_highlight = 1,
	-- 		})
	-- 	end,
	-- })

	use({
		"Weissle/persistent-breakpoints.nvim",
		config = function()
			require("persistent-breakpoints").setup({
				load_breakpoints_event = { "BufReadPost" },
			})
		end,
	})

	-- Lua
	-- use {
	--     "ahmedkhalf/project.nvim",
	--     config = function()
	--         require("project_nvim").setup({
	--             -- Manual mode doesn't automatically change your root directory, so you have
	--             -- the option to manually do so using `:ProjectRoot` command.
	--             manual_mode = true,
	--
	--             -- Methods of detecting the root directory. **"lsp"** uses the native neovim
	--             -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
	--             -- order matters: if one is not detected, the other is used as fallback. You
	--             -- can also delete or rearangne the detection methods.
	--             detection_methods = { "pattern" },
	--
	--             -- All the patterns used to detect root dir, when **"pattern"** is in
	--             -- detection_methods
	--             patterns = {
	--                 ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json",
	--                 'mvnw',
	--                 'gradlew',
	--                 'pom.xml',
	--                 'build.gradle',
	--                 'pyproject.toml',
	--                 'setup.py',
	--                 'setup.cfg',
	--                 'requirements.txt',
	--                 'Pipfile',
	--                 'pyrightconfig.json',
	--             },
	--
	--             -- Table of lsp clients to ignore by name
	--             -- eg: { "efm", ... }
	--             ignore_lsp = {},
	--
	--             -- Don't calculate root dir on specific directories
	--             -- Ex: { "~/.cargo/*", ... }
	--             exclude_dirs = {},
	--
	--             -- Show hidden files in telescope
	--             show_hidden = false,
	--
	--             -- When set to false, you will get a message when project.nvim changes your
	--             -- directory.
	--             silent_chdir = false,
	--
	--             -- What scope to change the directory, valid options are
	--             -- * global (default)
	--             -- * tab
	--             -- * win
	--             scope_chdir = 'global',
	--
	--             -- Path where project.nvim will store the project history for use in
	--             -- telescope
	--             datapath = vim.fn.stdpath("data"),
	--         })
	--     end
	-- }
	--
	use("AndrewRadev/linediff.vim")

	use("WhoIsSethDaniel/mason-tool-installer.nvim")

	use({
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup()
		end,
	})

	use("tpope/vim-fugitive")

	use("echasnovski/mini.files")

	use({
		"nvim-telescope/telescope-file-browser.nvim",
		requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	})

	-- use({ "codota/tabnine-nvim", run = "./dl_binaries.sh" })

	use({
		"danymat/neogen",
		config = function()
			require("neogen").setup({})
		end,
		requires = "nvim-treesitter/nvim-treesitter",
		-- Uncomment next line if you want to follow only stable versions
		-- tag = "*"
	})

	use({ "yioneko/nvim-yati", tag = "*", requires = "nvim-treesitter/nvim-treesitter" })

	use("lambdalisue/fern.vim")

	-- use({
	-- 	"stevearc/oil.nvim",
	-- 	config = function()
	-- 		require("oil").setup()
	-- 	end,
	-- })

	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
	})

	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	})

	-- use({
	-- 	"folke/trouble.nvim",
	-- 	requires = {
	-- 		"nvim-tree/nvim-web-devicons",
	-- 	},
	-- })
	--

	use("chaoren/vim-wordmotion")

	use({
		"python-rope/ropevim",
		ft = "python",
	})

	use({
		"dense-analysis/ale",
        ft="python",
		config = function()
			local g = vim.g

			g.ale_linters = {
				python = { "pylsp" },
			}

			g.ale_python_pylsp_use_global = 1

			g.ale_python_pylsp_config = {
				pylsp = {
					plugins = {
						rope_completion = {
							enabled = true,
						},
                        rope_autoimport = {
                            enabled = true
                        }
					},
				},
			}

			g.ale_hover_cursor = 0

            g.ale_fixers = {"autoimport"}

			vim.keymap.set({ "n", "v" }, "<leader>at", "<cmd>ALECodeAction<CR>", {desc = "ALECodeAction"})
			vim.keymap.set({ "n", "v" }, "<leader>af", "<cmd>ALEFix<CR>", {desc = "ALEFix"})
		end,
	})
end)

-- cffooze
