local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Double esc to remove search highlights
keymap('n', '<esc><esc>', ':noh<return><esc>', opts)
-- Replace Y with y$
keymap('n', 'Y', 'y$', opts)
