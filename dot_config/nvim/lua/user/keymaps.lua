vim.g.mapleader = " "
vim.g.localmapleader = " "
local opts = { noremap = true, silent = true }

-- Normal mode --
-- Double esc to remove search highlights
vim.keymap.set('n', '<esc><esc>', ':noh<return><esc>', opts)
-- Replace Y with y$
vim.keymap.set('n', 'Y', 'y$', opts)
-- Move text up and down
vim.keymap.set("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
vim.keymap.set("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)
-- Insert date in ISO format
vim.keymap.set("n", "<F5>", "\"=strftime(\"%FT%T\")<CR>p", opts)
-- Telescope mappings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fs', function()
  builtin.grep_string({ search  = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Move text up and down
vim.keymap.set("v", "<A-j>", ":m .+1<CR>==", opts)
vim.keymap.set("v", "<A-k>", ":m .-2<CR>==", opts)

-- Visual Block --
-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Insert mode --
-- Insert date in ISO format
vim.keymap.set("i", "<F5>", "<C-R>=strftime(\"%FT%T\")<CR>", opts)
