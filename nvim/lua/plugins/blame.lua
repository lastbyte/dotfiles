return {
	{
		"FabijanZulj/blame.nvim",
		lazy = false,
		opts = {
			date_format = "%d.%m.%Y",
			virtual_style = "right_align",
		},
		keys = {
			{ "<leader>gb", "<cmd>BlameToggle<CR>", desc = "Toggle Git Blame" },
			-- Optional: add another shortcut for the virtual text view
			{ "<leader>gv", "<cmd>BlameToggle virtual<CR>", desc = "Toggle Git Blame (Virtual)" },
		},
	},
}
