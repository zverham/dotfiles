-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})



require 'user.settings'
require 'user.plugins'
require 'user.keymap'
require 'user.colorscheme'
require 'user.lualine'
require 'user.telescope'
require 'user.treesitter'
require 'user.nvim-tree'
require 'user.formatting'
require 'user.gitsigns'
require 'user.cmp'
require 'user.autopairs'
require 'user.lsp'
