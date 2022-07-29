local ok, lualine = pcall(require, 'lualine')
if not ok then
	return
end


lualine.setup({
	options = {
		icons_enabled = false,
		theme = 'onedark',
		component_separators = '|',
		sections_separators = '',
	}
})
