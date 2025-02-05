-- init.lua - Neovim Configuration

-- Bootstrap lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Lazy plugin setup
require("lazy").setup({
  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = {
          "rust_analyzer",
          "clangd",  -- for C/C++
          "lua_ls"   -- for Lua
        }
      })

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require('lspconfig')

      -- Rust LSP
      lspconfig.rust_analyzer.setup {
        capabilities = capabilities,
      }

      -- C/C++ LSP
      lspconfig.clangd.setup {
        capabilities = capabilities,
      }

      -- Lua LSP
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          }
        }
      }

      -- Keymaps for LSP
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
    end
  },

  -- Autocomplete
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        cmp.setup({
          mapping = cmp.mapping.preset.insert({
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
          })
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        })
      }

      -- Set up snippets
      require('luasnip.loaders.from_vscode').lazy_load()
    end
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  },

  -- FZF-lua for fuzzy finding
  { "junegunn/fzf", build = "./install --bin" },
 	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- calling `setup` is optional for customization
      local actions = require("fzf-lua.actions")
			require("fzf-lua").setup({
        grep = {
          actions = {
            -- swapping the bindings for ctrl-r so ctrl-g matches files
            ["ctrl-r"] = { actions.grep_lgrep },
            ["ctrl-g"] = { actions.toggle_ignore },
          }
        },
      })
		end,
	},

  -- File tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = { group_empty = true },
        git = { ignore = false },
      })
      vim.keymap.set('n', '<C-y>', ':NvimTreeToggle<CR>', {})
    end
  },
})

-- General Neovim Settings
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- stuff I've set up
vim.cmd("colorscheme vim")
vim.cmd("command! FF Fzf")

vim.keymap.set("n", "<c-P>", require("fzf-lua").files, { desc = "Fzf Files" })
vim.keymap.set("n", "<c-L>", require("fzf-lua").live_grep_glob, { desc = "Fzf Live Global Grep" })
vim.keymap.set("n", "<c-B>", require("fzf-lua").buffers, { desc = "Fzf Buffers" })

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
