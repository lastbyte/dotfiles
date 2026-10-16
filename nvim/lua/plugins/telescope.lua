return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- optional but recommended
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-u>"] = false,
						["<C-d>"] = require("telescope.actions").preview_scrolling_down,
					},
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		-- Load fzf extension if installed
		pcall(telescope.load_extension, "fzf")

		vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits of the repository" })
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files in the cwd" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "live grep in the cwd" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find all the active buffers" })
		vim.keymap.set("n", "<leader>tt", ":Telescope<CR>", { desc = "trigger the telescope finder" })
	end,
}
