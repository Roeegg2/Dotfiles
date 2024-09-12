call plug#begin()

Plug 'tpope/vim-sensible' " basic agreed upon settings
Plug 'tpope/vim-fugitive' " git commands
Plug 'github/copilot.vim' " github copilot
Plug 'nvim-lua/plenary.nvim' " dependency for telescope
Plug 'nvim-telescope/telescope.nvim' " fuzzy finder

" colorschemes
Plug 'tiagovla/tokyodark.nvim'
Plug 'zootedb0t/citruszest.nvim'
Plug 'sainnhe/sonokai'
Plug 'Tsuzat/NeoSolarized.nvim'

Plug 'nvim-tree/nvim-tree.lua' " file explorer
Plug 'numToStr/Comment.nvim' " comment shortcut plugin
Plug 'tpope/vim-obsession' " session management
Plug 'jiangmiao/auto-pairs' " inserts closing brackets and quotes automatically

Plug 'vim-airline/vim-airline' " status line
Plug 'vim-airline/vim-airline-themes' " status line themes

Plug 'neovim/nvim-lspconfig'     " LSP configurations
Plug 'hrsh7th/nvim-cmp'           " Autocompletion plugin
Plug 'hrsh7th/cmp-nvim-lsp'       " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'         " Buffer completions
Plug 'hrsh7th/cmp-path'           " Path completions
Plug 'hrsh7th/cmp-cmdline'        " Command-line completions
Plug 'hrsh7th/cmp-vsnip'          " Snippet completion
Plug 'hrsh7th/vim-vsnip'          " Snippet engine

call plug#end()

lua << EOF
	require('nvim-tree').setup()
	require('lspconfig').clangd.setup{}
	
	local telescope = require('telescope')
	local actions = require('telescope.actions')
    telescope.setup {
		pickers = {
    	    colorscheme = {
				enable_preview = true,
				ignore_builtins = true,
			},
		},
	}

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

" general settings
set mouse=a
set number
set tabstop=4
set shiftwidth=4
syntax enable
autocmd VimLeave * mksession! ~/.vim/sessions/last_session.vim

" plugin related settings
let g:airline_theme = 'term'
command! T :Telescope
colorscheme citruszest 
