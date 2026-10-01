return {
	"obsidian-nvim/obsidian.nvim",
	config = function()
		local function get_notes_path()
			-- local os_release = vim.fn.system("cat /etc/os-release")
			local os_name = vim.uv.os_uname().sysname

			if os_name == "Linux" then
				return vim.fn.expand("~/Documents/Notes")
			elseif os_name == "Windows" then
				return "/mnt/c/Users/Rad/Documents/Notes"
			elseif os_name == "Darwin" then
				return "~/Documents/shield"
			else
				error("Unsupported OS: no notes path configured")
			end
		end

		local function setup_obsidian()
			require("obsidian").setup({
				legacy_commands = false,
				workspaces = { { name = "Notes", path = get_notes_path() } },
				picker = { name = "fzf-lua" },
			})

			--  vim.keymap.set("n", "<leader>nn", function()
			--    vim.cmd("Obsidian workspace")
			--    vim.defer_fn(function()
			--      vim.cmd("Obsidian new")
			--    end, 500)
			--    end, { desc = "New note" })
			vim.keymap.set("n", "<leader>nn", ":Obsidian new ", { desc = "New note" })
			vim.keymap.set("n", "<leader>nf", "<cmd>Obsidian quick_switch<cr>", { desc = "Find note" })
			vim.keymap.set("n", "<leader>ns", "<cmd>Obsidian search<cr>", { desc = "Search notes" })
			vim.keymap.set("n", "<leader>nt", "<cmd>Obsidian today<cr>", { desc = "Today's daily note" })
			vim.keymap.set("n", "<leader>nw", "<cmd>Obsidian workspace<cr>", { desc = "Switch workspace" })
		end

		-- setup_obsidian()
	end,
}
