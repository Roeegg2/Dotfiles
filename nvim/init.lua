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
        "clangd",
        "lua_ls"
      }
    })

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Using the new vim.lsp.config API (Neovim 0.11+)
    
    -- Rust
    vim.lsp.config('rust_analyzer', {
      cmd = { 'rust-analyzer' },
      root_markers = { 'Cargo.toml', 'rust-project.json' },
      capabilities = capabilities,
    })

    -- C/C++
    vim.lsp.config('clangd', {
      cmd = { 'clangd' },
      root_markers = { 'compile_commands.json', '.git' },
      capabilities = capabilities,
    })

    -- Lua
    vim.lsp.config('lua_ls', {
      cmd = { 'lua-language-server' },
      root_markers = { '.luarc.json', '.git' },
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          }
        }
      }
    })

    -- Enable the LSP servers
    vim.lsp.enable('rust_analyzer')
    vim.lsp.enable('clangd')
    vim.lsp.enable('lua_ls')

    -- LSP Keymaps
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover,       { desc = 'Hover' })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition,  { desc = 'Go to Definition' })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
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

  -- {
  --   'windwp/nvim-autopairs',
  --   event = "InsertEnter",
  --   config = true
  --   -- use opts = {} for passing setup options
  --   -- this is equivalent to setup({}) function
  -- },

  -- FZF-lua for fuzzy finding
  { "junegunn/fzf", build = "./install --bin" },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local actions = require("fzf-lua.actions")
      require("fzf-lua").setup({
        grep = {
          rg_glob = true,  -- ← ADD THIS LINE
          actions = {
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

  -- Theme
  {
    'navarasu/onedark.nvim',
    config = function()
      require('onedark').setup({
        transparent = false,
      })
    end
  },

  {
    'ellisonleao/gruvbox.nvim',
    config = function()
      require('gruvbox').setup({
        contrast = "hard", -- or "soft"
        transparent_mode = false,
      })
    end
  },

  {
    'folke/tokyonight.nvim',
    config = function()
      require('tokyonight').setup({
        transparent = false,
      })
    end
  },

  {
    'github/copilot.vim',
  },

  -- {
  --   'wakatime/vim-wakatime', lazy = false,
  -- },

  {
    'Piotr1215/typeit.nvim',
    config = function()
        require('typeit').setup({
          default_speed = 30,    -- Default typing speed (milliseconds)
          default_pause = 'line' -- Default pause behavior ('line' or 'paragraph')
            -- Your configuration here
        })
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
vim.cmd("colorscheme onedark")
vim.cmd("command! FF Fzf")

vim.keymap.set("n", "<c-P>", require("fzf-lua").files, { desc = "Fzf Files" })
vim.keymap.set("n", "<c-L>", require("fzf-lua").live_grep, { desc = "Fzf Live Global Grep" })
vim.keymap.set("n", "<c-B>", require("fzf-lua").buffers, { desc = "Fzf Buffers" })

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.api.nvim_create_user_command('ReplaceWord', function(opts)
  -- Ensure we have exactly two arguments
  if #opts.fargs ~= 2 then
    vim.notify('ReplaceWord requires exactly two arguments: oldword newword', vim.log.levels.ERROR)
    return
  end

  local old = opts.fargs[1]
  local new = opts.fargs[2]

  -- Escape special characters for the substitution
  old = vim.fn.escape(old, '/\\')
  new = vim.fn.escape(new, '/\\')

  -- Get list of Git-tracked files
  local files = vim.fn.systemlist('git ls-files 2>/dev/null')
  if vim.v.shell_error ~= 0 then
    vim.notify('Error: Not in a Git repository or git ls-files failed', vim.log.levels.ERROR)
    return
  end

  if #files == 0 then
    vim.notify('No files found in Git repository', vim.log.levels.WARN)
    return
  end

  -- Iterate over files
  for _, file in ipairs(files) do
    -- Ensure file exists and is readable
    if vim.fn.filereadable(file) == 1 then
      pcall(function()
        vim.cmd('edit +0 ' .. vim.fn.fnameescape(file))
        vim.cmd('silent! %s/' .. old .. '/' .. new .. '/g')
        vim.cmd('update')
      end)
    end
  end
  vim.notify('Replacement complete in Git-tracked files', vim.log.levels.INFO)
end, { nargs = '+' })
