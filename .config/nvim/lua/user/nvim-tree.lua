local ok, nvimtree = pcall(require, 'nvim-tree')
if not ok then
	return
end

vim.keymap.set('n', '<Leader>t', ':NvimTreeToggle<CR>')

nvimtree.setup()
