local options = {
  number = true, -- Show line numbers
  relativenumber = true, -- Show relative numbers
  swapfile = false, -- Don't use swapfile
  backup = false, -- Don't create backup files
  writebackup = false, -- Don't write backup
  autowrite = true, -- Automatically save before :next, :make etc.
  showmatch = true, -- Show matching brackets
  scrolloff = 8, -- Keep lines above and below cursor
  updatetime = 750, -- Improve UX with more reactive updates
  wrap = false, -- Display long lines as one line
  signcolumn = 'yes', -- Display an additional column (useful for linting)
  wildmode = {'longest:full','full'}, -- A better menu in command mode
  tabstop = 2, -- Insert 2 spaces for a tab
  softtabstop = 2, -- Insert 2 spaces for soft tab
  expandtab = true, -- Use spaces instead of tabs when indenting
  ignorecase = true, -- Search case insensitive...
  smartcase = true, -- ... but not when search pattern contains upper case characters
  undofile = true -- Enable persistent undo
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

if vim.loader then
  vim.loader.enable()
end
