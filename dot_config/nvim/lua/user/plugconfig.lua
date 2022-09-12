-- Config lualine
require('lualine').setup({
  options = {theme = 'catppuccin'}
})
-- Setup autopairs
require('nvim-autopairs').setup{}
-- Setup gitsigns
require('gitsigns').setup()
-- Setup catppuccin
vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
require("catppuccin").setup({
  integrations = {
    gitsigns = true,
    treesitter = true,
    telescope = true,
  },
})
vim.cmd [[colorscheme catppuccin]]
