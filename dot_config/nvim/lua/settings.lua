-- General settings
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative numbers
vim.opt.swapfile = false -- Don't use swapfile
vim.opt.backup = false -- Don't create backup files
vim.opt.writebackup = false -- Don't write backup
vim.opt.autowrite = true -- Automatically save before :next, :make etc.
vim.opt.showmatch = true -- Show matching brackets
vim.opt.scrolloff = 8 -- Keep lines above and below cursor
vim.opt.updatetime = 750 -- Improve UX with more reactive updates
vim.opt.wrap = false -- Display long lines as one line
vim.opt.signcolumn = 'yes' -- Display an additional column (useful for linting)

-- A better menu in command mode
vim.opt.wildmode= {'longest:full','full'}

-- Use the OS clipboard
vim.opt.clipboard= {'unnamed','unnamedplus'}

-- Tab config
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Search settings
vim.opt.ignorecase = true -- Search case insensitive...
vim.opt.smartcase = true -- ... but not when search pattern contains upper case characters

-- Set colorscheme
require('colorbuddy').colorscheme('gruvbuddy')
