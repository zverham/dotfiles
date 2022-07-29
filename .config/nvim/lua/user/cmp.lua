local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
	return
end

-- cr/tab to exit when there are no matches
local cmp_confirm = function(fallback)
	if cmp.visible() and cmp.get_selected_entry() then
		cmp.confirm()
	else
		fallback()
	end
end

local snippy_ok, snippy = pcall(require, 'snippy')
if not snippy_ok then
	return
end

-- nvim-cmp source for buffer words
local cmp_buffer_ok, _ = pcall(require, 'cmp_buffer')
if not cmp_buffer_ok then
	return
end

local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

cmp.setup({
	snippet = {
		expand = function(args) snippy.expand_snippet(args.body) end
	},
	mapping = cmp.mapping.preset.insert({
		['<C-d>'] = cmp.mapping.scroll_docs(-4, { 'i' }),
		['<C-f>'] = cmp.mapping.scroll_docs(4, { 'i' }),
		['<CR>'] = cmp.mapping(cmp_confirm, { 'i' }),
		['<TAB>'] = cmp.mapping(cmp_confirm, { 'i' }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp', keyword_length = 3, max_item_count = 10 },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'nvim_lua' },
		{ name = 'buffer' },
		{ name = 'path' },
		{ name = 'emoji' },
	}),
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		}
	},
	formatting = {
		fields = { 'kind', 'abbr', 'menu' },
		format = function(entry, vim_item)
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				nvim_lua = "[VIM]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	}
})
