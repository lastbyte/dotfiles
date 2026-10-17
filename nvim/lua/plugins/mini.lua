return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.ai").setup({})
		require("mini.comment").setup({})
		require("mini.move").setup({})
		require("mini.surround").setup({
			mappings = {
				add = "<leader>sa", -- Add surrounding in Normal and Visual modes
				delete = "<leader>sd", -- Delete surrounding
				find = "<leader>sf", -- Find surrounding (to the right)
				find_left = "<leader>sF", -- Find surrounding (to the left)
				highlight = "<leader>sh", -- Highlight surrounding
				replace = "<leader>sr", -- Replace surrounding

				suffix_last = "<leader>l", -- Suffix to search with "prev" method
				suffix_next = "<leader>n", -- Suffix to search with "next" method
			},
		})
		require("mini.cursorword").setup({})
		require("mini.indentscope").setup({})
		require("mini.pairs").setup({})
		require("mini.trailspace").setup({})
		require("mini.bufremove").setup({})
		require("mini.notify").setup({
			lsp_progress = { enable = false },
		})
		require("mini.icons").setup({})

		require("mini.diff").setup({
			view = {
				style = "sign",
				signs = { add = "▎", change = "▎", delete = "▎" },
			},
		})

		require("mini.git").setup({})

		local MiniDiff = require("mini.diff")
		vim.keymap.set("n", "]h", function()
			MiniDiff.goto_hunk("next")
		end, { desc = "Next git hunk" })
		vim.keymap.set("n", "[h", function()
			MiniDiff.goto_hunk("prev")
		end, { desc = "Prev git hunk" })
		vim.keymap.set("n", "<leader>hs", MiniDiff.operator, { desc = "Stage hunk" })
		vim.keymap.set("n", "<leader>hp", function()
			MiniDiff.toggle_overlay()
		end, { desc = "Preview diff overlay" })
		vim.keymap.set("n", "<leader>hb", function()
			require("mini.git").show_at_cursor()
		end, { desc = "Git blame/show" })
	end,
}
