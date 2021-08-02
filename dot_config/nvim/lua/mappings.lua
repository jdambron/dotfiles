-- Double esc to remove search highlights
vim.api.nvim_set_keymap('n', '<esc><esc>', ':noh<return><esc>', {noremap = true, silent = true})
-- Replace Y with y$
vim.api.nvim_set_keymap('n', 'Y', 'y$', {noremap = true, silent = true})
