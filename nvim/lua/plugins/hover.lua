return {
	"lewis6991/hover.nvim",
	event = "VeryLazy",
	config = function()
		require("hover").setup({
			init = function()
				-- Require the built-in providers you want to use
				require("hover.providers.lsp")
				require("hover.providers.gh")
				require("hover.providers.gh_user")
				require("hover.providers.diagnostic")
				require("hover.providers.man")
				require("hover.providers.dictionary")
			end,
			preview_opts = {
				border = "rounded",
			},
			preview_window = false,
			title = true,
		})

		-- Context-aware Keymaps (Fixed: passing {} options prevents nil index errors)
		vim.keymap.set("n", "K", function()
			require("hover").hover({})
		end, { desc = "hover.nvim" })
		vim.keymap.set("n", "gK", function()
			require("hover").hover_select({})
		end, { desc = "hover.nvim (select)" })

		-- -- Mouse support
		-- vim.keymap.set("n", "<MouseMove>", function()
		-- 	require("hover").mouse({})
		-- end, { desc = "hover.nvim (mouse)" })
		-- vim.o.mousemoveevent = true -- Required by Neovim to detect mouse movement
	end,
}
