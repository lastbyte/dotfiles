return {
	"nvim-java/nvim-java",
	config = function()
		require("java").setup({
			jdtls = {
				-- Tells nvim-java to use Homebrew's jdtls and skip the download
				path = "/opt/homebrew/opt/jdtls/libexec",
			},
		})
		vim.lsp.enable("jdtls")
	end,
}
