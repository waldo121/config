local builtin = require("telescope.builtin")
require("nvim-treesitter.configs").setup({
	auto_install = true,
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	parser_install_dir = "~/.config/nvim/treesitter/parsers",
})
require("telescope").setup({
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})
require("telescope").load_extension("ui-select")
require("lualine").setup()
require("nvim-web-devicons").setup()
require("mason").setup()
require("mason-lspconfig").setup({
	automatic_installation = true,
})
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.lua_ls.setup({
	capabilities = capabilities,
})
lspconfig.nil_ls.setup({
	capabilities = capabilities,
})
lspconfig.marksman.setup({
	capabilities = capabilities,
})
lspconfig.denols.setup({
	capabilities = capabilities,
})
lspconfig.ruff_lsp.setup({
	capabilities = capabilities,
})
local none_ls = require("null-ls")
none_ls.setup({
	sources = {
		none_ls.builtins.formatting.stylua,
		none_ls.builtins.formatting.alejandra,
	},
})
require("luasnip.loaders.from_vscode").lazy_load()
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),

	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
	},
})
require("inc_rename").setup()
vim.cmd.colorscheme("OceanicNext")
vim.g.mapleader = " "
vim.g.markdown_fenced_languages = {
  "ts=typescript",
  "js=javascript",
  "tsx=typescriptreact",
  "jsx=javascriptreact"
}
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "~", ":Neotree toggle current reveal_force_cwd<cr>")
vim.keymap.set("n", "|", ":Neotree reveal<cr>")
vim.keymap.set("n", "gd", ":Neotree float reveal_file=<cfile> reveal_force_cwd<cr>")
vim.keymap.set("n", "<leader>b", ":Neotree toggle show buffers right<cr>")
vim.keymap.set("n", "<leader>s", ":Neotree float git status<cr>")
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Lsp Hover" })
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Lsp Definition" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Lsp References" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Lsp Action" })
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
vim.keymap.set("n", "<leader>rn", ":IncRename ")
