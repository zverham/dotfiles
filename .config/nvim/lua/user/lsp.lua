local function lsp_keymap(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
	vim.keymap.set('n', 'Rn', vim.lsp.buf.rename, opts)
end

local function lsp_format(client, bufnr)
	if client.resolved_capabilities.document_formatting then
		vim.b.format = 1
		local au = vim.api.nvim_create_augroup('lsp_doc_formatting', { clear = true })
		vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePre' }, {
			group = au,
			buffer = bufnr,
			callback = function()
				if vim.b.format == 1 then
					vim.lsp.buf.formatting()
				end
			end
		})
	end
end

vim.diagnostic.config({
	virtual_text = true,
	signs = { active = true },
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = 'minimal',
		source = 'if_many',
		header = 'a header',
		prefix = 'a prefix',
	}
})


local function lsp_diagnostics(bufnr)


	vim.api.nvim_create_autocmd("CursorHold", {
		buffer = bufnr,
		callback = function()
			local opts = {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
				border = 'rounded',
				source = 'always',
				prefix = ' ',
				scope = 'cursor',
			}
			vim.diagnostic.open_float(nil, opts)
		end
	})
end

local function lsp_on_attach(client, bufnr)
	lsp_keymap(bufnr)
	lsp_format(client, bufnr)
	lsp_diagnostics(bufnr)
end

local ok, installer = pcall(require, 'nvim-lsp-installer')
if not ok then
	return
end

installer.setup({
	ensure_installed = {
		'bashls',
		'eslint',
		'gopls',
		'jsonls',
		'pyright',
		'sumneko_lua',
		'tsserver',
		'marksman',
	},
	ui = {
		icons = {
			server_installed = "✓",
			server_pending = "➜",
			server_uninstalled = "✗"
		}
	},
})

local client_capabilities = vim.lsp.protocol.make_client_capabilities()

local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok then
	client_capabilities = cmp_lsp.update_capabilities(client_capabilities)
end


for _, server in ipairs(require 'nvim-lsp-installer'.get_installed_servers()) do
	local opts = {
		on_attach = lsp_on_attach,
		capabilities = client_capabilities
	}

	local ok, server_opts = pcall(require, "user.lsp.settings." .. server.name)
	if ok then
		opts = vim.tbl_deep_extend("force", server_opts, opts)
	end


	require('lspconfig')[server.name].setup(opts)
end
