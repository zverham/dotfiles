-- settings

-- basics
vim.o.encoding = 'utf-8'
vim.o.backup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath('data') .. 'undo'
vim.o.undolevels = 1000
vim.o.undoreload = 10000
vim.o.updatetime = 250
vim.o.ttimeoutlen = 0
vim.o.shell = '/bin/bash -i'


-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.wrap = true
vim.o.autoindent = true
vim.o.shiftwidth = 2
vim.o.shiftround = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- plugins
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

local ok, packer = pcall(require, "packer")
if not ok then	        
  return
end

packer.init({		  
  display = {
    open_fn = function()
      return require('packer.util').float()
    end
  }
})

packer.startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- Parsing library
  use 'nvim-treesitter/nvim-treesitter'
  
  -- Language server protocol: ide-like behavior
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'

  -- Adds indentation guides to all lines (including empty lines)
  use 'lukas-reineke/indent-blankline.nvim'

  -- Atom-like theme
  use 'joshdick/onedark.vim'

  -- Git decorations 
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  -- Heuristically set shiftwidth / expandtab parameters for buffer
  use 'tpope/vim-sleuth' 

  -- Autocomplete
  use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp' } }               

  -- Search
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
      }
    }
  }

  -- Statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- File explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    }
  }

  if is_bootstrap then
    packer.sync()
  end
end)

if is_boostrap then 
  print 'Plugins being installed. Wait for Packer to complete, then restart nvim.'
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})



vim.o.termguicolors = true
vim.cmd [[colorscheme onedark]]



require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    sections_separators = ''
  }
}

local ok, telescope = pcall(require, 'telescope')
if not ok then
  return
end

telescope.load_extension('fzf')

require('nvim-tree').setup()

vim.keymap.set('n', '<Leader>t', ':NvimTreeToggle<CR>')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>b', builtin.buffers)
vim.keymap.set('n', 'gr', builtin.lsp_references)
vim.keymap.set('n', '<C-p>', builtin.git_files)
vim.keymap.set('n', '<leader>F', builtin.live_grep)
vim.keymap.set('n', '<leader>m', builtin.marks)


require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}


require('nvim-treesitter.configs').setup {
-- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'lua', 'javascript', 'go', 'python' },
  highlight = { enable = true },
  indent = { enable = true },
}


-- Enable the following language servers
local servers = { 'pyright', 'sumneko_lua', 'gopls' }

require('nvim-lsp-installer').setup {
  ensure_installed = servers,
}
