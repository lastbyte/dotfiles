return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "macchiato", -- latte, frappe, macchiato, mocha
			transparent_background = true,
			integrations = {
				mini = { enabled = true },
				native_lsp = { enabled = true },
				treesitter = true,
				which_key = true,
			},

			float = {
				transparent = true,
				solid = false,
			},

			custom_highlights = function(colors)
				return {
					-- Remove the solid background entirely
					CursorLine = { bg = "none", underline = false },

					-- Optional: If you use line numbers, clear their active line bg too
					CursorLineNr = { bg = "none", fg = colors.blue, bold = true },

					FloatBorder = { bg = "none", fg = colors.surface2 },
				}
			end,
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}
