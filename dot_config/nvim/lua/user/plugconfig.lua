-- Config lualine
require('lualine').setup({
  options = {theme = 'catppuccin'}
})
-- Setup catppuccin
vim.g.catppuccin_flavour = "frappe" -- latte, frappe, macchiato, mocha
require("catppuccin").setup({
  integrations = {
    gitsigns = true,
    treesitter = true,
    telescope = true,
  },
})
vim.cmd [[colorscheme catppuccin]]
