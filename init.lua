---------------- LAZY ------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ "sindrets/diffview.nvim" },
		{ "akinsho/toggleterm.nvim" },
		{ "numToStr/Comment.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
		{ "tpope/vim-obsession" },
		{ "neovim/nvim-lspconfig" },
		{ "github/copilot.vim" },
		{ "junegunn/fzf", build = "./install --bin" },
		{
			"ibhagwan/fzf-lua",
			-- optional for icon support
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				-- calling `setup` is optional for customization
				require("fzf-lua").setup({})
			end,
		},
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
		},
		{
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-vsnip",
		},
		{
			"stevearc/conform.nvim",
			opts = {},
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
		},
		{
			"utilyre/barbecue.nvim",
			name = "barbecue",
			version = "*",
			dependencies = {
				"SmiteshP/nvim-navic",
				"nvim-tree/nvim-web-devicons", -- optional dependency
			},
			opts = {
				-- configurations go here
			},
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- automatically check for plugin updates
	checker = { enabled = true },
})

----------- PLUGINS -------------------------

require("nvim-treesitter.configs").setup({
	ensure_installed = { "cpp", "c", "go", "python", "lua", "markdown", "markdown_inline" },
})

require("toggleterm").setup({})

require("nvim-tree").setup({})

require("lspconfig").pyright.setup({})

require("lspconfig").clangd.setup({})

require("barbecue.ui").toggle(true)

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" }, -- For vsnip users.
	}, {
		{ name = "buffer" },
	}),
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		c = { "clang-format" },
		cpp = { "clang-format" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

require("nvim-web-devicons").setup({})

require("Comment").setup()

require("barbecue.ui").toggle(true)

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "gruvbox-material",
	},
})

local actions = require("diffview.actions")

require("diffview").setup({})

----------- PERSONALLY DEFINED STUFF -------------------

----------- GENERAL STUFF -------------------

vim.cmd("set number")

vim.cmd.colorscheme("habamax")

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.api.nvim_set_keymap("n", "<C-T>", ":ToggleTerm<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-y>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

vim.cmd("command! FF Fzf")
vim.keymap.set("n", "<c-P>", require("fzf-lua").files, { desc = "Fzf Files" })
vim.keymap.set("n", "<c-L>", require("fzf-lua").live_grep_glob, { desc = "Fzf Live Global Grep" })
vim.keymap.set("n", "<c-B>", require("fzf-lua").buffers, { desc = "Fzf Buffers" })

vim.diagnostic.open_float(0, { border = "rounded", focusable = false })
