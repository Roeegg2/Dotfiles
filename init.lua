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
		{
			"ibhagwan/fzf-lua",
			-- optional for icon support
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				-- calling `setup` is optional for customization
				require("fzf-lua").setup({})
			end,
		},
		{ "junegunn/fzf", build = "./install --bin" },
		{ "nvim-tree/nvim-web-devicons" },
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
		},
		{ "github/copilot.vim" },
		{ "neovim/nvim-lspconfig" },
		{
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-vsnip",
		},
		{
			"rmagatti/auto-session",
			lazy = false,
			opts = {
				suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" }, -- log_level = 'debug',
			},
		},
		{
			"stevearc/conform.nvim",
			opts = {},
		},
		{ "AlexvZyl/nordic.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
		{
			"nvim-lualine/lualine.nvim",
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
		},
		{ "tpope/vim-fugitive" },
		{ "numToStr/Comment.nvim" },
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
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

----------- PLUGINS -------------------------

require("nvim-treesitter.configs").setup({
	ensure_installed = { "cpp", "c", "go", "python", "lua", "markdown", "markdown_inline" },
})

require("nvim-tree").setup({})

require("lspconfig").pyright.setup({})

require("lspconfig").clangd.setup({})

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

require("nordic").setup({
	italic_comments = true,
})

require("Comment").setup()

require("barbecue.ui").toggle(true)

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "ayu_dark",
	},
})

require("lazy").setup({
	{ "ibhagwan/fzf-lua" },
})

----------- PERSONALLY DEFINED STUFF -------------------

----------- GENERAL STUFF -------------------

vim.cmd("set number")

vim.cmd.colorscheme("nordic")
-- vim.cmd.colorscheme("habamax")

vim.api.nvim_set_keymap(
	"i",
	"<C-j>",
	'copilot#Accept("<C-r>=copilot#GetSelectedCompletion()<CR>")',
	{ noremap = true, silent = true, expr = true }
)

vim.g.copilot_no_tab_map = true
vim.cmd("command! FF Fzf")
vim.keymap.set("n", "<c-P>", require("fzf-lua").files, { desc = "Fzf Files" })
-- Or, with args
vim.keymap.set("n", "<c-P>", function()
	require("fzf-lua").files({})
end, { desc = "Fzf Files" })
