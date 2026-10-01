return {
	"ibhagwan/fzf-lua",
	config = function()
		require("fzf-lua").setup({})

		vim.keymap.set("n", "<leader>ff", function()
			require("fzf-lua").files()
		end, { desc = "FZF Files" })
		vim.keymap.set("n", "<leader>fg", function()
			require("fzf-lua").live_grep()
		end, { desc = "FZF Live Grep" })
		vim.keymap.set("n", "<leader>fb", function()
			require("fzf-lua").buffers()
		end, { desc = "FZF Buffers" })
		vim.keymap.set("n", "<leader>fh", function()
			require("fzf-lua").help_tags()
		end, { desc = "FZF Help Tags" })
		vim.keymap.set("n", "<leader>fx", function()
			require("fzf-lua").diagnostics_document()
		end, { desc = "FZF Diagnostics Document" })
		vim.keymap.set("n", "<leader>fX", function()
			require("fzf-lua").diagnostics_workspace()
		end, { desc = "FZF Diagnostics Workspace" })

		vim.keymap.set("n", "<leader>cd", function()
			-- Get current line and buffer number
			local line = vim.api.nvim_win_get_cursor(0)[1] - 1
			local bufnr = vim.api.nvim_get_current_buf()
			-- Fetch diagnostics for the current line
			local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
			if vim.tbl_isempty(diagnostics) then
				vim.notify("No diagnostics found on this line.", vim.log.levels.INFO)
				return
			end
			-- Extract and combine message strings
			local messages = {}
			for _, d in ipairs(diagnostics) do
				table.insert(messages, d.message)
			end
			local result = table.concat(messages, "\n")
			-- Copy to system clipboard
			vim.fn.setreg("+", result)
			vim.fn.setreg("*", result)
			vim.notify("Copied line diagnostics to clipboard!", vim.log.levels.INFO)
		end, { desc = "Copy line diagnostics to clipboard" })
	end,
}
