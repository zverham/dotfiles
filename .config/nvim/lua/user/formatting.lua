vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]


-- toggle lsp autoformat
vim.api.nvim_create_user_command('Format', 'let b:format=1', {})
vim.api.nvim_create_user_command('NoFormat', 'let b:format=0', {})
