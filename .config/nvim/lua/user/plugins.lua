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

	-- Autopairs
	use 'LunarWatcher/auto-pairs'

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

	-- git integration
	use 'tpope/vim-fugitive'

	-- Search
	use {
		'nvim-telescope/telescope.nvim',
		requires = {
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				run = 'make',
			},
			'BurntSushi/ripgrep'
		}
	}


	use {
		"quarto-dev/quarto-vim",
		requires = {
			{ "vim-pandoc/vim-pandoc-syntax" },
		},
		ft = { "quarto" },
	}

	use {
		'hrsh7th/nvim-cmp',
		requires = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-emoji',
			'dcampos/nvim-snippy',
			'dcampos/cmp-snippy',
		},
	}

	use 'hrsh7th/cmp-nvim-lsp-signature-help'

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

if is_bootstrap then
	print 'Plugins being installed. Wait for Packer to complete, then restart nvim.'
	return
end
