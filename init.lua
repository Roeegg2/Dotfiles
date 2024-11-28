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
		{ "HealsCodes/vim-gas" }, -- highlighting for GAS assembler
		{ "windwp/nvim-autopairs" }, -- auto pairs
		{ "sindrets/diffview.nvim" }, -- nice showing of git diff
		{ "numToStr/Comment.nvim" }, -- commenting plugin
		{ "github/copilot.vim" }, -- copilot
		{ "nvim-treesitter/nvim-treesitter"},
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
			"nvim-tree/nvim-tree.lua", -- view files in tree
			version = "*",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
		},
		{
			"nvim-lualine/lualine.nvim", -- status line
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- automatically check for plugin updates
	checker = { enabled = false },
})

----------- PLUGINS -------------------------

require("nvim-tree").setup({})

require("nvim-web-devicons").setup({})

require("Comment").setup()

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "gruvbox-material",
	},
})

require("diffview").setup({})

require("nvim-autopairs").setup({})

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,
    },
}

----------- GENERAL STUFF -------------------

vim.cmd("colorscheme retrobox")
vim.cmd("set number")

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.api.nvim_set_keymap("n", "<C-y>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

vim.cmd("command! FF Fzf")
vim.keymap.set("n", "<c-P>", require("fzf-lua").files, { desc = "Fzf Files" })
vim.keymap.set("n", "<c-L>", require("fzf-lua").live_grep_glob, { desc = "Fzf Live Global Grep" })
vim.keymap.set("n", "<c-B>", require("fzf-lua").buffers, { desc = "Fzf Buffers" })

vim.diagnostic.open_float(0, { border = "rounded", focusable = false })

----------- PERSONALLY DEFINED STUFF -------------------

function SetupSession()
	local path = vim.api.nvim_buf_get_name(0)
	local session_file = path .. "/Session.vim"
	if vim.fn.filereadable(session_file) == 1 then
		vim.cmd("source " .. session_file) -- restore session
		print("Session restored")
	else
		print("No session found")
	end
end

SetupSession()
