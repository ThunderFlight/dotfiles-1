-- {{{ My personal Lazy setup.

require("lazy").setup({
	spec = {
		{ import = "vktrenokh/plugin" },
	},

	defaults = {
		lazy = true,
		version = false,
	},

	install = { colorscheme = { "tokyonight" } },

	checker = { enabled = true },

  ui = {
    border = "rounded"
  },

	perfomance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- }}}
