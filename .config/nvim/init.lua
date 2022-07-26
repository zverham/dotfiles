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


vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]


-- toggle lsp autoformat
vim.api.nvim_create_user_command('Format', 'let b:format=1', {})
vim.api.nvim_create_user_command('NoFormat', 'let b:format=0', {})

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
  ensure_installed = { 'lua', 'javascript', 'go', 'python', 'markdown', 'yaml' },
  highlight = { enable = true },
  indent = { enable = true },
}


-- autopairs

vim.g.AutoPairsCompatibleMaps = 0
vim.g.AutoPairsMapBS = 1
vim.g.AutoPairsMultilineBackspace = 1
vim.g.AutoPairsFiletypeBlacklist = { 'TelescopePrompt' }

-- https://github.com/LunarWatcher/auto-pairs/issues/34
local au = vim.api.nvim_create_augroup('autopairs', { clear = true })
vim.api.nvim_create_autocmd('Filetype', {
  pattern = 'TelescopePrompt',
  group = au,
  callback = function() vim.b.autopairs_enabled = false end
})

-- cmp

local ok, cmp = pcall(require, 'cmp')
if not ok then
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

local ok, snippy = pcall(require, 'snippy')
if not ok then
  return
end

local ok, cmp_buffer = pcall(require, 'cmp_buffer')
if not ok then
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


-- Enable the following language servers
local servers = { 'pyright', 'sumneko_lua', 'gopls' }

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
