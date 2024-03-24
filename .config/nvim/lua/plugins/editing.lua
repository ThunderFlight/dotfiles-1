Is_Enabled = require("config.functions").is_enabled

return {
	-- {{{ bullets.nvim

	{
		"dkarter/bullets.vim",
		ft = "markdown",
		enabled = Is_Enabled("bullets.vim"),
	},

	-- ----------------------------------------------------------------------- }}}
	-- {{{ Comment.nvim
	{
		"echasnovski/mini.comment",
		event = { "BufReadPost", "BufNewFile" },
		enabled = Is_Enabled("comment.nvim"),
		opts = {
			options = {
				-- Function to compute custom 'commentstring' (optional)
				custom_commentstring = nil,

				-- Whether to ignore blank lines
				ignore_blank_line = false,

				-- Whether to recognize as comment only lines without indent
				start_of_line = false,

				-- Whether to ensure single space pad for comment parts
				pad_comment_parts = true,
			},

			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				-- Toggle comment (like `gcip` - comment inner paragraph) for both
				-- Normal and Visual modes
				comment = "gc",

				-- Toggle comment on current line
				comment_line = "gcc",

				-- Toggle comment on visual selection
				comment_visual = "gc",

				-- Define 'comment' textobject (like `dgc` - delete whole comment block)
				-- Works also in Visual mode if mapping differs from `comment_visual`
				textobject = "gc",
			},
		},
	},
	-- ----------------------------------------------------------------------- }}}
	-- {{{ nvim-autopairs
	{
		"echasnovski/mini.pairs",
		event = { "BufReadPost", "BufNewFile" },
		enabled = Is_Enabled("mini.pairs"),
		opts = {},
		keys = {
			{
				"<leader>up",
				function()
					local Util = require("lazy.core.util")
					vim.g.minipairs_disable = not vim.g.minipairs_disable
					if vim.g.minipairs_disable then
						Util.warn("Disabled auto pairs", { title = "Option" })
					else
						Util.info("Enabled auto pairs", { title = "Option" })
					end
				end,
				desc = "Toggle auto pairs",
			},
		},
	},
	-- ----------------------------------------------------------------------- }}}
	-- {{{ flash.nvim
	{
		"folke/flash.nvim",
		keys = {
			{
				"<leader>/",
				function()
					(require("flash")).jump()
				end,
				mode = { "n", "x", "o" },
			},
		},
		opts = {
			lables = "asdfghjklqwertyuiopzxcvbnm",
			modes = {
				char = { enabled = false },
				search = {
					enabled = true,
					search = {
						enabled = true,
						incremental = true,
					},
				},
				treesitter = { enabled = false },
			},
			label = {
				uppercase = false,
				rainbow = { enalbed = false, shade = 5 },
				after = false,
				before = true,
				style = "inline",
			},
		},
		config = true,
		enabled = Is_Enabled("flash.nvim"),
	},
	-- }}}
	-- {{{ mini.surround
	{
		"echasnovski/mini.surround",
		keys = {
			{ "sa", mode = { "n", "x", "v" } }, -- Add surrounding in Normal and Visual modes
			{ "sd", mode = { "n", "x", "v" } }, -- Delete surrounding
			{ "sh", mode = { "n", "x", "v" } }, -- Highlight surrounding
			{ "sr", mode = { "n", "x", "v" } }, -- Replace surrounding
			{ "sn", mode = { "n", "x", "v" } }, -- Update `n_lines`
		},
		opts = {
			{
				-- Add custom surroundings to be used on top of builtin ones. For more
				-- information with examples, see `:h MiniSurround.config`.
				custom_surroundings = nil,

				-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
				highlight_duration = 500,

				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					add = "sa", -- Add surrounding in Normal and Visual modes
					delete = "sd", -- Delete surrounding
					highlight = "sh", -- Highlight surrounding
					replace = "sr", -- Replace surrounding
					update_n_lines = "sn", -- Update `n_lines`
					find = "su", -- Find surrounding (to the right)
					find_left = "sU", -- Find surrounding (to the left)

					suffix_last = "l", -- Suffix to search with "prev" method
					suffix_next = "n", -- Suffix to search with "next" method
				},

				-- Number of lines within which surrounding is searched
				n_lines = 20,

				-- Whether to respect selection type:
				-- - Place surroundings on separate lines in linewise mode.
				-- - Place surroundings on each line in blockwise mode.
				respect_selection_type = false,

				-- How to search for surrounding (first inside current line, then inside
				-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
				-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
				-- see `:h MiniSurround.config`.
				search_method = "cover",

				-- Whether to disable showing non-error feedback
				silent = false,
			},
		},
		config = true,
		enabled = Is_Enabled("mini-surround"),
	},
	-- }}}
	{ -- {{{ refactoring.nvim
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{
				"<leader>rn",
				function()
					require("refactoring").select_refactor({
						show_success_message = true,
					})
				end,
				mode = "v",
				noremap = true,
				silent = true,
				expr = false,
			},
		},
		opts = {},
		config = function(_, opts)
			require("refactoring").setup(opts)
		end,
	}, -- }}}
	-- {{{ vim-illuminate
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			delay = 200,
			large_file_cutoff = 2000,
			large_file_overrides = {
				providers = { "lsp" },
			},
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
		keys = {
			{ "]]", desc = "Next Reference" },
			{ "[[", desc = "Prev Reference" },
		},
	},
	-- }}}
	{
		"Exafunction/codeium.nvim",
		lazy = false,
		enabled = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({})
		end,
	},
}
