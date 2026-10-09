function ColorMyPencils()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

	-- Clear backgrounds for specific plugins that create floats (like Telescope or Lazy)
	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
	vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
	vim.api.nvim_set_hl(0, "LazyNormal", { bg = "none" })

	-- Optional: If your hover plugin displays custom headers or markdown
	-- block highlights, clear those fallback color layers too
	vim.api.nvim_set_hl(0, "FloatTitle", { bg = "none", ctermbg = "none" })
end

-- ColorMyPencils()
