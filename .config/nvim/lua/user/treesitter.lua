local ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not ok then
	return
end


treesitter.setup({
	ensure_installed = { 'bash', 'json', 'vim', 'lua', 'javascript', 'go', 'python', 'markdown', 'yaml' },
	highlight = { enable = true },
	indent = { enable = true }
})
