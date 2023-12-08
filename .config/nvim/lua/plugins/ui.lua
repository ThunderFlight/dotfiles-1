Customize = require("config.customize")
Icons = require("config.constants").icons
Is_Enabled = require("config.functions").is_enabled

return {
	-- {{{ alpha.nvim
	{
		"goolord/alpha-nvim",
		enabled = Is_Enabled("alpha.nvim"),
		keys = {
			{ "<leader>aa", "<cmd>Alpha<cr>" },
		},
		event = { "VimEnter", "BufReadPost", "BufNewFile" },
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			local logo = [[
       _______             ____   ____.__
       \      \   ____  ___\   \ /   /|__| _____
       /   |   \_/ __ \/  _ \   Y   / |  |/     \
      /    |    \  ___(  <_> )     /  |  |  Y Y  \
      \____|__  /\____ >____/ \___/   |__|__|_|  /
              \/                               \/
      ]]

			dashboard.section.header.val = vim.split(logo, "\n", {})
			dashboard.section.buttons.val = {
				dashboard.button("f", Icons.documents.Files .. " Find file", ":Telescope find_files <CR>"),
				dashboard.button("r", Icons.ui.History .. " Recent files", ":Telescope oldfiles <CR>"),
				dashboard.button("t", Icons.ui.List .. " Find text", ":Telescope live_grep <CR>"),
				dashboard.button("c", Icons.ui.Gear .. " Config", ":e ~/.config/nvim/init.lua | cd ~/.config/nvim<CR>"),
				dashboard.button("u", Icons.ui.CloudDownload .. " Update", ":Lazy<CR>"),
				dashboard.button("q", Icons.ui.SignOut .. " Quit", ":qa<CR>"),
			}

			for _, button in ipairs(dashboard.section.buttons.val) do
				button.opts.hl = "AlphaButtons"
				button.opts.hl_shortcut = "AlphaShortcut"
			end

			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.opts.hl = "AlphaButtons"
			dashboard.section.footer.opts.hl = "Type"
			dashboard.opts.opts.noautocmd = true
			return dashboard
		end,
		config = function(_, dashboard)
			-- close Lazy and re-open when the dashboard is ready
			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					pattern = "AlphaReady",
					callback = function()
						require("lazy").show()
					end,
				})
			end
			require("alpha").setup(dashboard.opts)

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimStarted",
				callback = function()
					local footerLogo = [[
       ⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷
       ⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇
       ⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽
       ⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕
       ⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕
       ⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕
       ⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄
       ⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕
       ⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿
       ⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
       ⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟
       ⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠
       ⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙
       ⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣
          ]]

					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = "⚡ Neovim loaded "
						.. stats.count
						.. " plugins in "
						.. ms
						.. "ms"
						.. "\n"
						.. footerLogo
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},
	-- ----------------------------------------------------------------------- }}}
	-- {{{ bufferline.nvim
	{
		"akinsho/bufferline.nvim",
		-- event = "VeryLazy",
		enabled = Is_Enabled("bufferline.nvim"),
		keys = {
			{ "te", "<cmd>:tabedit<cr>", desc = "Tabs" },
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>" },
		},
		opts = {
			options = {
				mode = "tabs",
				separator_style = "thin",
				show_buffer_close_icons = false,
				show_close_icon = false,
				color_icons = true,
				diagnostics = "nvim_lsp",
				always_show_bufferline = false,
				diagnostics_indicator = function(_, _, diag)
					local icons = Constants.icons.diagnostics
					local ret = (diag.error and icons.Error .. diag.error .. " " or "")
						.. (diag.warning and icons.Warning .. diag.warning or "")
					return vim.trim(ret)
				end,
				offsets = {
					{
						highlight = "Directory",
						text_align = "left",
					},
				},
			},
			highlights = {
				background = {
					fg = "#616161",
				},
				buffer_selected = {
					fg = "#f1f1f1",
					bold = false,
					italic = false,
				},
			},
		},
	},
	-- ----------------------------------------------------------------------- }}}
	-- {{{ dressing
	{
		"stevearc/dressing.nvim",
		enabled = Is_Enabled("dressing"),
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},

	-- ----------------------------------------------------------------------- }}}
	-- {{{ gitsigns.nvim
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		keys = {
			{ "<leader>SR", '<cmd>lua require "gitsigns".reset_hunk()<cr>' },
			{ "<leader>SS", '<cmd>lua require "gitsigns".stage_hunk()<cr>' },
			{ "<leader>Sd", "<cmd>Gitsigns diffthis HEAD<cr>" },
			{ "<leader>Sh", '<cmd>lua require "gitsigns".undo_stage_hunk()<cr>' },
			{ "<leader>Sj", '<cmd>lua require "gitsigns".next_hunk()<cr>' },
			{ "<leader>Sk", '<cmd>lua require "gitsigns".prev_hunk()<cr>' },
			{ "<leader>Sp", '<cmd>lua require "gitsigns".preview_hunk()<cr>' },
			{ "<leader>Sr", '<cmd>lua require "gitsigns".reset_buffer()<cr>' },
		},
		enabled = Is_Enabled("gitsigns.nvim"),
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			signcolumn = true,
			numhl = true,
			linehl = false,
			word_diff = false,
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 1000,
				ignore_whitespace = false,
			},
			current_line_blame_formatter_opts = {
				relative_time = false,
			},
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil,
			max_file_length = 40000,
			preview_config = {
				border = "rounded",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			yadm = {
				enable = false,
			},
		},
	},

	-- ----------------------------------------------------------------------- }}}
	-- {{{ indent-blankline.nvim
	{
		"lukas-reineke/indent-blankline.nvim",
		enabled = Is_Enabled("indent-blankline"),
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			indent = { char = "│" },
			-- filetype_exclude = { "help", "alpha", "dashboard", "Trouble", "lazy" },
			-- show_trailing_blankline_indent = false,
			--	show_current_context_start = true,
			--  use_treesitter = true,
		},

		config = function(_, opts)
			require("ibl").setup(opts)
		end,
	},
	-- ----------------------------------------------------------------------- }}}
	-- {{{ lualine.nvim
	{
		"nvim-lualine/lualine.nvim",
		-- event = { "BufReadPost", "BufNewFile" },
		event = "VeryLazy",
		enabled = Is_Enabled("lualine.nvim"),
		dependencies = {
			"stevearc/aerial.nvim",
		},
		opts = function(_, opts)
			local hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end

			local function fg(name)
				return function()
					---@type {foreground?:number}?
					local hl = vim.api.nvim_get_hl_by_name(name, true)
					return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
				end
			end

			local diagnostics = {
				"diagnostics",
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn" },
				symbols = {
					error = Icons.diagnostics.Error,
					warn = Icons.diagnostics.Warning,
					info = Icons.diagnostics.Information,
					hint = Icons.diagnostics.Hint,
				},
				colored = true,
				update_in_insert = false,
				always_visible = true,
			}

			local diff = {
				"diff",
				colored = false,
				symbols = { added = Icons.git.Add, modified = Icons.git.Mod, removed = Icons.git.Remove },
				cond = hide_in_width,
			}

			local mode = {
				"mode",
				fmt = function(str)
					return string.lower(str)
				end,
			}

			local filetype = {
				"filetype",
				icons_enabled = true,
				icon = nil,
				colored = true,
			}

			local branch = {
				"branch",
				icons_enabled = true,
				icon = Icons.git.Branch,
			}

			local location = {
				"location",
				padding = 0,
			}

			local progress = function()
				local current_line = vim.fn.line(".")
				local total_lines = vim.fn.line("$")
				local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
				local line_ratio = current_line / total_lines
				local index = math.ceil(line_ratio * #chars)
				return chars[index]
			end

			local spaces = function()
				return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
			end

			opts.options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = Icons.ui.SlashLeft, right = Icons.ui.SlashRight },
				section_separators = {
					left = Icons.ui.BigCircleSeparatorLeft,
					right = Icons.ui.BigCircleSeparatorRight,
				},
				disable_filetypes = { "dashboard", "lazy", "NvimTree", "Outline", "alpha" },
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = true,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			}

			opts.sections = {
				lualine_a = { mode },
				lualine_b = { branch },
				lualine_c = {
					{
						"filename",
						file_status = true,
						path = 0,
					},
					{ "aerial" },
				},
				lualine_x = {
					{
						function()
							return require("noice").api.status.command.get()
						end,
						cond = function()
							return package.loaded["noice"] and require("noice").api.status.command.has()
						end,
						color = fg("Statement"),
					},
					{
						function()
							return require("noice").api.status.mode.get()
						end,
						cond = function()
							return package.loaded["noice"] and require("noice").api.status.mode.has()
						end,
						color = fg("Constant"),
					},
					diagnostics,
					diff,
					spaces,
					"encoding",
					filetype,
				},
				lualine_y = { progress },
				lualine_z = { location },
			}

			opts.inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { {
					"filename",
					file_status = true,
					path = 1,
				} },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			}

			opts.tabline = {}
			opts.winbar = {}
			opts.inactive_winbar = {}
			opts.extensions = { "fugitive" }
		end,
	},
	-- ----------------------------------------------------------------------- }}}
	-- {{{ markdown-perview.nvim
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		enabled = Is_Enabled("markdown-preview.nvim"),
		config = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	-- ----------------------------------------------------------------------- }}}
	-- {{{ mini.indentscope
	{
		"echasnovski/mini.indentscope",
		enabled = Is_Enabled("mini-indentscope"),
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			draw = {
				delay = 0,
				animation = nil,
			},
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "help", "alpha", "dashboard", "Trouble", "lazy", "mason" },
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
		config = function(_, opts)
			local mis = require("mini.indentscope")
			opts.draw.animation = mis.gen_animation.none()
			mis.setup(opts)
		end,
	},
	-- ----------------------------------------------------------------------- }}}
	-- {{{ noice.nvim
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		enabled = Is_Enabled("noice.nvim"),
		opts = {
			lsp = {
				progress = {
					view = "notify",
				},
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = false,
					["cmp.entry.get_documentation"] = false,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "msg_show",
						kind = "wmsg",
					},
					opts = { skip = true },
				},
			},
			presets = {
				bottom_search = false,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = true,
			},
			cmdline_popup = {
				views = {
					row = "50%",
					col = "50%",
				},
				win_options = {
					winhighlight = "NormalFloat:NormalFloat, FloatBoarder:FloatBorder",
				},
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	-- --------------------------------------------------- }}}
	-- {{{ nui.nvim
	{
		"MunifTanjim/nui.nvim",
		enabled = Is_Enabled("nui.nvim"),
		lazy = true,
	},
	-- ----------------------------------------------------------------------- }}}
	-- {{{ nvim-colorizer
	{
		"NvChad/nvim-colorizer.lua",
		enabled = Is_Enabled("nvim-colorizer.lua"),
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			"javascript",
			"typescript",
			"css",
			"html",
		},
		config = function()
			require("colorizer").setup(opts)
		end,
	},
	-- ----------------------------------------------------------------------- }}}
	-- {{{ nvim-navic
	{
		"SmiteshP/nvim-navic",
		lazy = true,
		event = { "BufReadPost", "BufNewFile" },
		enabled = Is_Enabled("nvim-navic"),
		init = function()
			vim.g.navic_silence = true
			require("config.functions").on_attach(function(client, buffer)
				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, buffer)
					vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
				end
			end)
		end,
		opts = function()
			return {
				separator = " ",
				highlight = true,
				lazy_update_content = true,
				depth_limit = 5,
				icons = Icons.kind,
			}
		end,
	},
	-- ----------------------------------------------------------------------- }}}
	-- {{{ nvim-notify
	{
		"rcarriga/nvim-notify",
		enabled = Is_Enabled("nvim-notify"),
		opts = {
			level = 3,
			render = "wrapped-compact",
			stages = "static",
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			background_colour = "#121212",
		},
		init = function()
			-- when noice is not enabled, install notify on VeryLazy
			local Util = require("config.functions")
			if not Util.has("noice.nvim") then
				Util.on_very_lazy(function()
					-- vim.cmd([[highlight NotifyERRORBody guibg=NONE]])
					-- vim.cmd([[highlight NotifyWARNBody guibg=NONE]])
					-- vim.cmd([[highlight NotifyINFOBody guibg=NONE]])
					-- vim.cmd([[highlight NotifyDEBUGBody guibg=NONE]])
					-- vim.cmd([[highlight NotifyTRACEBody guibg=NONE]])

					vim.notify = require("notify")
				end)
			end
		end,
	},
	-- ----------------------------------------------------------------------- }}}
	-- {{{ nvim-web-devicons

	{
		"nvim-tree/nvim-web-devicons",
		enabled = Is_Enabled("nvim-web-devicons"),
		event = "VeryLazy",
		lazy = true,
		opts = {
			override = Constants.icons.web_devicons,
		},
	},

	-------------------------------------------------------------------------- }}}}
	-- {{{ popup.nvim

	{
		"nvim-lua/popup.nvim",
		event = "VimEnter",
		enabled = Is_Enabled("popup.nvim"),
	},

	-- ----------------------------------------------------------------------- }}}
	-- {{{ trouble.nvim

	{
		"folke/trouble.nvim",
		keys = {
			{ "<leader>LR", "<cmd>TroubleToggle lsp_references<cr>", desc = "open trouble with lsp references" },
			{ "<leader>Ld", "<cmd>TroubleTOggle lsp_document_symbols<cr>", desc = "open trouble with lsp symbols" },
			{ "<leader>T", "<cmd>TroubleToggle lsp_references<cr>" },
			{ "<leader>t", "<cmd>TroubleToggle workspace_diagnostics<cr>" },
			{ "<leader>Td", "<cmd>TroubleToggle<cr>" },
		},
		-- event = "VimEnter",
		enabled = Is_Enabled("trouble.nvim"),
		opts = { use_diagnostic_signs = true },
	},

	-- ----------------------------------------------------------------------- }}}
	-- {{{ virtcolumn.nvim

	{
		"xiyaowong/virtcolumn.nvim",
		event = { "BufReadPost", "BufNewFile" },
		enabled = Is_Enabled("virtcolumn.nvim"),
	},

	-- ----------------------------------------------------------------------- }}}
	-- {{{ todo-comments.nvim
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = { "BufReadPost", "BufNewFile" },
		config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { ";tb", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { ";TB", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { ";dt", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { ";dt", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
	},
	-- }}}
	-- {{{ aerial.nvim
	{
		"stevearc/aerial.nvim",
		enabled = Is_Enabled("aerial.nvim"),
		opts = {
			backends = { "treesitter", "lsp", "markdown", "man" },

			layout = {
				max_width = { 40, 0.2 },
				width = nil,
				min_width = 10,
				win_opts = {},
				default_direction = "prefer_right",
				placement = "window",
				resize_to_content = true,
				preserve_equality = false,
			},
			attach_mode = "window",
			close_automatic_events = {},
			keymaps = {
				["?"] = "actions.show_help",
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.jump",
				["<2-LeftMouse>"] = "actions.jump",
				["<C-v>"] = "actions.jump_vsplit",
				["<C-s>"] = "actions.jump_split",
				["p"] = "actions.scroll",
				["<C-j>"] = "actions.down_and_scroll",
				["<C-k>"] = "actions.up_and_scroll",
				["{"] = "actions.prev",
				["}"] = "actions.next",
				["[["] = "actions.prev_up",
				["]]"] = "actions.next_up",
				["q"] = "actions.close",
				["o"] = "actions.tree_toggle",
				["za"] = "actions.tree_toggle",
				["O"] = "actions.tree_toggle_recursive",
				["zA"] = "actions.tree_toggle_recursive",
				["l"] = "actions.tree_open",
				["zo"] = "actions.tree_open",
				["L"] = "actions.tree_open_recursive",
				["zO"] = "actions.tree_open_recursive",
				["h"] = "actions.tree_close",
				["zc"] = "actions.tree_close",
				["H"] = "actions.tree_close_recursive",
				["zC"] = "actions.tree_close_recursive",
				["zr"] = "actions.tree_increase_fold_level",
				["zR"] = "actions.tree_open_all",
				["zm"] = "actions.tree_decrease_fold_level",
				["zM"] = "actions.tree_close_all",
				["zx"] = "actions.tree_sync_folds",
				["zX"] = "actions.tree_sync_folds",
			},
			lazy_load = true,
			disable_max_lines = 10000,
			disable_max_size = 2000000, -- Default 2MB
			filter_kind = {
				"Class",
				"Constructor",
				"Enum",
				"Function",
				"Interface",
				"Module",
				"Method",
				"Struct",
			},
			highlight_mode = "split_width",
			highlight_closest = true,
			highlight_on_hover = false,
			highlight_on_jump = 300,
			autojump = false,
			icons = {},
			ignore = {
				unlisted_buffers = false,
				filetypes = {},
				buftypes = "special",
				wintypes = "special",
			},
			manage_folds = false,
			link_folds_to_tree = false,
			link_tree_to_folds = true,
			nerd_font = "auto",
			open_automatic = false,
			post_jump_cmd = "normal! zz",
			post_parse_symbol = function(bufnr, item, ctx)
				return true
			end,
			post_add_all_symbols = function(bufnr, items, ctx)
				return items
			end,
			close_on_select = false,
			update_events = "TextChanged,InsertLeave",
			show_guides = false,
			guides = {
				mid_item = "├─",
				last_item = "└─",
				nested_top = "│ ",
				whitespace = "  ",
			},

			float = {
				border = "rounded",
				relative = "cursor",
				max_height = 0.9,
				height = nil,
				min_height = { 8, 0.1 },
				override = function(conf, source_winid)
					return conf
				end,
			},

			nav = {
				border = "rounded",
				max_height = 0.9,
				min_height = { 10, 0.1 },
				max_width = 0.5,
				min_width = { 0.2, 20 },
				win_opts = {
					cursorline = true,
					winblend = 10,
				},
				autojump = false,
				preview = false,
				keymaps = {
					["<CR>"] = "actions.jump",
					["<2-LeftMouse>"] = "actions.jump",
					["<C-v>"] = "actions.jump_vsplit",
					["<C-s>"] = "actions.jump_split",
					["h"] = "actions.left",
					["l"] = "actions.right",
					["<C-c>"] = "actions.close",
				},
			},

			lsp = {
				diagnostics_trigger_update = true,
				update_when_errors = true,
				update_delay = 300,
				priority = {},
			},

			treesitter = {
				update_delay = 300,
			},

			markdown = {
				update_delay = 300,
			},

			man = {
				update_delay = 300,
			},
		},
		config = function(_, opts)
			require("aerial").setup(opts)
		end,
	},
	-- }}}
	-- {{{ incline.nvimm
	{
		"b0o/incline.nvim",
		event = { "BufEnter", "BufNewFile" },
		opts = {
			highlight = {
				groups = {
					InclineNormal = { guibg = "#ffffff" },
					InclineNormalNC = { guibg = "#ffffff" },
				},
			},
		},
		config = function(_, opts)
			require("incline").setup(opts)
		end,
		enabled = Is_Enabled("incline.nvim"),
	},
	-- }}}
}
