call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'github/copilot.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'navarasu/onedark.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'numToStr/Comment.nvim'

Plug 'neovim/nvim-lspconfig'     " LSP configurations
Plug 'hrsh7th/nvim-cmp'           " Autocompletion plugin
Plug 'hrsh7th/cmp-nvim-lsp'       " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'         " Buffer completions
Plug 'hrsh7th/cmp-path'           " Path completions
Plug 'hrsh7th/cmp-cmdline'        " Command-line completions
Plug 'hrsh7th/cmp-vsnip'          " Snippet completion
Plug 'hrsh7th/vim-vsnip'          " Snippet engine

call plug#end()

set number
colorscheme onedark

lua << EOF
	require('nvim-tree').setup()
	require('lspconfig').clangd.setup{}
	
	local cmp = require('cmp')

  	cmp.setup({
    	  snippet = {
      	    expand = function(args)
              vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      	    end,
    	  },
    	mapping = {
      	  ['<Tab>'] = cmp.mapping.select_next_item(),
      	  ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
	},
    	sources = cmp.config.sources({
	  { name = 'nvim_lsp' },
      	  { name = 'vsnip' }, -- For vsnip users.
    	}, {
      	  { name = 'buffer' },
      	  { name = 'path' },
    	}),
    -- Enable auto-completion on text change
    	completion = {
      	  autocomplete = { cmp.TriggerEvent.TextChanged }
    	},
  })
EOF
