local opts = {

	encoding = 'utf-8',
	backup = false,
	swapfile = false,
	undofile = true,
	undodir = vim.fn.stdpath('data') .. 'undo',
	undolevels = 1000,
	undoreload = 10000,
	updatetime = 250,
	ttimeoutlen = 0,
	shell = '/bin/bash -i',

	completeopt = 'menuone,noselect',
	hlsearch = false,
	number = true,
	mouse = '',
	breakindent = true,
	ignorecase = true,
	smartcase = true,

	wrap = true,
	autoindent = true,
	shiftwidth = 2,
	shiftround = true,
	tabstop = 2,
	softtabstop = 2,

	signcolumn = 'yes',

}

for k, v in pairs(opts) do
	vim.opt[k] = v
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
