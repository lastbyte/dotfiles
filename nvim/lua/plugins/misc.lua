return {
	{
		"folke/which-key.nvim",
		config = function()
			-- Leave empty to use the default settings
			require("which-key").setup({})

			-- Optional manual keymap to search your current buffer's active maps
			vim.keymap.set("n", "<leader>?", function()
				require("which-key").show({ global = false })
			end, { desc = "Buffer Local Keymaps (which-key)" })
		end,
	},
	{
		"numtostr/comment.nvim",
		config = function()
			require("Comment").setup()
			-- Normal mode: Toggle current line
			vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })

			-- Visual mode: Toggle selection
			vim.keymap.set("v", "<leader>/", "gc", { remap = true, desc = "Toggle comment" })
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		config = function()
			require("lazygit")

			vim.keymap.set("n", "<leader>gg", "<Esc>:LazyGit<CR>", { desc = "open lazygit interface" })
		end,
	},
}
